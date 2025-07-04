
resource "null_resource" "ansible_openvpn_server" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<-EOT
      sleep 20s;
      echo > /tmp/openvpn.ini;
      echo "[openvpn]" | tee -a /tmp/openvpn.ini;
      echo "${module.instance_openvpn.instance_compute_name[0]} ansible_host=${module.instance_openvpn.instance_external_ip[0]}" | tee -a /tmp/openvpn.ini;

      ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -u ${var.instance_default_user} -i /tmp/openvpn.ini \
        -e @../../ansible/envs/sandbox/group_vars/openvpn.yml \
        ../../ansible/pb_openvpn.yml
    EOT
  }
  depends_on = [
    module.instance_openvpn,
  ]
}

resource "null_resource" "ansible_openvpn_server_client" {
  for_each = toset(var.openvpn_client_user_list)
  triggers = {
    name       = each.value
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -u ${var.instance_default_user} -i /tmp/openvpn.ini \
        -e @../../ansible/envs/sandbox/group_vars/openvpn.yml \
        -e "openvpn_client_user_list=['${each.value}']" \
        ../../ansible/pb_openvpn_client.yml

      rm -f /tmp/openvpn.ini;
    EOT
  }
  depends_on = [
    null_resource.ansible_openvpn_server
  ]
}
