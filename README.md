# terraform-module-template

Repository template for Particule's Terraform module.

## Usage


### Examples

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.11 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_audit.audit](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/audit) | resource |
| [vault_auth_backend.auth_backends](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend) | resource |
| [vault_aws_auth_backend_role.aws](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/aws_auth_backend_role) | resource |
| [vault_generic_secret.secret](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [vault_github_auth_backend.github](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/github_auth_backend) | resource |
| [vault_github_team.github](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/github_team) | resource |
| [vault_github_user.github](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/github_user) | resource |
| [vault_identity_mfa_login_enforcement.mfa](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_mfa_login_enforcement) | resource |
| [vault_identity_mfa_okta.okta](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_mfa_okta) | resource |
| [vault_kubernetes_auth_backend_config.kubernetes_configs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_config) | resource |
| [vault_kubernetes_auth_backend_role.kubernetes](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_role) | resource |
| [vault_kv_secret_v2.secrets_wo](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_mount.mounts](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |
| [vault_okta_auth_backend.okta](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/okta_auth_backend) | resource |
| [vault_okta_auth_backend_group.okta](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/okta_auth_backend_group) | resource |
| [vault_okta_auth_backend_user.okta](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/okta_auth_backend_user) | resource |
| [vault_policy.policy](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_audits"></a> [audits](#input\_audits) | n/a | `any` | `{}` | no |
| <a name="input_auth_backends"></a> [auth\_backends](#input\_auth\_backends) | n/a | `any` | `{}` | no |
| <a name="input_aws_roles"></a> [aws\_roles](#input\_aws\_roles) | n/a | `any` | `{}` | no |
| <a name="input_github_auths"></a> [github\_auths](#input\_github\_auths) | n/a | `any` | `{}` | no |
| <a name="input_github_roles_teams"></a> [github\_roles\_teams](#input\_github\_roles\_teams) | n/a | `any` | `{}` | no |
| <a name="input_github_roles_users"></a> [github\_roles\_users](#input\_github\_roles\_users) | n/a | `any` | `{}` | no |
| <a name="input_kubernetes_roles"></a> [kubernetes\_roles](#input\_kubernetes\_roles) | n/a | `any` | `{}` | no |
| <a name="input_mfa_enforcements"></a> [mfa\_enforcements](#input\_mfa\_enforcements) | n/a | `any` | `{}` | no |
| <a name="input_mounts"></a> [mounts](#input\_mounts) | n/a | `any` | `{}` | no |
| <a name="input_okta_auths"></a> [okta\_auths](#input\_okta\_auths) | n/a | `any` | `{}` | no |
| <a name="input_okta_groups"></a> [okta\_groups](#input\_okta\_groups) | n/a | `any` | `{}` | no |
| <a name="input_okta_mfas"></a> [okta\_mfas](#input\_okta\_mfas) | n/a | `any` | `{}` | no |
| <a name="input_okta_users"></a> [okta\_users](#input\_okta\_users) | n/a | `any` | `{}` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | n/a | `map(any)` | `{}` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | n/a | `any` | `{}` | no |
| <a name="input_secrets_wo"></a> [secrets\_wo](#input\_secrets\_wo) | n/a | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vault_audit"></a> [vault\_audit](#output\_vault\_audit) | n/a |
| <a name="output_vault_auth_backend"></a> [vault\_auth\_backend](#output\_vault\_auth\_backend) | n/a |
| <a name="output_vault_aws_auth_backend_role"></a> [vault\_aws\_auth\_backend\_role](#output\_vault\_aws\_auth\_backend\_role) | n/a |
| <a name="output_vault_generic_secret"></a> [vault\_generic\_secret](#output\_vault\_generic\_secret) | n/a |
| <a name="output_vault_github_auth_backend"></a> [vault\_github\_auth\_backend](#output\_vault\_github\_auth\_backend) | n/a |
| <a name="output_vault_github_team"></a> [vault\_github\_team](#output\_vault\_github\_team) | n/a |
| <a name="output_vault_github_user"></a> [vault\_github\_user](#output\_vault\_github\_user) | n/a |
| <a name="output_vault_identity_mfa_okta"></a> [vault\_identity\_mfa\_okta](#output\_vault\_identity\_mfa\_okta) | n/a |
| <a name="output_vault_kubernetes_auth_backend_config"></a> [vault\_kubernetes\_auth\_backend\_config](#output\_vault\_kubernetes\_auth\_backend\_config) | n/a |
| <a name="output_vault_kubernetes_auth_backend_role"></a> [vault\_kubernetes\_auth\_backend\_role](#output\_vault\_kubernetes\_auth\_backend\_role) | n/a |
| <a name="output_vault_kv_secret_v2"></a> [vault\_kv\_secret\_v2](#output\_vault\_kv\_secret\_v2) | n/a |
| <a name="output_vault_mount"></a> [vault\_mount](#output\_vault\_mount) | n/a |
| <a name="output_vault_okta_auth_backend"></a> [vault\_okta\_auth\_backend](#output\_vault\_okta\_auth\_backend) | n/a |
| <a name="output_vault_okta_auth_backend_group"></a> [vault\_okta\_auth\_backend\_group](#output\_vault\_okta\_auth\_backend\_group) | n/a |
| <a name="output_vault_okta_auth_backend_user"></a> [vault\_okta\_auth\_backend\_user](#output\_vault\_okta\_auth\_backend\_user) | n/a |
| <a name="output_vault_policy"></a> [vault\_policy](#output\_vault\_policy) | n/a |
<!-- END_TF_DOCS -->
