Role Name
=========

This Ansible role installs and configures Loki, a log aggregation system. It sets up the necessary configuration files and ensures Loki is running as a service.

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

`ansible-playbook -u clouduser -i openstack.yml pb_logging.yml`