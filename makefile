PYTHON := python3.11
PIP := pip3
VENV := .venv
TF_BACKEND_DIRS := terraform/vpn terraform/infra terraform/backup
TF_MODULE_DIRS := terraform/modules/openstack_instance terraform/modules/openstack_network
TF_ALL_DIRS := $(TF_BACKEND_DIRS) $(TF_MODULE_DIRS)


.PHONY: pre-commit-init tf-init tf-lint tf-test tf-fmt tf-validate \
        ansible-lint ansible-install ansible-inventory ansible-all \
        ansible-consul ansible-all-consul-services ansible-traefik \
        ansible-monitoring ansible-logging ansible-all-hardening \
				python-init ansible-tracing ansible-postgresql ansible-mattermost

pre-commit-init:
	pre-commit install

define run_cmd
	echo "\n----- Running $(1) on $(2)..."
	cd $(2) && $(3)
endef

python-init:
	@echo "Creating Python virtual environment..."
	$(PYTHON) -m venv $(VENV)
	@echo "Activating virtual environment..."
	. $(VENV)/bin/activate
	@echo "Installing Python dependencies..."
	$(PIP) install -r requirements.txt

tf-init:
	@$(foreach dir,$(TF_BACKEND_DIRS),$(call run_cmd,tf init,$(dir),terraform init -backend-config=../backend.conf);)
	@$(foreach dir,$(TF_MODULE_DIRS),$(call run_cmd,tf init,$(dir),terraform init -backend=false);)

tf-lint:
	@$(foreach dir,$(TF_ALL_DIRS),$(call run_cmd,tflint,$(dir),tflint);)

tf-test:
	@$(foreach dir,$(TF_ALL_DIRS),$(call run_cmd,tf test,$(dir),terraform test);)

tf-fmt:
	@$(foreach dir,$(TF_ALL_DIRS),$(call run_cmd,terraform fmt,$(dir),terraform fmt);)

tf-validate:
	@$(foreach dir,$(TF_ALL_DIRS),$(call run_cmd,terraform validate,$(dir),terraform validate);)

ansible-lint:
	cd ansible && ansible-lint

ansible-test:
	cd ansible && bash -c 'for s in molecule/*; do molecule test -s "$${s##*/}"; done'

ansible-install:
	cd ansible && ansible-galaxy install -r requirements.yml 

ansible-inventory:
	cd ansible && ansible-inventory -i openstack.yml --list

ansible-all: ansible-inventory
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook -u clouduser -i openstack.yml pb_all.yml

ansible-consul: ansible-all
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook -u clouduser -i openstack.yml -e @./envs/sandbox/group_vars/meta-app_consul.yml pb_consul.yml

ansible-all-consul-services: ansible-consul
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook -u clouduser -i openstack.yml pb_all_consul_services.yml

ansible-traefik: ansible-all-consul-services
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook -u clouduser -i openstack.yml -e @./envs/sandbox/group_vars/meta-app_traefik.yml pb_traefik.yml

ansible-monitoring: ansible-all-consul-services
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook -u clouduser -i openstack.yml \
	-e @./envs/sandbox/group_vars/domains.yml \
	-e @./envs/sandbox/group_vars/meta-app_monitoring.yml \
	-e @./envs/sandbox/group_vars/meta-app_keycloak.yml \
	pb_monitoring.yml

ansible-logging: ansible-monitoring
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook -u clouduser -i openstack.yml pb_logging.yml

ansible-tracing: ansible-logging
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook -u clouduser -i openstack.yml pb_tracing.yml

ansible-postgresql: ansible-all-consul-services
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook -u clouduser -i openstack.yml \
	-e @./envs/sandbox/group_vars/meta-app_postgresql.yml \
	-e @./envs/sandbox/group_vars/meta-app_mattermost.yml \
	-e @./envs/sandbox/group_vars/meta-app_keycloak.yml \
	pb_postgresql_ha.yml

ansible-mattermost: ansible-postgresql
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook -u clouduser -i openstack.yml -e @./envs/sandbox/group_vars/meta-app_mattermost.yml -e @./envs/sandbox/group_vars/domains.yml pb_mattermost.yml

ansible-keycloak: ansible-postgresql
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook -u clouduser -i openstack.yml -e @./envs/sandbox/group_vars/meta-app_keycloak.yml -e @./envs/sandbox/group_vars/domains.yml pb_keycloak.yml

ansible-gitlab: ansible-postgresql
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook -u clouduser -i openstack.yml \
	-e @./envs/sandbox/group_vars/domains.yml \
	pb_gitlab.yml

ansible-all-hardening: ansible-all
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook -u clouduser -i openstack.yml pb_all_hardening.yml
