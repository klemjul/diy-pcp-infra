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

variable "network_static_routes" {
  type = list(object({
    destination_cidr : string,
    next_hop : string
  }))
  default = [
    {
      destination_cidr = "10.200.0.0/16"
      next_hop         = "10.0.1.101"
    },
    {
      destination_cidr = "10.200.0.0/16"
      next_hop         = "10.0.1.102"
    },
    {
      destination_cidr = "10.200.0.0/16"
      next_hop         = "10.0.1.103"
    },
    {
      destination_cidr = "10.201.0.0/16"
      next_hop         = "10.0.1.101"
    },
    {
      destination_cidr = "10.201.0.0/16"
      next_hop         = "10.0.1.102"
    },
    {
      destination_cidr = "10.201.0.0/16"
      next_hop         = "10.0.1.103"
    }
  ]
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

variable "openvpn_client_user_list" {
  type    = list(any)
  default = ["user1"]
}

variable "instance_default_user_password_hash" {
  type    = string
  default = null
}

variable "instance_default_user" {
  type        = string
  description = "default user"
  default     = "clouduser"
}

variable "sg_k8s_internal_pods_network_cidr" {
  type    = string
  default = "10.200.0.0/16"
}

variable "sg_k8s_internal_services_network_cidr" {
  type    = string
  default = "10.201.0.0/16"
}
