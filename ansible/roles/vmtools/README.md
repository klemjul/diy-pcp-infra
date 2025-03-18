Role Name
=========

This Ansible role installs and configures vmtools and make them work with consul service discovery.
- vmagent: vmagent is a tiny agent which helps you collect metrics from various source
- vmalert: vmalert executes a list of the given alerting or recording rules

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

`nsible-playbook -u clouduser -i openstack.yml pb_monitoring.yml"`
