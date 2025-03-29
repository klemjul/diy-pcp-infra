Role Name
=========

This Ansible task ensures Traefik is installed, configured, and running. It configures automatic TLS using lets encrypt and integrates Traefik with a Consul provider.

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

`ansible-playbook -i openstack.yml -u clouduser pb_traefik.yml`
