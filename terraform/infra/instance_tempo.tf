module "tempo" {
  source            = "../modules/openstack_instance"
  instance_count    = var.deploy_tempo ? 1 : 0
  instance_name     = "${var.project_prefix}-tempo"
  instance_key_pair = "${var.project_prefix}-key-service-account"
  instance_security_groups = [
    "${var.project_prefix}-sg-all-internal",
  ]
  instance_network_internal_id = data.openstack_networking_network_v2.network.id
  instance_ssh_key             = file(var.ssh_public_key_service_account_path)
  instance_image_id            = var.instance_image_id

  instance_volumes_count = 1
  metadatas = {
    project = var.project_prefix,
    app     = "tempo"
  }
}
