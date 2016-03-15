#!/usr/bin/env bash

if [ -z $REDIS_HOST ];then
    REDIS_HOST=localhost
fi

if [ ! -z $REDIS_1_PORT_6379_TCP_ADDR ];then
    REDIS_HOST=$REDIS_1_PORT_6379_TCP_ADDR
fi

printf '%s\r\n\r\n' "HTTP/1.0 200 OK";
printf '%s\r\n\r\n' "`date`";

figlet `./redis-bash-cli -h $REDIS_HOST INCR hit`

exit 0;