#!/usr/bin/env bash

run_nginx() {

    local PARAMS=$2
    local SERVICE_NAME=$(get_or $1 "nginx")
    local PORT=$(get_or $3 "80")

    execute docker "$PARAMS" run --name $SERVICE_NAME \
        --restart=always -d -p $PORT:80             \
        -v /etc/nginx/conf.d nginx
}

run_nginx_consul_template() {

   assert_one_arg $@ || return 1

   local CONSUL_IP=$1
   local PARAMS=$2

   local SERVICE_NAME=$(get_or $3 "nginx")
   local NGINX_CONFIG_FILE_TEMPLATE_SRC=$(get_or $4 "/tmp/template")
   local NGINX_CONFIG_FILE_TEMPLATE_DST=$(get_or $5 "/etc/nginx/conf.d/default.conf")
   local LOG_DEBUG=$(get_or $6 "debug")


   run_nginx "$SERVICE_NAME" "$PARAMS"

   run_modify_nginx_consul_template_file "$NGINX_CONFIG_FILE_TEMPLATE_SRC" "$PARAMS"

   execute "docker $PARAMS run \
     --name ${SERVICE_NAME}_template \
     -d \
     -e CONSUL_TEMPLATE_LOG=$LOG_DEBUG \
     -v /var/run/docker.sock:/tmp/docker.sock \
     -v $NGINX_CONFIG_FILE_TEMPLATE_SRC:/tmp/template \
     --volumes-from $SERVICE_NAME \
     avthart/consul-template \
     -consul=$CONSUL_IP:8500 \
     -wait=5s -template=\"/tmp/template/default.ctmpl:$NGINX_CONFIG_FILE_TEMPLATE_DST:/bin/docker kill -s HUP $SERVICE_NAME\""

    docker kill -s HUP ${SERVICE_NAME}_template
}


run_modify_nginx_consul_template_file() {

   assert_one_arg $@ || return 1

   run_modify_nginx_consul_template_file_with_service_name "alpine" "$1"  "$2"

}

run_modify_nginx_consul_template_file_with_service_name() {

   assert_one_arg $@ || return 1

   local SERVICE=$1
   local NGINX_CONFIG_FILE_TEMPLATE_SRC=$(get_or $2 "/tmp/template")
   local PARAMS=$3

  docker $PARAMS run --rm \
      -v $NGINX_CONFIG_FILE_TEMPLATE_SRC:$NGINX_CONFIG_FILE_TEMPLATE_SRC \
      alpine sh -c "echo 'upstream server {
    {{range service \"$SERVICE\" \"any\"}}
        server {{.Address}}:{{.Port}};
    {{end}}
}
server {
    listen 80 default_server;
    location / {
        proxy_pass http://server;
        proxy_next_upstream error timeout invalid_header http_500;
    }
}' > $NGINX_CONFIG_FILE_TEMPLATE_SRC/default.ctmpl; cat $NGINX_CONFIG_FILE_TEMPLATE_SRC/default.ctmpl;"

}