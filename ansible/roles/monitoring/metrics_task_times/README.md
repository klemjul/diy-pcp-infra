Role Name
=========

This ansible role install cron and a shell script to create open metric (.prom) files based on a folder that contains "touch" files.

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

`ansible-playbook -i openstack.yml -u clouduser pb_consul.yml`

