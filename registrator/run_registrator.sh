#!/usr/bin/env bash

run_registrator() {

    assert_two_args $@ || return 1

    local EXTERNAL_IP=$1
    local CONSUL_IP=$2
    local NAME=$(get_or $3 "registrator-consul")
    local DOCKER_HOSTNAME=$(get_or $4 "1")
    local PARAMS=$5

    execute docker $PARAMS run -d --name $NAME  \
        -v /var/run/docker.sock:/tmp/docker.sock \
        -h $DOCKER_HOSTNAME \
        gliderlabs/registrator \
        -ip $EXTERNAL_IP consul://$CONSUL_IP:8500
}
