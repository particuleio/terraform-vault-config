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

resource "vault_identity_mfa_okta" "okta" {
  for_each        = var.okta_mfas
  org_name        = try(each.value.org_name, each.key)
  api_token       = each.value.api_token
  base_url        = try(each.value.base_url, null)
  primary_email   = try(each.value.primary, true)
  username_format = try(each.value.username_format, null)
}

resource "vault_identity_mfa_login_enforcement" "mfa" {
  for_each              = var.mfa_enforcements
  name                  = try(each.value.name, each.key)
  auth_method_accessors = try(each.value.auth_method_accessors, null)
  auth_method_types     = try(each.value.auth_method_types, null)
  identity_entity_ids   = try(each.value.identity_entity_ids, null)
  identity_group_ids    = try(each.value.identity_group_ids, null)
  mfa_method_ids = try(each.value.mfa_method_ids, [
    vault_identity_mfa_okta.okta[each.value.organization].method_id,
    ], null
  )
}

##############
# Identities #
##############

resource "vault_identity_group" "identity_groups" {
  for_each                   = var.identity_groups
  name                       = try(each.value.name, each.key)
  type                       = try(each.value.type, null)
  policies                   = try(each.value.policies, null)
  metadata                   = try(each.value.metadata, null)
  member_entity_ids          = try(each.value.member_entity_ids, null)
  member_group_ids           = try(each.value.member_group_ids, null)
  external_policies          = try(each.value.external_policies, null)
  external_member_entity_ids = try(each.value.external_member_entity_ids, null)
  external_member_group_ids  = try(each.value.external_member_group_ids, null)
}

data "vault_auth_backend" "auth_backend_identities" {
  for_each = var.identity_group_aliases
  path     = each.value.auth_backend
}

resource "vault_identity_group_alias" "identity_group_aliases" {
  for_each       = var.identity_group_aliases
  name           = try(each.value.name, each.key)
  mount_accessor = try(each.value.mount_accessor, data.vault_auth_backend.auth_backend_identities[try(each.value.name, each.key)].accessor)
  canonical_id   = try(each.value.canonical_id, vault_identity_group.identity_groups[try(each.value.name, each.key)].id)
}

#############
# OIDC/JWT #
############

resource "vault_jwt_auth_backend" "jwt_auths" {
  for_each               = var.jwt_auths
  path                   = try(each.value.path, each.key, "oidc")
  disable_remount        = try(each.value.disable_remount, null)
  type                   = try(each.value.type, "oidc")
  description            = try(each.value.description, null)
  oidc_discovery_url     = try(each.value.oidc_discovery_url, null)
  oidc_discovery_ca_pem  = try(each.value.oidc_discovery_ca_pem, null)
  oidc_client_id         = try(each.value.oidc_client_id, null)
  oidc_client_secret     = try(each.value.oidc_client_secret, null)
  oidc_response_mode     = try(each.value.oidc_response_mode, null)
  oidc_response_types    = try(each.value.oidc_response_types, null)
  jwks_url               = try(each.value.jwks_url, null)
  jwks_ca_pem            = try(each.value.jwks_ca_pem, null)
  jwks_pairs             = try(each.value.jwks_pairs, null)
  jwt_validation_pubkeys = try(each.value.jwt_validation_pubkeys, null)
  bound_issuer           = try(each.value.bound_issuer, null)
  jwt_supported_algs     = try(each.value.jwt_supported_algs, null)
  default_role           = try(each.value.default_role, null)
  provider_config        = try(each.value.provider_config, null)
  local                  = try(each.value.locale, null)
  namespace_in_state     = try(each.value.namespace_in_state, null)

  dynamic "tune" {
    for_each = try(each.value.tune, {}) != {} ? [1] : []
    content {
      default_lease_ttl            = try(each.value.tune.default_lease_ttl, "4h")
      max_lease_ttl                = try(each.value.tune.max_lease_ttl, "4h")
      audit_non_hmac_response_keys = try(each.value.tune.audit_non_hmac_response_keys, null)
      audit_non_hmac_request_keys  = try(each.value.tune.audit_non_hmac_request_keys, null)
      listing_visibility           = try(each.value.tune.listing_visibility, "unauth")
      passthrough_request_headers  = try(each.value.tune.passthrough_request_headers, null)
      allowed_response_headers     = try(each.value.tune.allowed_response_headers, null)
      token_type                   = try(each.value.tune.token_type, "default-service")
    }
  }
}

resource "vault_jwt_auth_backend_role" "jwt_auth_roles" {
  for_each                = var.jwt_roles
  backend                 = each.value.backend
  role_name               = try(each.value.role_name, each.key)
  role_type               = try(each.value.role_type, "oidc")
  token_policies          = try(each.value.token_policies, null)
  bound_audiences         = try(each.value.bound_audiences, null)
  bound_claims            = try(each.value.bound_claims, null)
  user_claim              = try(each.value.user_claim, "email")
  groups_claim            = try(each.value.groups_claim, "groups")
  claim_mappings          = try(each.value.claim_mappings, null)
  oidc_scopes             = try(each.value.oidc_scopes, ["openid", "profile", "email", "groups"])
  allowed_redirect_uris   = try(each.value.allowed_redirect_uris, null)
  user_claim_json_pointer = try(each.value.user_claim_json_pointer, null)
  verbose_oidc_logging    = try(each.value.verbose_oidc_logging, null)
  depends_on = [
    vault_jwt_auth_backend.jwt_auths
  ]
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
