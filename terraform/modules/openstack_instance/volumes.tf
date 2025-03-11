locals {
  device_names = ["/dev/sdb", "/dev/sdc", "/dev/sdd", "/dev/sde", "/dev/sdf", "/dev/sdg"]
}

locals {
  instance_volume_map = merge([

    for idxi, instance in openstack_compute_instance_v2.instance.* :
    {
      for idxv in range(var.instance_volumes_count) :
      "${instance.name}-volume-${idxv}" => {
        instance_name = instance.name
        instance_id   = instance.id
        volume_name   = "${instance.name}-volume-${idxv}"
        device        = local.device_names[idxv]
      }
    }

  ]...)
}

resource "openstack_blockstorage_volume_v3" "volumes" {
  for_each = local.instance_volume_map

  name        = each.value.volume_name
  size        = var.instance_volumes_size
  volume_type = var.instance_volumes_type
  depends_on  = [openstack_compute_instance_v2.instance]
}

resource "openstack_compute_volume_attach_v2" "attached" {
  for_each = local.instance_volume_map

  instance_id = each.value.instance_id
  device      = each.value.device
  volume_id   = openstack_blockstorage_volume_v3.volumes[each.key].id
  # Prevent re-creation
  lifecycle {
    ignore_changes = [volume_id, instance_id, device]
  }
  depends_on = [openstack_blockstorage_volume_v3.volumes]
}
