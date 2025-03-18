Role Name
=========

This Ansible role installs and configures Grafana. Grafana is an analytics and visualization platform for monitoring and observability.

Requirements
------------

- Debian 12
- gnupg,software-properties-common

Role Variables
--------------

Refer to `./defaults/main.yml` comments

Dependencies
------------


Example Playbook
----------------

`ansible-playbook -i openstack.yml -u clouduser pb_monitoring.yml`
