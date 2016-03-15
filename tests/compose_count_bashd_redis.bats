#!/usr/bin/env bats

load test_helper

@test "run_compose_count_bashd_redis actually works" {
    source ./include.sh

    run docker-compose -f compose_count_bashd_redis/docker-compose.yml up
    assert_success
    assert_output "a" $?

    docker-compose -f compose_count_bashd_redis/docker-compose.yml stop
}

@test "run_compose_count_bashd_redis with the old file" {
    source ./include.sh

    run docker-compose -f compose_count_bashd_redis/docker-compose_old.yml up
    assert_success
    assert_output "a" $?

    docker-compose -f compose_count_bashd_redis/docker-compose_old.yml stop
}

@test "run_compose_count_bashd_redis with the production" {
    source ./include.sh

    run docker-compose \
       -f compose_count_bashd_redis/docker-compose.yml \
       -f compose_count_bashd_redis/docker-compose.prod.yml \
       up

    assert_success

    docker-compose \
       -f compose_count_bashd_redis/docker-compose.yml \
       -f compose_count_bashd_redis/docker-compose.prod.yml \
       stop
}
