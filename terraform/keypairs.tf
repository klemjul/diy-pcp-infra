resource "openstack_compute_keypair_v2" "ssh_public_key" {
  name       = "${var.project_prefix}-key-service-account"
  public_key = file(var.ssh_public_key_service_account_path)
}
