terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
  backend "s3" {
    key          = "terraform.diy-pcp-infrastructure.tfstate"
    use_lockfile = true
  }
}
