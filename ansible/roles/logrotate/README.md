Role Name
=========

This Ansible role automates the installation and configuration of logrotate.

Requirements
------------

Debian 12

Role Variables
--------------

Refer to `./defaults/main.yml` comments and example playbook

Dependencies
------------


Example Playbook
----------------

```yml
  vars:
    logrotate_frequency: daily
    logrotate_keep: 7
    logrotate_compress: yes
    logrotate_log_files:
      - name: example
        path: "/var/log/example/*.log"
      - name: btmp
        path: /var/log/btmp
        missingok: yes
        frequency: monthly
        create: yes
        create_mode: "0660"
        create_user: root
        create_group: utmp
        dateext: yes
        dateformat: "-%Y-%m-%d"
```
