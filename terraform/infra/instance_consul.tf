
module "consul" {
  source                       = "../modules/openstack_instance"
  instance_count               = 3
  instance_name                = "${var.project_prefix}-consul"
  instance_key_pair            = "${var.project_prefix}-key-service-account"
  instance_security_groups     = ["${var.project_prefix}-sg-consul", "${var.project_prefix}-sg-ssh-internal", "default"]
  instance_network_internal_id = data.openstack_networking_network_v2.network.id
  instance_ssh_key             = file(var.ssh_public_key_service_account_path)
  instance_image_id            = var.instance_image_id
  metadatas                    = { "app" = "consul", "project" = var.project_prefix }
}

