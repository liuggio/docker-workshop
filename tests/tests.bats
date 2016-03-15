#!/usr/bin/env bats

load test_helper

@test "test run_consul with print" {
    source ./include.sh
    source ./consul/run_consul.sh

    output=$(print=1 run_consul 1 1)
    assert="docker run -d -h consul -v /mnt:/data -p 1:8300:8300 -p 1:8301:8301 -p 1:8301:8301/udp -p 1:8302:8302 -p 1:8302:8302/udp -p 1:8400:8400 -p 1:8500:8500 -p 1:53:53/udp progrium/consul -server -advertise 1 -bootstrap-expect 1 -ui-dir /ui"
    assert_equal "$output" "$assert"
}


@test "test run_nginx_consul_template with print" {
    source ./include.sh
    source ./nginx_consul_template/run_nginx_consul_template.sh

    output=$(print=1 run_nginx_consul_template 127.0.0.1)
    assert="docker run --name -d -e CONSUL_TEMPLATE_LOG=debug -v /var/run/docker.sock:/tmp/docker.sock -v /usr/lib/bats/default.ctmpl:/tmp/default.ctmpl --volumes-from nginx avthart/consul-template -consul=127.0.0.1:8500 -wait=5s -template=/tmp/default.ctmpl:/etc/nginx/conf.d/default.conf:/bin/docker kill -s HUP nginx"
    assert_equal "$output" "$assert"
}
