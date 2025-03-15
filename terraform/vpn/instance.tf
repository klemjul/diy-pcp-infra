
module "instance_openvpn" {
  source                         = "../modules/openstack_instance"
  instance_name                  = "${var.project_prefix}-openvpn"
  instance_ssh_key               = file(var.ssh_public_key_service_account_path)
  instance_key_pair              = openstack_compute_keypair_v2.ssh_public_key.name
  instance_security_groups       = [openstack_networking_secgroup_v2.sg_openvpn.name, openstack_networking_secgroup_v2.sg_ssh.name, "default"]
  instance_network_internal_id   = module.network.network_id
  instance_network_external_name = var.network_external_name
  instance_network_external_id   = var.network_external_id
  instance_image_id              = var.instance_image_id
  instance_count                 = 1
  public_floating_ip             = true
  depends_on = [
    module.network,
    openstack_networking_secgroup_rule_v2.sg_openvpn_rule_udp_v4

  ]
}
