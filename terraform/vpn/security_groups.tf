# allow from everywhere

resource "openstack_networking_secgroup_v2" "sg_ssh" {
  name        = "${var.project_prefix}-sg-ssh-from-all"
  description = "allow ssh from everywhere"
}

resource "openstack_networking_secgroup_rule_v2" "sg_ssh_rule_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_ssh.id
}

resource "openstack_networking_secgroup_v2" "sg_proxy" {
  name        = "${var.project_prefix}-sg-reverse-proxy"
  description = "allow http/https for reverse proxy from everywhere"
}

resource "openstack_networking_secgroup_rule_v2" "sg_http_rule_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_proxy.id
}


resource "openstack_networking_secgroup_rule_v2" "sg_https_rule_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_proxy.id
}

resource "openstack_networking_secgroup_v2" "sg_openvpn" {
  name        = "${var.project_prefix}-sg-open-vpn"
  description = "allow openvpn udp from everywhere"
}

resource "openstack_networking_secgroup_rule_v2" "sg_openvpn_rule_tcp_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1194
  port_range_max    = 1194
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_openvpn.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_openvpn_rule_udp_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 1194
  port_range_max    = 1194
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_openvpn.id
}


# allow from internal network

resource "openstack_networking_secgroup_v2" "sg_ssh_internal" {
  name        = "${var.project_prefix}-sg-ssh-internal"
  description = "allow ssh from internal network"
}

resource "openstack_networking_secgroup_rule_v2" "sg_ssh_internal_rule_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.sg_ssh_internal.id
}


resource "openstack_networking_secgroup_v2" "sg_all_internal" {
  name        = "${var.project_prefix}-sg-all-internal"
  description = "allow all tcp/udp ingress from internal network"
}

resource "openstack_networking_secgroup_rule_v2" "sg_all_internal_rule_tcp_v4" {
  description       = "allow all tcp port from internal network"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 0 # 1
  port_range_max    = 0 # 65535
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.sg_all_internal.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_all_internal_rule_udp_v4" {
  description       = "allow all udp port from internal network"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 0 # 1
  port_range_max    = 0 # 65535
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.sg_all_internal.id
}


resource "openstack_networking_secgroup_v2" "sg_consul" {
  name        = "${var.project_prefix}-sg-consul"
  description = "https://developer.hashicorp.com/consul/docs/install/ports"
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_consul_dns_tcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8600
  port_range_max    = 8600
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.sg_consul.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_consul_dns_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 8600
  port_range_max    = 8600
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.sg_consul.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_consul_http_grpc" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8500
  port_range_max    = 8503
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.sg_consul.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_consul_wlan_tcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8300
  port_range_max    = 8302
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.sg_consul.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_rule_consul_wlan_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 8300
  port_range_max    = 8302
  remote_ip_prefix  = var.network_subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.sg_consul.id
}
