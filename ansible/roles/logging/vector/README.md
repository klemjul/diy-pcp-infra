Role Name
=========

This Ansible role setup Vector to collect, transform, and route logs to loki.

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

`ansible-playbook -u clouduser -i openstack.yml pb_all.yml`
`ansible-playbook -u clouduser -i openstack.yml pb_traefik.yml`