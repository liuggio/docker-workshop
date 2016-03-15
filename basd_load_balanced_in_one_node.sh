#!/usr/bin/env bash

source ./in.sh

if [ -z "$1" ];then
    echo "use $0 machine-name [node number]"
    assert_one_arg $@ || exit 1
fi

MACHINE_NAME=$1
SERVERS_NUMBER=$2

if [ -z "$SERVERS_NUMBER" ];then
    SERVERS_NUMBER=3
fi

echo "creating n. $SERVERS_NUMBER loadbalanced in $MACHINE_NAME"

docker-machine create -d virtualbox "$MACHINE_NAME"

run_consul_machine "$MACHINE_NAME"

run_registrator_machine "$MACHINE_NAME" "$MACHINE_NAME"

run_nginx_consul_template_machine "$MACHINE_NAME"

for ((i=1;i<=SERVERS_NUMBER;i++)); do
    echo creating $i
    run_bashd "$(docker-machine config $MACHINE_NAME)"
done