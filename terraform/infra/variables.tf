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

variable "instance_traefik_public_fixed_ip" {
  type = string
}

variable "consul_server_count" {
  type    = number
  default = 1
  validation {
    condition     = var.consul_server_count == 1 || var.consul_server_count == 3
    error_message = "consul_server_count must be either 1 or 3."
  }
}

variable "loki_standalone_instance" {
  type        = bool
  default     = false
  description = "If true, deploys Loki as a standalone instance. If false, deploys Loki in the monitoring instance."
}

variable "deploy_postgresql" {
  type        = bool
  default     = false
  description = "If true, deploys Postgresql instance."
}

variable "deploy_mattermost" {
  type        = bool
  default     = false
  description = "If true, deploys Mattermost instance."
  validation {
    condition     = (var.deploy_postgresql == true && var.deploy_mattermost == true) || var.deploy_mattermost == false
    error_message = "deploy_mattermost can be true only if postgresql instance if deployed"
  }
}

variable "deploy_gitlab" {
  type        = bool
  default     = false
  description = "If true, deploys Gitlab instance."
}

variable "deploy_keycloak" {
  type        = bool
  default     = false
  description = "If true, deploys Keycloak instance."
  validation {
    condition     = (var.deploy_postgresql == true && var.deploy_keycloak == true) || var.deploy_keycloak == false
    error_message = "deploy_gitlab can be true only if postgresql instance if deployed"
  }
}