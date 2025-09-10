resource "vault_github_auth_backend" "github" {
  for_each     = var.github_auths
  organization = try(each.value.organization, each.key)
  path         = try(each.value.path, null)
  dynamic "tune" {
    for_each = try(each.value.tune, {}) != {} ? [1] : []
    content {
      default_lease_ttl            = try(each.value.tune.default_lease_ttl, null)
      max_lease_ttl                = try(each.value.tune.max_lease_ttl, null)
      audit_non_hmac_response_keys = try(each.value.tune.audit_non_hmac_response_keys, null)
      audit_non_hmac_request_keys  = try(each.value.tune.audit_non_hmac_request_keys, null)
      listing_visibility           = try(each.value.tune.listing_visibility, null)
      passthrough_request_headers  = try(each.value.tune.passthrough_request_headers, null)
      allowed_response_headers     = try(each.value.tune.allowed_response_headers, null)
      token_type                   = try(each.value.tune.token_type, "default-service")
    }
  }
}

resource "vault_okta_auth_backend" "okta" {
  for_each        = var.okta_auths
  organization    = try(each.value.organization, each.key)
  base_url        = try(each.value.base_url, null)
  path            = try(each.value.path, null)
  token           = try(each.value.token, null)
  bypass_okta_mfa = try(each.value.bypass_okta_mfa, null)
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
  policies = try(each.value.policies, null)
}


resource "vault_okta_auth_backend_group" "okta" {
  for_each   = var.okta_groups
  path       = vault_okta_auth_backend.okta[each.value.organization].path
  group_name = try(each.value.group_name, each.key)
  policies   = try(each.value.policies, null)
}

resource "vault_okta_auth_backend_user" "okta" {
  for_each = var.okta_users
  path     = vault_okta_auth_backend.okta[each.value.organization].path
  username = try(each.value.username, each.key)
  policies = try(each.value.policies, null)
}

resource "vault_generic_secret" "secret" {
  for_each   = var.secrets
  path       = each.key
  data_json  = each.value
  depends_on = [vault_mount.mounts]
}

resource "vault_kv_secret_v2" "secrets_wo" {
  for_each             = var.secrets_wo
  mount                = each.value.mount
  name                 = try(each.value.name, each.key)
  data_json_wo         = each.value.json
  data_json_wo_version = each.value.version
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
  dynamic "tune" {
    for_each = try(each.value.tune, {}) != {} ? [1] : []
    content {
      default_lease_ttl            = try(each.value.tune.default_lease_ttl, null)
      max_lease_ttl                = try(each.value.tune.max_lease_ttl, null)
      audit_non_hmac_response_keys = try(each.value.tune.audit_non_hmac_response_keys, null)
      audit_non_hmac_request_keys  = try(each.value.tune.audit_non_hmac_request_keys, null)
      listing_visibility           = try(each.value.tune.listing_visibility, null)
      passthrough_request_headers  = try(each.value.tune.passthrough_request_headers, null)
      allowed_response_headers     = try(each.value.tune.allowed_response_headers, null)
      token_type                   = try(each.value.tune.token_type, "default-service")
    }
  }
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
