resource "openstack_networking_router_v2" "rt1" {
  name                = "${var.project_prefix}-rt1"
  admin_state_up      = "true"
  description         = "router to external network"
  external_network_id = var.network_external_id
}

module "network" {
  source              = "./modules/openstack_network"
  network_name        = "${var.project_prefix}-${var.network_internal}"
  network_subnet_cidr = var.network_subnet_cidr
  router_id           = openstack_networking_router_v2.rt1.id
}
