#!/usr/bin/env bash

run_nginx_consul_template_machine() {

    assert_one_arg $@ || return 1

    local MACHINE_NAME=$1
    local SERVICE_NGINX_NAME=$(get_or $2 "nginx")
    local PARAMS=$(docker-machine config $MACHINE_NAME)
    is_not_empty $PARAMS || return 2

    run_nginx_consul_template \
            "$(machine_get_external_ip $MACHINE_NAME)"  \
            "$PARAMS"                                   \
            "$SERVICE_NGINX_NAME"
}

