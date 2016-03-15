#!/usr/bin/env bash

run_consul() {

    assert_two_args $@ || return 1

    local EXTERNAL_MASTER_IP=$1
    local INTERNAL_DOCKER_IP=$2
    local NAME=$(get_or $3 "consul")
    local NODES=$(get_or $4 "1")
    local PARAMS=$5

    execute docker $PARAMS run --restart=unless-stopped \
        -d -h $NAME                             \
        -v /mnt:/data                           \
        -p $EXTERNAL_MASTER_IP:8300:8300        \
        -p $EXTERNAL_MASTER_IP:8301:8301        \
        -p $EXTERNAL_MASTER_IP:8301:8301/udp    \
        -p $EXTERNAL_MASTER_IP:8302:8302        \
        -p $EXTERNAL_MASTER_IP:8302:8302/udp    \
        -p $EXTERNAL_MASTER_IP:8400:8400        \
        -p $EXTERNAL_MASTER_IP:8500:8500        \
        -p $INTERNAL_DOCKER_IP:53:53/udp        \
        -p $EXTERNAL_MASTER_IP:53:53/udp        \
        progrium/consul -server -advertise $EXTERNAL_MASTER_IP \
        -bootstrap-expect $NODES -ui-dir /ui
}
