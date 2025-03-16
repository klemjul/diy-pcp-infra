variable "instance_network_external_name" {
  type        = string
  description = "Name of the existing external network"
  default     = null
}

variable "instance_network_external_id" {
  type        = string
  description = "ID of the existing external network"
  default     = null
}

variable "instance_name" {
  type = string
}

variable "instance_image_id" {
  type        = string
  description = "Openstack image ID"
}

variable "instance_flavor_name" {
  type        = string
  description = "Openstack flavor name"
  default     = "a1-ram2-disk20-perf1"
}

variable "instance_security_groups" {
  type        = list(string)
  default     = ["default"]
  description = "Openstack security group names"
}

variable "instance_key_pair" {
  type        = string
  description = "Openstack key pair name"
}

variable "metadatas" {
  type    = map(string)
  default = {}
}

variable "instance_network_internal_id" {
  type        = string
  description = "ID of the existing internal network"
}

variable "instance_count" {
  type    = number
  default = 1

  validation {
    condition     = !(var.instance_count > 1 && var.public_floating_ip_fixed != null)
    error_message = "Instance_count must be 1, when public_floating_ip_fixed is set"
  }
}

variable "public_floating_ip" {
  type        = bool
  default     = false
  description = "Determine if a public floating ip should be created"
  validation {
    condition     = !(var.public_floating_ip) || (var.instance_network_external_id != null && var.instance_network_external_name != null)
    error_message = "When public_floating_ip is set to true, both instance_network_external_id and instance_network_external_name must be set."
  }
}

variable "public_floating_ip_fixed" {
  type    = string
  default = null
  validation {
    condition     = !(!var.public_floating_ip && var.public_floating_ip_fixed != null)
    error_message = "When public_floating_ip_fixed is set, public_floating_ip must be true"
  }
  description = "Determine if an existing public floating ip should be reused"
}

variable "instance_internal_fixed_ip" {
  type        = string
  default     = null
  description = "Determine of the fixed ip to use in the internal network"
}

variable "instance_ssh_key" {
  type        = string
  description = "SSH public key to inject into the instance"
}

variable "instance_volumes_count" {
  type    = number
  default = 0
}

variable "instance_volumes_size" {
  type    = number
  default = 20
}

variable "instance_volumes_type" {
  type    = string
  default = "CEPH_1_perf1"
}

variable "instance_default_user_password_hash" {
  type        = string
  description = "enable password on sudo commands for default user, generate a hash via: openssl passwd -6 ''"
  default     = null
}
variable "instance_default_user" {
  type        = string
  description = "default user"
  default     = "clouduser"
}
