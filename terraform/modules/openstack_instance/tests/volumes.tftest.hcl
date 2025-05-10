variables {
  instance_name                = "instance_name"
  instance_image_id            = "instance_image_id"
  instance_key_pair            = "instance_key_pair"
  instance_network_internal_id = "instance_network_internal_id"
  instance_ssh_key             = "instance_ssh_key"
}

mock_provider "openstack" {}

run "should_not_attach_volume_by_default" {
  command = apply

  assert {
    condition     = length(keys(resource.openstack_blockstorage_volume_v3.volumes)) == 0
    error_message = "no volumes should be created by default"
  }

  assert {
    condition     = length(resource.openstack_compute_volume_attach_v2.attached) == 0
    error_message = "No volumes should be attached by default"
  }
}

run "should_attach_volume" {
  command = apply

  variables {
    instance_volumes_count = 1
    instance_volumes_size  = 20
  }

  assert {
    condition     = length(resource.openstack_blockstorage_volume_v3.volumes) == 1
    error_message = "Instance count must be set to var.instance_count"
  }

  assert {
    condition     = contains(keys(resource.openstack_blockstorage_volume_v3.volumes), "${var.instance_name}1-volume-0")
    error_message = "1 volume should be created"
  }

  assert {
    condition = (
      resource.openstack_blockstorage_volume_v3.volumes["${var.instance_name}1-volume-0"].size == var.instance_volumes_size &&
      resource.openstack_blockstorage_volume_v3.volumes["${var.instance_name}1-volume-0"].volume_type == var.instance_volumes_type
    )
    error_message = "volume should be created with the correct size and type"
  }

  assert {
    condition = (
      resource.openstack_compute_volume_attach_v2.attached["${var.instance_name}1-volume-0"].instance_id == resource.openstack_compute_instance_v2.instance[0].id &&
      resource.openstack_compute_volume_attach_v2.attached["${var.instance_name}1-volume-0"].device == local.device_names[0] &&
      resource.openstack_compute_volume_attach_v2.attached["${var.instance_name}1-volume-0"].volume_id == resource.openstack_blockstorage_volume_v3.volumes["${var.instance_name}1-volume-0"].id
    )
    error_message = "volume should be attached to the created instance"
  }
}

run "should_prepare_for_multiple_volumes" {
  command = apply

  variables {
    instance_count         = 2
    instance_volumes_count = 2
    instance_volumes_size  = 20
  }

  assert {
    condition = keys(local.instance_volume_map) == [
      "${var.instance_name}1-volume-0",
      "${var.instance_name}1-volume-1",
      "${var.instance_name}2-volume-0",
      "${var.instance_name}2-volume-1"
    ]
    error_message = "4 volumes should be prepared for 2 instances"
  }

  assert {
    condition     = length(resource.openstack_blockstorage_volume_v3.volumes) == 4
    error_message = "4 volumes should be created"
  }

  assert {
    condition     = length(resource.openstack_compute_volume_attach_v2.attached) == 4
    error_message = "4 volumes should be attached"
  }


}
