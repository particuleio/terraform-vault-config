# The module's outputs

output "vault_github_auth_backend" {
  value = vault_github_auth_backend.github
}

output "vault_okta_auth_backend" {
  value     = vault_okta_auth_backend.okta
  sensitive = true
}

output "vault_identity_mfa_okta" {
  value     = vault_identity_mfa_okta.okta
  sensitive = true
}

output "vault_github_team" {
  value = vault_github_team.github
}

output "vault_github_user" {
  value = vault_github_user.github
}

output "vault_okta_auth_backend_group" {
  value = vault_okta_auth_backend_group.okta
}

output "vault_okta_auth_backend_user" {
  value = vault_okta_auth_backend_user.okta
}

output "vault_generic_secret" {
  value     = vault_generic_secret.secret
  sensitive = true
}

output "vault_kv_secret_v2" {
  value     = vault_kv_secret_v2.secrets_wo
  sensitive = true
}

output "vault_policy" {
  value = vault_policy.policy
}

output "vault_mount" {
  value = vault_mount.mounts
}

output "vault_auth_backend" {
  value = vault_auth_backend.auth_backends
}

output "vault_audit" {
  value = vault_audit.audit
}

output "vault_kubernetes_auth_backend_role" {
  value = vault_kubernetes_auth_backend_role.kubernetes
}

output "vault_aws_auth_backend_role" {
  value = vault_aws_auth_backend_role.aws
}
