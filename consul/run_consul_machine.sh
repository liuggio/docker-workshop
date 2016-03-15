#!/usr/bin/env bash

run_consul_machine() {

    assert_one_arg $@ || return 1

    MACHINE_NAME=$1
    local NAME=$(get_or $2 "${MACHINE_NAME}consul")
    local NODES=$(get_or $3 "1")

    PARAMS=$(docker-machine config $MACHINE_NAME)
    is_not_empty $PARAMS || return 2

    run_consul "$(machine_get_external_ip $MACHINE_NAME)" "$(machine_get_internal_ip $MACHINE_NAME)" "$NAME" "$NODES" "$PARAMS"
}