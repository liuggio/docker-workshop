#!/usr/bin/env bats

load ../test_helper

setup() {
    echo "test-$BATS_TEST_NUMBER"
    docker-machine create -d virtualbox "test-$BATS_TEST_NUMBER"
}

teardown() {
  docker-machine rm -f "test-$BATS_TEST_NUMBER"
}