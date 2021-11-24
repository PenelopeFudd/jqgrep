## Usage: make <target>
##   This makefile runs the test suite for jqgrep
## Possible Targets:

usage: ## Displays this message
	@gawk -vG=$$(tput setaf 2) -vR=$$(tput sgr0) ' \
	  match($$0,"^(([^:]*[^ :]) *:)?([^#]*)##(.*)",a) { \
	    if (a[2]!="") {printf "%s%-36s%s %s\n",G,a[2],R,a[4];next}\
	    if (a[3]=="") {print a[4];next}\
	    printf "\n%-36s %s\n","",a[4]\
	  }\
	' $(MAKEFILE_LIST)
SHELL:=$(shell which bash)

HEADER=@echo "==Starting 'make $@'"
FOOTER=@echo "====Ending 'make $@'"; echo ''

check :  ## Run test cases
	$(HEADER)
	@cd test; for n in *.sh; do bash $$n; err=$$(( err + $$? )); done; exit $$err
	$(FOOTER)
