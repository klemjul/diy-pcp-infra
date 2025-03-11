output "instance_internal_ip" {
  value       = try(openstack_compute_instance_v2.instance[*].network[0].fixed_ip_v4, null)
  description = "Internal IP(s) of the instance(s)"
}

output "instance_compute_name" {
  value       = try(openstack_compute_instance_v2.instance[*].network[0].name, null)
  description = "Name(s) of the instance(s)"
}

output "instance_external_ip" {
  value       = try(openstack_compute_floatingip_associate_v2.public_fip_assoc[*].floating_ip, null)
  description = "External IP(s) of the instance(s)"
}

