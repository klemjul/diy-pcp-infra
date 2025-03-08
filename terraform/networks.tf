resource "openstack_networking_router_v2" "rt1" {
  name                = "${var.project_prefix}-rt1"
  admin_state_up      = "true"
  description         = "router to external network"
  external_network_id = var.network_external_id
}

resource "openstack_networking_network_v2" "network_internal" {
  name           = "${var.project_prefix}-${var.network_internal}"
  admin_state_up = "true"
  description    = "project internal network"
}

resource "openstack_networking_subnet_v2" "network_subnet" {
  name            = "${var.project_prefix}-${var.network_internal}-subnet"
  network_id      = openstack_networking_network_v2.network_internal.id
  cidr            = var.network_subnet_cidr
  ip_version      = 4
  enable_dhcp     = true
  dns_nameservers = ["1.1.1.1", "8.8.8.8"]
}

resource "openstack_networking_router_interface_v2" "network_router_interface" {
  router_id = openstack_networking_router_v2.rt1.id
  subnet_id = openstack_networking_subnet_v2.network_subnet.id
}

