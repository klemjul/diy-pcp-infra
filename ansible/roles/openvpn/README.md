Role Name
=========

This Ansible role automates the installation and configuration of OpenVPN. It sets up a Public Key Infrastructure (PKI), generates necessary certificates, configures OpenVPN server settings, and applies firewall rules to ensure a secure VPN setup.

Requirements
------------

A Debian-based system (Debian 10/11 or Ubuntu 20.04/22.04)

Role Variables
--------------

Refer to `./defaults/main.yml` comments

Dependencies
------------

- community.general.iptables_state

Example Playbook
----------------

ansible-playbook -i envs/sandbox -l openvpn -u debian playbook.yml

```yml
- name: Install openvpn
  hosts: openvpn
  become: true
  roles:
    - openvpn
```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
