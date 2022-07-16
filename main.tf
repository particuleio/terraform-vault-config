resource "vault_github_auth_backend" "github" {
  for_each     = var.github_auths
  organization = try(each.value.organization, each.key)
  path         = try(each.value.path, null)
}

resource "vault_github_team" "github" {
  for_each = var.github_roles_teams
  backend  = vault_github_auth_backend.github[each.value.organization].id
  team     = each.value.team
  policies = try(each.value.policies, null)
}

resource "vault_github_user" "github" {
  for_each = var.github_roles_users
  backend  = vault_github_auth_backend.github[each.value.organization].id
  user     = each.value.user
  policies = try(each.value.policues, null)
}

resource "vault_generic_secret" "secret" {
  for_each   = var.secrets
  path       = each.key
  data_json  = each.value
  depends_on = [vault_mount.mounts]
}

resource "vault_policy" "policy" {
  for_each = var.policies
  name     = each.key
  policy   = each.value
}

resource "vault_mount" "mounts" {
  for_each = var.mounts
  path     = try(each.value.path, each.key)
  type     = each.value.type
  options  = try(each.value.options, null)
}

resource "vault_auth_backend" "auth_backends" {
  for_each = var.auth_backends
  type     = each.value.type
  path     = try(each.value.path, each.key)
}

resource "vault_audit" "audit" {
  for_each = var.audits
  type     = each.value.type
  path     = try(each.value.path, null)
  local    = try(each.value.local, false)
  options  = try(each.value.options, null)
}

resource "vault_kubernetes_auth_backend_config" "kubernetes_configs" {
  for_each               = { for k, v in var.auth_backends : k => v if v.type == "kubernetes" }
  backend                = vault_auth_backend.auth_backends[each.key].path
  kubernetes_host        = each.value.kubernetes_host
  kubernetes_ca_cert     = try(each.value.kubernetes_ca_cert, null)
  token_reviewer_jwt     = try(each.value.token_reviewer_jwt, null)
  disable_iss_validation = try(each.value.disable_iss_validation, true)
}

resource "vault_kubernetes_auth_backend_role" "kubernetes" {
  for_each                         = var.kubernetes_roles
  backend                          = try(each.value.backend, null)
  role_name                        = try(each.value.name, each.key)
  bound_service_account_names      = each.value.bound_service_account_names
  bound_service_account_namespaces = each.value.bound_service_account_namespaces
  token_policies                   = try(each.value.token_policies, null)
  depends_on                       = [vault_policy.policy]
}

resource "vault_aws_auth_backend_role" "aws" {
  for_each                        = var.aws_roles
  backend                         = try(each.value.backend, null)
  role                            = try(each.value.role, null)
  auth_type                       = try(each.value.auth_type, null)
  bound_ami_ids                   = try(each.value.bound_ami_ids, null)
  bound_account_ids               = try(each.value.bound_account_ids, null)
  bound_vpc_ids                   = try(each.value.bound_vpc_ids, null)
  bound_subnet_ids                = try(each.value.bound_subnet_ids, null)
  bound_iam_role_arns             = try(each.value.bound_iam_role_arns, null)
  bound_iam_instance_profile_arns = try(each.value.bound_iam_instance_profile_arns, null)
  inferred_entity_type            = try(each.value.inferred_entity_type, null)
  inferred_aws_region             = try(each.value.inferred_aws_region, null)
  token_ttl                       = try(each.value.token_ttl, null)
  token_max_ttl                   = try(each.value.token_max_ttl, null)
  token_policies                  = try(each.value.token_policies, null)
}
