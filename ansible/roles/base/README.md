Role Name
=========

This Ansible task removes the debian user, installs essential utilities (curl, wget, etc.), and sets up security tools (rkhunter & clamav).

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

`ansible-playbook -i openstack.yml -u clouduser pb_all.yml`

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
