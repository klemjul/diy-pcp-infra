data "openstack_networking_network_v2" "network" {
  name = "${var.project_prefix}-${var.network_internal}"
}
