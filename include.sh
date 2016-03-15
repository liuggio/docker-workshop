#!/usr/bin/env bash

# usage docker_env MACHINE-NAME DOCKER-COMMAND
# eg. docker_env consul ps
docker_env() {

    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Two arguments needed"
        return 1
    fi

    local CONFIG=`docker-machine config $1`
    is_not_empty $CONFIG || return 2

    shift
    execute docker "$CONFIG" "$@"
}

# alias of docker_env
docker-on() {
    docker_env $@
}

# alias of docker_env
do-on() {
    docker_env $@
}

do-ma() {
    docker-machine $@
}

do-co() {
    docker-compose $@
}


is_not_empty() {
    if [ -z "$1" ]; then
        return 1
    fi
    return 0;
}

echo_err() { echo "$@" 1>&2; }

# usage get_or first second
# if there's the first return the first
#   otherwise return the second.
get_or() {
   echo $1;
}

assert_one_arg() {
    if [ -z "$1" ]; then
        echo "One argument needed"
        return 1
    fi
}

assert_two_args() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Two arguments needed"
        return 1
    fi
}

assert_three_args() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo "Three arguments needed"
        return 1
    fi
}

machine_get_internal_ip(){
  assert_one_arg $@ || return 1
  local TMP=$1
  echo $(docker-machine ssh $TMP ip a | grep docker0 | grep inet | awk '{print $2}' | cut -d"/" -f1);
}

machine_get_external_ip(){
    assert_one_arg $@ || return 1
    local TMP=$1
    echo $(docker-machine ip $TMP)
}

machine_get_ips(){
    assert_one_arg $@ || return 1
    TMP=$1
    MASTER=$2
    I_IP=$(docker-machine ssh $TMP ip a | grep docker0 | grep inet | awk '{print $2}' | cut -d"/" -f1);
    EX_IP=$(docker-machine ip $TMP);
    echo "export IP_INTERNAL=\"$I_IP\"";
    echo "export IP_EXTERNAL=\"$EX_IP\"";

    if [ ! -z "$master" ]; then
        MASTER_IP=$(docker-machine ip $MASTER)
        echo "export ORCH_DISCOVERY_IP=\"$MASTER_IP\"";
    fi
}

execute() {
  cmd=$@
  if [ ! -z "$print" ]; then
    echo $cmd
    return $?
  fi;
  eval $cmd;
  return $?
}

run_or_fail() {
    set -e
    execute $@
}