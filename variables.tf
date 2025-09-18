variable "policies" {
  type    = map(any)
  default = {}
}

variable "mounts" {
  type    = any
  default = {}
}

variable "secrets" {
  type    = any
  default = {}
}

variable "secrets_wo" {
  type    = any
  default = {}
}

variable "kubernetes_roles" {
  type    = any
  default = {}
}

variable "aws_roles" {
  type    = any
  default = {}
}

variable "github_roles_teams" {
  type    = any
  default = {}
}

variable "github_roles_users" {
  type    = any
  default = {}
}

variable "github_auths" {
  type    = any
  default = {}
}

variable "auth_backends" {
  type    = any
  default = {}
}

variable "audits" {
  type    = any
  default = {}
}

variable "okta_auths" {
  type    = any
  default = {}
}

variable "okta_groups" {
  type    = any
  default = {}
}

variable "okta_users" {
  type    = any
  default = {}
}

variable "okta_mfas" {
  type    = any
  default = {}
}

variable "mfa_enforcements" {
  type    = any
  default = {}
}

variable "jwt_auths" {
  type    = any
  default = {}
}

variable "jwt_roles" {
  type    = any
  default = {}
}

variable "identity_groups" {
  type    = any
  default = {}
}

variable "identity_group_aliases" {
  type    = any
  default = {}
}
