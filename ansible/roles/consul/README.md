Role Name
=========

This Ansible role automates the installation and configuration of Consul.

Requirements
------------

Debian 12

Role Variables
--------------

Refer to `./defaults/main.yml` comments

Dependencies
------------

- community.general.iptables_state

Example Playbook
----------------

`ansible-playbook -i openstack.yml -u clouduser pb_consul.yml`


License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
