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

variable "network_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
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
  type        = string
  description = "Debian 12 bookworm"
}

variable "instance_flavor_name" {
  type    = string
  default = "a1-ram2-disk20-perf1"
}
