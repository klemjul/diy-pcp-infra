data "openstack_networking_subnet_ids_v2" "ext_subnets" {
  network_id = var.network_external_id
}

resource "openstack_networking_floatingip_v2" "fip_1" {
  pool       = var.network_external_name
  subnet_ids = data.openstack_networking_subnet_ids_v2.ext_subnets.ids
}

resource "openstack_compute_instance_v2" "instance_openvpn" {
  name        = "${var.project_prefix}-instance-openvpn"
  image_id    = var.instance_image_id
  flavor_name = var.instance_flavor_name
  metadata = {
    "project" = var.project_prefix
  }
  security_groups = [openstack_networking_secgroup_v2.sg_openvpn.name, openstack_networking_secgroup_v2.sg_ssh.name, "default"]
  key_pair        = openstack_compute_keypair_v2.ssh_public_key.name
  network {
    name = openstack_networking_network_v2.network_internal.name
  }

  depends_on = [
    openstack_networking_subnet_v2.network_subnet,
    openstack_networking_secgroup_v2.sg_openvpn,
    openstack_networking_secgroup_rule_v2.sg_ssh_rule_v4,
    openstack_compute_keypair_v2.ssh_public_key
  ]
}


resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.fip_1.address
  instance_id = openstack_compute_instance_v2.instance_openvpn.id
}
