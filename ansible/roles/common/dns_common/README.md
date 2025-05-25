Role Name
=========

This Ansible task sets up Dnsmasq as a local DNS resolver, disables systemd-resolved, updates DNS settings, and ensures .consul domain forwarding.

Requirements
------------

- Debian 12

Role Variables
--------------

Refer to `./defaults/main.yml` comments

Dependencies
------------


Example Playbook
----------------

`ansible-playbook -i openstack.yml -u clouduser pb_all.yml`
