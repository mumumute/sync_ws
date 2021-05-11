.PHONY: start

start: config/hosts
	ansible-playbook main.yml -i config/hosts --ask-become-pass --ask-pass -c paramiko