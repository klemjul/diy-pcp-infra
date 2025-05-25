Role Name
=========

This Ansible role automates the process of creating an ext4 file system, ensuring a mount directory exists, adding the entry to /etc/fstab, and mounting the disk.

Requirements
------------

- Debian 12

Role Variables
--------------

Refer to `./defaults/main.yml` comments

Dependencies
------------

`community.general.filesystem`


Example Playbook
----------------

```yaml
- hosts: all
  become: yes
  roles:
    - role: mount_filesystem
      vars:
        volumes:
          - disk: "/dev/sdc"
            path: "/mnt/data"
            owner: "ubuntu"
            group: "ubuntu"
            mode: "0755"
```