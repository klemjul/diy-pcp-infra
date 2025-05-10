variables {
  network_name = "network_name"
  router_id    = "router_id"
}

mock_provider "openstack" {}

run "should_create_network" {
  command = plan

  assert {
    condition     = resource.openstack_networking_network_v2.network_name.name == var.network_name
    error_message = "network name must be set to var.network_name"
  }

  assert {
    condition     = resource.openstack_networking_network_v2.network_name.admin_state_up == true
    error_message = "Admin state should be true"
  }
}

run "should_create_subnet" {
  command = apply

  assert {
    condition     = resource.openstack_networking_subnet_v2.network_subnet.name == var.network_name
    error_message = "network subnet name must be set to var.network_name"
  }

  assert {
    condition     = resource.openstack_networking_subnet_v2.network_subnet.network_id == resource.openstack_networking_network_v2.network_name.id
    error_message = "Network ID must be set to the ID of the network"
  }

  assert {
    condition     = resource.openstack_networking_subnet_v2.network_subnet.cidr == var.network_subnet_cidr
    error_message = "Network CIDR must be set to var.network_subnet_cidr"
  }

  assert {
    condition     = resource.openstack_networking_subnet_v2.network_subnet.ip_version == var.network_subnet_ip_version
    error_message = "Network IP version must be set to var.network_subnet_ip_version"
  }

  assert {
    condition     = resource.openstack_networking_subnet_v2.network_subnet.enable_dhcp == tobool(var.network_subnet_dhcp_enable)
    error_message = "DHCP must be set to var.network_subnet_dhcp_enable"
  }

  assert {
    condition     = resource.openstack_networking_subnet_v2.network_subnet.dns_nameservers == var.network_subnet_dns
    error_message = "DNS nameservers must be set to var.network_subnet_dns"
  }

  assert {
    condition     = length([for pool in resource.openstack_networking_subnet_v2.network_subnet.allocation_pool : pool.start if pool.start == var.network_subnet_allocation_pool.start]) > 0
    error_message = "Allocation pool does not contain the expected start IP"
  }

  assert {
    condition     = length([for pool in resource.openstack_networking_subnet_v2.network_subnet.allocation_pool : pool.start if pool.end == var.network_subnet_allocation_pool.end]) > 0
    error_message = "Allocation pool does not contain the expected end IP"
  }

}

run "should_create_router_interface" {
  command = apply

  assert {
    condition     = resource.openstack_networking_router_interface_v2.network_router_interface.router_id == var.router_id
    error_message = "Router ID must be set to var.router_id"
  }

  assert {
    condition     = resource.openstack_networking_router_interface_v2.network_router_interface.subnet_id == resource.openstack_networking_subnet_v2.network_subnet.id
    error_message = "Router interface should reference the correct subnet"
  }
}

