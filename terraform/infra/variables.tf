variable "network_external_id" {
  type = string
}

variable "network_external_name" {
  type    = string
  default = "ext-floating1"
}

variable "network_internal" {
  type    = string
  default = "internal"
}

variable "project_prefix" {
  type        = string
  default     = "diypcp"
  description = "prefix for resource names"
}

variable "ssh_public_key_service_account_path" {
  type = string
}

variable "instance_image_id" {
  type = string
}

variable "instance_flavor_name" {
  type    = string
  default = "a1-ram2-disk20-perf1"
}

variable "instance_default_user_password_hash" {
  type    = string
  default = null
}

variable "instance_default_user" {
  type    = string
  default = "clouduser"
}

variable "instance_traefik_public_fixed_ip" {
  type = string
}
