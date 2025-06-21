module "k8sm" {
  source            = "../modules/openstack_instance"
  instance_count              = 3
  instance_name     = "${var.project_prefix}-k8sm"
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

  instance_internal_fixed_ip = "10.0.1.10"

  metadatas                   = {
    project = var.project_prefix,
    app         = "k8sm"
  }
}