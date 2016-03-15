#!/usr/bin/env bats

load test_helper

@test "run_bash_d should be similar to" {
    source ./include.sh
    source ./bashd/run_bashd.sh

    tmpDir="/tmp/test-run_compose_golang_exercise"
    mkdir -p $tmpDir
    cp  compose_golang_exercise/main.go  $tmpDir/main.go
    sed -i "s@localhost@mongo@g" $tmpDir/main.go
    cp tests/fixtures/compose_golang_exercise/*  $tmpDir/

    run docker-compose -f $tmpDir/docker-compose.yml up
    assert_success

    run "docker-compose -f $tmpDir/docker-compose.yml stop"
    rm -r $tmpDir
}