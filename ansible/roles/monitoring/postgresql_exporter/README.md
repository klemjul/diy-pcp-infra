Role Name
=========

This Ansible role automates the deployment and management of postgres exporter, a exporter that collects and exposes db metrics.

Requirements
------------

- Debian 12
- Postgresql

Role Variables
--------------

Refer to `./defaults/main.yml` comments

Dependencies
------------


Example Playbook
----------------

`ansible-playbook -i openstack.yml -u clouduser pb_postgresql_ha.yml`
