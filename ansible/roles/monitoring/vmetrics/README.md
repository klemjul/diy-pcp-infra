Role Name
=========

This Ansible role automates the deployment and management of VictoriaMetrics, a high-performance time-series database. It ensures that VictoriaMetrics is installed, configured, and running as a systemd service.

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

`ansible-playbook -i openstack.yml -u clouduser pb_monitoring.yml`
