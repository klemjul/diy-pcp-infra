variables {
  instance_name                = "instance_name"
  instance_image_id            = "instance_image_id"
  instance_key_pair            = "instance_key_pair"
  instance_network_internal_id = "instance_network_internal_id"
  instance_ssh_key             = "instance_ssh_key"
  metadatas                    = { "key" = "value" }
}

mock_provider "openstack" {}

run "should_create_simple_instance" {
  command = apply

  assert {
    condition     = length(resource.openstack_compute_instance_v2.instance) == 1
    error_message = "Instance count must be set to var.instance_count"
  }

  assert {
    condition     = resource.openstack_compute_instance_v2.instance[0].name == "${var.instance_name}1"
    error_message = "Instance name must be set to var.instance_name{count}"
  }

  assert {
    condition     = resource.openstack_compute_instance_v2.instance[0].image_id == var.instance_image_id
    error_message = "Instance image must be set to var.instance_image_id"
  }
  assert {
    condition     = resource.openstack_compute_instance_v2.instance[0].flavor_name == var.instance_flavor_name
    error_message = "Instance flavor must be set to var.instance_flavor_name"
  }

  assert {
    condition     = resource.openstack_compute_instance_v2.instance[0].metadata == var.metadatas
    error_message = "Instance metadata must be set to var.instance_metadata"
  }

  assert {
    condition     = resource.openstack_compute_instance_v2.instance[0].security_groups == toset(var.instance_security_groups)
    error_message = "Instance security groups must be set to var.instance_security_groups"
  }

  assert {
    condition     = resource.openstack_compute_instance_v2.instance[0].key_pair == var.instance_key_pair
    error_message = "Instance key pair must be set to var.instance_key_pair"
  }

  assert {
    condition     = strcontains(resource.openstack_compute_instance_v2.instance[0].user_data, "name: ${var.instance_default_user}")
    error_message = "cloudinit: default instance user must be set to var.instance_default_user"
  }

  assert {
    condition     = strcontains(resource.openstack_compute_instance_v2.instance[0].user_data, "${var.instance_ssh_key}")
    error_message = "cloudinit: ssh key must be set to var.instance_ssh_key"
  }

  assert {
    condition     = strcontains(resource.openstack_compute_instance_v2.instance[0].user_data, "sudo: ALL=(ALL) NOPASSWD:ALL")
    error_message = "cloudinit: default instance sudo is NOPASSWD"
  }

  assert {
    condition     = resource.openstack_compute_instance_v2.instance[0].network[0].port == resource.openstack_networking_port_v2.internal_port[0].id
    error_message = "instance must be associated with the internal network"
  }

  assert {
    condition     = length(resource.openstack_networking_floatingip_v2.random_public_fip) == 0
    error_message = "no floating IP resource should be created"
  }

  assert {
    condition     = length(resource.openstack_compute_floatingip_associate_v2.public_fip_assoc) == 0
    error_message = "no floating IP association should be created"
  }

}

run "should_create_instance_with_floating_ip" {
  command = apply

  variables {
    public_floating_ip             = true
    instance_network_external_name = "external_network_name"
    instance_network_external_id   = "external_network_id"
  }

  assert {
    condition = (
      length(data.openstack_networking_subnet_ids_v2.ext_subnets) == 1 &&
      data.openstack_networking_subnet_ids_v2.ext_subnets[0].network_id == var.instance_network_external_id
    )
    error_message = "data ext_subnets must be retrieved from the provided external network"
  }

  assert {
    condition = (
      length(resource.openstack_networking_floatingip_v2.random_public_fip) == 1 &&
      resource.openstack_networking_floatingip_v2.random_public_fip[0].subnet_ids == data.openstack_networking_subnet_ids_v2.ext_subnets[0].ids
    )
    error_message = "floating IP resource ust be created using the external network provided"
  }

  assert {
    condition = (
      length(resource.openstack_compute_floatingip_associate_v2.public_fip_assoc) == 1 &&
      resource.openstack_compute_floatingip_associate_v2.public_fip_assoc[0].floating_ip == resource.openstack_networking_floatingip_v2.random_public_fip[0].address &&
      resource.openstack_compute_floatingip_associate_v2.public_fip_assoc[0].instance_id == resource.openstack_compute_instance_v2.instance[0].id
    )
    error_message = "instance must be associated with the public floating ip"
  }
}

run "should_create_instance_with_fixed_floating_ip" {
  command = apply

  variables {
    public_floating_ip             = true
    instance_network_external_name = "external_network_name"
    instance_network_external_id   = "external_network_id"
    public_floating_ip_fixed       = "0.0.0.0"
  }

  assert {
    condition     = length(resource.openstack_networking_floatingip_v2.random_public_fip) == 0
    error_message = "no floating IP resource should be created"
  }

  assert {
    condition = (
      length(resource.openstack_compute_floatingip_associate_v2.public_fip_assoc) == 1 &&
      resource.openstack_compute_floatingip_associate_v2.public_fip_assoc[0].floating_ip == var.public_floating_ip_fixed &&
      resource.openstack_compute_floatingip_associate_v2.public_fip_assoc[0].instance_id == resource.openstack_compute_instance_v2.instance[0].id
    )
    error_message = "floating IP association should be created with the fixed IP"
  }
}

run "should_create_instance_with_fixed_internal_ip" {
  command = apply

  variables {
    instance_internal_fixed_ip = "0.0.0.10"
    instance_count             = 2
  }

  assert {
    condition     = length(resource.openstack_compute_instance_v2.instance) == var.instance_count
    error_message = "two instances must be created"
  }

  assert {
    condition = (
      resource.openstack_networking_port_v2.internal_port[0].fixed_ip[0].ip_address == "0.0.0.101" &&
      resource.openstack_networking_port_v2.internal_port[1].fixed_ip[0].ip_address == "0.0.0.102"
    )
    error_message = "instances must be associated with the fixed internal IP"
  }
}

run "should_create_instance_with_sudo_password" {
  command = apply

  variables {
    instance_default_user_password_hash = "instance_default_user_password_hash" # gitleaks:allow
  }

  assert {
    condition     = !strcontains(resource.openstack_compute_instance_v2.instance[0].user_data, "sudo: ALL=(ALL) NOPASSWD:ALL")
    error_message = "cloudinit: default instance sudo is not NOPASSWD"
  }

  assert {
    condition     = strcontains(resource.openstack_compute_instance_v2.instance[0].user_data, var.instance_default_user_password_hash)
    error_message = "cloudinit: sudo password must be set to var.instance_default_user_password_hash"
  }
}
