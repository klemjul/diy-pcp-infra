variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "project_prefix" {
  type        = string
  default     = "diypcp"
  description = "prefix for resource names"
}
