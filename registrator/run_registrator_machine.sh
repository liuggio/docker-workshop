#!/usr/bin/env bash

run_registrator_machine() {

    assert_two_args $@ || return 1

    local MACHINE_NAME=$1
    local CONSUL_MACHINE_NAME=$2
    local NAME=$(get_or $3 "consul")
    local MACHINE_HOST=$(get_or $4 $MACHINE_NAME)

    local PARAMS=$(docker-machine config $MACHINE_NAME)
    is_not_empty $PARAMS || return 2

    run_registrator "$(machine_get_external_ip $MACHINE_NAME)" \
                "$(machine_get_external_ip $CONSUL_MACHINE_NAME)"  \
                "$NAME"          \
                "$MACHINE_HOST"  \
                "$PARAMS"
}