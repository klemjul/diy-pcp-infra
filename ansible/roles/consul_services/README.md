Role Name  
=========  

This Ansible task manages Consul services by ensuring Consul is installed, rendering service definitions, and removing obsolete services.  

Requirements  
------------  

- Debian 12
- Consul must be installed (`/usr/local/bin/consul`)  

Role Variables  
--------------  

Refer to `./defaults/main.yml` comments  

Dependencies  
------------  

None  

Example Playbook  
----------------  

`ansible-playbook -i openstack.yml -u clouduser pb_all_consul_services.yml`