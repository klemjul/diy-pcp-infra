
module "instance_openvpn" {
  source            = "../modules/openstack_instance"
  instance_name     = "${var.project_prefix}-openvpn"
  instance_ssh_key  = file(var.ssh_public_key_service_account_path)
  instance_key_pair = openstack_compute_keypair_v2.ssh_public_key.name
  instance_security_groups = [
    openstack_networking_secgroup_v2.sg_openvpn.name,
    openstack_networking_secgroup_v2.sg_ssh.name,
    openstack_networking_secgroup_v2.sg_consul.name,
    openstack_networking_secgroup_v2.sg_node_exporter.name,
    openstack_networking_secgroup_v2.sg_all_internal.name,
  ]
  instance_network_internal_id        = module.network.network_id
  instance_network_external_name      = var.network_external_name
  instance_network_external_id        = var.network_external_id
  instance_internal_fixed_ip          = "10.0.1.1" # static IP for OpenVPN server 10.0.1.11
  instance_image_id                   = var.instance_image_id
  instance_count                      = 1
  public_floating_ip                  = true
  instance_default_user_password_hash = var.instance_default_user_password_hash
  metadatas                           = { "app" = "openvpn", "project" = var.project_prefix }
  depends_on = [
    module.network,
    openstack_networking_secgroup_rule_v2.sg_openvpn_rule_udp_v4,
    openstack_networking_secgroup_rule_v2.sg_openvpn_rule_tcp_v4,
    openstack_networking_secgroup_rule_v2.sg_ssh_rule_v4,
    openstack_networking_secgroup_rule_v2.sg_rule_consul_dns_tcp,
    openstack_networking_secgroup_rule_v2.sg_rule_consul_dns_udp,
    openstack_networking_secgroup_rule_v2.sg_rule_consul_http_grpc,
    openstack_networking_secgroup_rule_v2.sg_rule_node_exporter,
    openstack_networking_secgroup_rule_v2.sg_all_internal_rule_tcp_v4
  ]
}
