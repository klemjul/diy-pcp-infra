# Role Name

=========

This Ansible role manages Consul services by ensuring Consul is installed, rendering service definitions, and removing obsolete services.

## Requirements

- Debian 12
- Consul must be installed (`/usr/local/bin/consul`).

## Role Variables

### **Required Variables**

These variables **must** be provided for the role to function properly.

| Variable               | Type   | Description                                                                                              |
| ---------------------- | ------ | -------------------------------------------------------------------------------------------------------- |
| `consul_services_list` | `list` | A list of services to be defined in Consul. Each item should be a dictionary containing at least `name`. |

### **Optional Variables**

These variables are used **if defined** in `consul_services_list`.

| Variable            | Type     |  Description                                                               |
| ------------------- | -------- |  ------------------------------------------------------------------------- |
| `item.name`         | `string` |  The name of the service.                                                  |
| `item.port`         | `int`    |  The port on which the service runs.                                       |
| `item.tags`         | `list`   |  A list of tags associated with the service.                               |
| `item.check_target` | `string` |  The target endpoint for health checks (e.g., an HTTP URL or TCP address). |
| `item.type`         | `string` |  The type of health check (`http`, `tcp`, etc.).                           |
| `item.interval`     | `string` |  The interval for performing health checks (e.g., `"30s"`).                |

### **Service Removal Variables**

| Variable                 | Type   | Description                                                                                             |
| ------------------------ | ------ | ------------------------------------------------------------------------------------------------------- |
| `consul_services_remove` | `list` | A list of service names (`name` values) whose JSON definitions should be removed from `/etc/consul.d/`. |

## Example Playbook

```yaml
consul_services_list:
  - name: web
    port: 8080
    tags:
      - frontend
      - api
    check_target: "http://localhost:8080/health"
    type: http
    interval: "30s"

  - name: db
    port: 5432
    tags:
      - database
    check_target: "localhost:5432"
    type: tcp
    interval: "10s"

consul_services_remove:
  - old-service
  - deprecated-api
  - unused-backend
```
