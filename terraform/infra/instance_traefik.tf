module "traefik" {
  source            = "../modules/openstack_instance"
  instance_count    = 1
  instance_name     = "${var.project_prefix}-traefik"
  instance_key_pair = "${var.project_prefix}-key-service-account"
  instance_security_groups = [
    "${var.project_prefix}-sg-consul",
    "${var.project_prefix}-sg-ssh-internal",
    "${var.project_prefix}-sg-node-exporter",
    "${var.project_prefix}-sg-all-internal",
    "${var.project_prefix}-sg-reverse-proxy"
  ]
  instance_network_internal_id   = data.openstack_networking_network_v2.network.id
  instance_ssh_key               = file(var.ssh_public_key_service_account_path)
  instance_image_id              = var.instance_image_id
  instance_network_external_name = var.network_external_name
  instance_network_external_id   = var.network_external_id
  public_floating_ip             = true
  public_floating_ip_fixed       = var.instance_traefik_public_fixed_ip
  metadatas = {
    "project" = var.project_prefix,
    app       = "traefik"
  }
}
