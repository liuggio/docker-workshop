#!/usr/bin/env bash

source ./include.sh
source ./bashd/run_bashd.sh
source ./consul/run_consul.sh
source ./consul/run_consul_machine.sh
source ./registrator/run_registrator.sh
source ./registrator/run_registrator_machine.sh
source ./nginx_consul_template/run_nginx_consul_template.sh
source ./nginx_consul_template/run_nginx_consul_template_machine.sh
source ./swarm_simple/run_swarm_simple.sh
source ./blue-green/deploy.sh