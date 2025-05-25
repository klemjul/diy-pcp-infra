Role Name
=========

This Ansible role automates the installation and configuration of OpenVPN.

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

`ansible-playbook -i envs/sandbox -l openvpn -u clouduser pb_openvpn.yml`
