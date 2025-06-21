module "k8sw" {
  source            = "../modules/openstack_instance"
  instance_count              = 2
  instance_name     = "${var.project_prefix}-k8sw"
  instance_key_pair = "${var.project_prefix}-key-service-account"
  instance_security_groups = [
    "${var.project_prefix}-sg-all-internal",
    "${var.project_prefix}-k8s-internal-pods",
    "${var.project_prefix}-k8s-internal-services"
  ]

  instance_network_internal_id = data.openstack_networking_network_v2.network.id
  instance_ssh_key             = file(var.ssh_public_key_service_account_path)
  instance_image_id            = var.instance_image_id
  instance_flavor_name        = "a2-ram4-disk20-perf1"

  instance_network_port_allowed_addresses_pairs = ["10.200.0.0/16","10.201.0.0/16"]

  metadatas                   = {
    project = var.project_prefix,
    app         = "k8sw"
  }
}