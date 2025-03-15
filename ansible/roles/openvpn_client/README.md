Role Name
=========

This role is used to create and configure OpenVPN client certificates and configuration files.

Requirements
------------

- Debian 12
- packages installed: `easyrsa`, `openvpn`

Role Variables
--------------

Refer to `./defaults/main.yml` comments

Dependencies
------------


Example Playbook
----------------

`ansible-playbook -i envs/sandbox -l openvpn -u clouduser pb_openvpn_client.yml`

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
