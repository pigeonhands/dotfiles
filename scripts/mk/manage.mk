.PHONY: status
status:
	@./scripts/manage.sh status '$(grep)'

.PHONY: check
check:
	@./scripts/manage.sh check '$(grep)'

.PHONY: list
list:
	@./scripts/manage.sh list '$(grep)'

.PHONY: diff
diff:
	@./scripts/manage.sh diff '$(grep)'

.PHONY: backup
backup:
	@./scripts/manage.sh backup '$(grep)' $(opts)

.PHONY: new-machine
new-machine:
	@./scripts/manage.sh new-machine
