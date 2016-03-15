#!/usr/bin/env bats

load test_helper

@test "run_bash_d should be similar to" {
    source ./include.sh
    source ./bashd/run_bashd.sh

    output=$(print=1 run_bashd node1 node2)
    assert="docker node1 run -e SERVICE_NAME=node2 -p 1500 -d alpine /bin/sh -c 'while true;do echo -e \"HTTP/1.1 200 OK\n\n\"mer 9 mar 2016, 00.30.34, CET | nc -l -p 1500;done'"
    assert_equal "${output:0:110}" "${assert:0:110}"
}