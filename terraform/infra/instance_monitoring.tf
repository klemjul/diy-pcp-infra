
module "monitoring" {
  source            = "../modules/openstack_instance"
  instance_count    = 1
  instance_name     = "${var.project_prefix}-monitoring"
  instance_key_pair = "${var.project_prefix}-key-service-account"
  instance_security_groups = [
    "${var.project_prefix}-sg-consul",
    "${var.project_prefix}-sg-ssh-internal",
    "${var.project_prefix}-sg-node-exporter",
    "${var.project_prefix}-sg-all-internal"
  ]
  instance_network_internal_id = data.openstack_networking_network_v2.network.id
  instance_ssh_key             = file(var.ssh_public_key_service_account_path)
  instance_image_id            = var.instance_image_id
  instance_volumes_count       = var.loki_standalone_instance ? 1 : 2
  instance_flavor_name         = var.loki_standalone_instance ? "a1-ram2-disk20-perf1" : "a2-ram4-disk20-perf1"
  metadatas = {
    "project" = var.project_prefix
    "app"     = "monitoring"
  }
}

