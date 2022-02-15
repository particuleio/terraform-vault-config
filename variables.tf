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

variable "kubernetes_roles" {
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
