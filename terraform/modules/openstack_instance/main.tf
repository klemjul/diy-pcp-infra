data "openstack_networking_subnet_ids_v2" "ext_subnets" {
  count      = var.public_floating_ip ? 1 : 0
  network_id = var.instance_network_external_id
}

resource "openstack_compute_instance_v2" "instance" {
  count           = var.instance_count
  name            = "${var.instance_name}${count.index + 1}"
  image_id        = var.instance_image_id
  flavor_name     = var.instance_flavor_name
  metadata        = var.metadatas
  security_groups = var.instance_security_groups
  key_pair        = var.instance_key_pair
  user_data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
    instance_ssh_key                    = var.instance_ssh_key,
    instance_default_user_password_hash = var.instance_default_user_password_hash
    instance_default_user               = var.instance_default_user
  })
  network {
    uuid        = var.instance_network_internal_id
    fixed_ip_v4 = var.instance_internal_fixed_ip != null ? "${var.instance_internal_fixed_ip}${count.index + 1}" : null
  }
}

resource "openstack_networking_floatingip_v2" "random_public_fip" {
  count      = var.public_floating_ip && var.public_floating_ip_fixed == null ? var.instance_count : 0
  pool       = var.instance_network_external_name
  subnet_ids = data.openstack_networking_subnet_ids_v2.ext_subnets[0].ids
}

resource "openstack_compute_floatingip_associate_v2" "public_fip_assoc" {
  count       = var.public_floating_ip ? var.instance_count : 0
  floating_ip = var.public_floating_ip_fixed != null ? var.public_floating_ip_fixed : openstack_networking_floatingip_v2.random_public_fip[count.index].address
  instance_id = openstack_compute_instance_v2.instance[count.index].id
}
