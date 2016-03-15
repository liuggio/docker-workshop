#!/usr/bin/env bash

# usage with 3 machine the master and 2 agents name
# todo improve with loop and shift
run_swarm_simple () {

    assert_three_args $@ || return 1

    local MASTER_NAME=$1
    local AGENT1=$2
    local AGENT2=$3

    docker-machine ip $MASTER_NAME || return 2
    docker-machine ip $AGENT1 || return 3
    docker-machine ip $AGENT2 || return 4

    TOKEN=$(docker $(docker-machine config $MASTER_NAME) run --rm swarm create)
    is_not_empty $TOKEN || return 8

    do-on $MASTER_NAME run -d -p 3376:3376 -t -v /var/lib/boot2docker:/certs:ro     \
        swarm manage -H 0.0.0.0:3376 --tlsverify --tlscacert=/certs/ca.pem  \
        --tlscert=/certs/server.pem --tlskey=/certs/server-key.pem token://$TOKEN \
        || return 5;

    do-on $AGENT1 run -d swarm join --addr=$(docker-machine ip $AGENT1):2376 \
        token://$TOKEN \
        || return 6;

    do-on $AGENT2 run -d swarm join --addr=$(docker-machine ip $AGENT2):2376 \
        token://$TOKEN \
        || return 7;

    echo created swarm cluster
    docker-machine ls

    while [ -z "`docker info | grep $AGENT2:`" ] || [ -z "`docker info | grep $AGENT1:`" ]; do
        echo "waiting ...";
        do-on $MASTER_NAME logs `do-on $MASTER_NAME ps -lq`
        sleep 2
        do-on $MASTER_NAME logs `do-on $MASTER_NAME ps -lq`
        sleep 2
        do-on $MASTER_NAME logs `do-on $MASTER_NAME ps -lq`
        sleep 2
        do-on $MASTER_NAME logs `do-on $MASTER_NAME ps -lq`
        sleep 2
        DOCKER_HOST=$(docker-machine ip $MASTER_NAME):3376
        docker info
    done
}

# usage with 3 machine the master and 2 agents name
run_swarm_simple_rm () {

    assert_three_args $@ || return 1

    local MASTER_NAME=$1
    local AGENT1=$2
    local AGENT2=$3

    do-on $MASTER_NAME rm -f `do-on $MASTER_NAME ps -aq`
    do-on $AGENT1 rm -f `do-on $AGENT1 ps -aq`
    do-on $AGENT2 rm -f `do-on $AGENT2 ps -aq`
}