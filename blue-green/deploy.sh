#!/usr/bin/env bash

COMPOSE_ARGS="-f docker-compose.yml -f docker-compose.prod.yml"


# deploy_init "$COMPOSE_ARGS"
deploy_init() {

    assert_one_arg $@ || exit 1
    local CONSULMACHNAME=$1
    local TEMPLATE_CNT_NAME="nginx_template"
    local PARAMS=$(get_or $2 "-f docker-compose.yml -f docker-compose.prod.yml")
    local CURRENT=web-$(./consul-color.sh $(docker-machine ip $CONSULMACHNAME) get-current)

    docker-compose $ARGS up -d

    deploy_update_template $CURRENT $TEMPLATE_CNT_NAME "$(docker-machine config $CONSULMACHNAME)"

    NEXT=web-$(./consul-color.sh $(docker-machine ip $CONSULMACHNAME) get-next)

    echo "stopping next is not needed here"

    docker-compose $ARGS stop web-$(./consul-color.sh $(docker-machine ip $CONSULMACHNAME) get-next)
    docker-compose $ARGS ps
}

deploy_update_template() {

    local NEXT=$1
    local TEMPLATE_CNT_NAME=$2
    local PARAMS=$3

    assert_two_args $@ || exit 1

    run_modify_nginx_consul_template_file_with_service_name $NEXT
    echo "force reload"
    docker $PARAMS kill -s HUP $TEMPLATE_CNT_NAME
    docker $PARAMS logs $TEMPLATE_CNT_NAME | tail -n 30

}


deploy_build() {

    local ARGS=$(get_or $1 "-f docker-compose.yml -f docker-compose.prod.yml")

    docker-compose $ARGS build .
}


deploy_do() {

    assert_one_arg $@ || exit 1

    local CONSULMACHNAME=$1
    local ARGS=$(get_or $2 "-f docker-compose.yml -f docker-compose.prod.yml")
    local DRAINING=$(get_or $3 "20")

    local TEMPLATE_CNT_NAME="nginx_template"


    local OLD=web-$(./consul-color.sh $(docker-machine ip $CONSULMACHNAME) get-current)
    local NEXT=web-$(./consul-color.sh $(docker-machine ip $CONSULMACHNAME) get-next)
    echo "next color is $NEXT"
    docker-compose $ARGS up --force-recreate -d  $NEXT

    deploy_update_template $NEXT $TEMPLATE_CNT_NAME "$(docker-machine config $CONSULMACHNAME)"

    ./consul-color.sh $(docker-machine ip $CONSULMACHNAME) move

    echo "sort of draining now"
    sleep 5 #DRAINING
    echo "is everything is correct we stop the old color"
    docker-compose $ARGS stop $OLD
    echo "your status"
    docker-compose $ARGS ps
}


