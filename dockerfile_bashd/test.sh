#!/usr/bin/env sh

EXIT=0
docker build  -t test-bashd . || exit 1
pid=$(docker run -d -p 8080:8080 test-bashd)

if [ -z $pid ];then
  exit 2;
fi

gateway=$(docker inspect --format '{{ .NetworkSettings.Networks.bridge.Gateway }}' $pid)

if [ -z $gateway ];then
  exit 3;
fi

docker run -e "IP=$gateway" test-bashd /bin/sh -c "nc -v \$IP 8080" || EXIT=3;
docker rm -f $pid;

if [ $EXIT -eq 0 ];then
  echo "\n--------------------\nbuild ok!"
fi

exit $EXIT;