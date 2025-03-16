variable "network_name" {
  type = string
}

variable "network_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "network_subnet_allocation_pool" {
  type = object({
    start = string
    end   = string
  })
  default = {
    start = "10.0.1.50"
    end   = "10.0.1.200"
  }
}

variable "network_subnet_ip_version" {
  type    = number
  default = 4
}

variable "network_subnet_dhcp_enable" {
  type    = string
  default = "true"
}

variable "network_subnet_dns" {
  type    = list(any)
  default = ["1.1.1.1", "8.8.8.8"]
}

variable "router_id" {
  type        = string
  description = "ID of an existing router to attach the network to"
}
