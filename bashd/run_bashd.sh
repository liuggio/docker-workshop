#!/usr/bin/env bash

run_bashd() {

   local PARAMS=$1
   local SERVICE_NAME=$(get_or "$2" "bash_server")

   execute "docker $PARAMS run \
        -e SERVICE_NAME=$SERVICE_NAME \
        -p 1500 -d alpine  \
        /bin/sh -c 'while true;do echo -e \"HTTP/1.1 200 OK\\n\\n\"$(date) | nc -l -p 1500;done'"
}
