#!/usr/bin/env bash

pushd ../ &> /dev/null \
   && source ./in.sh &> /dev/null \
   && popd &> /dev/null

IP=$1
CMD=$2

show_help() {

echo "usage $0 \$(docker-machine ip consul) COMMAND

  list of COMMANDS
    get-current get the current color
    get-next    get the next color to deploy
    move        change the color

  use move to init with the blue color
"
exit $1
}

assert_one_arg $@ || show_help 1
assert_two_args $@ || show_help 2

get-color() {
  assert_one_arg $@ || exit 1

  COLOR=`curl \
    http://$1:8500/v1/kv/deploy/color?raw 2> /dev/null`

  echo $COLOR
}

get-next-color()
{
    assert_one_arg $@ || exit 1

    COLOR=$(get-color "$1")

    if [ "$COLOR" == "blue" ]; then
        echo "green"
    else
        echo "blue"
    fi
}

if [ $CMD = "get-current" ]; then

    COLOR=$(get-color "$IP")
    if [ -z "$COLOR" ]; then
        echo ""
        echo_err "not found a kv called /deploy/color"
        exit 1
    fi

    echo "$COLOR"
    exit 0;
fi


if [ $CMD = "get-next" ]; then
    echo $(get-next-color $IP)
    exit 0;
fi

if [ $CMD = "move" ]; then

    COLOR=$(get-next-color $IP)

    curl -X PUT -d $COLOR http://$1:8500/v1/kv/deploy/color &> /dev/null
    ret=$?
    if [ $ret -ne 0 ]; then
      echo_err "problem getting the color from $IP"
      exit $ret
    fi

    CHANGEDCOLOR=$(get-color $IP)
    if [ "$CHANGEDCOLOR" != "$COLOR" ]; then
      echo_err "problem setting the color from $IP [$CHANGEDCOLOR vs $COLOR]"
      exit 2
    fi

    echo $CHANGEDCOLOR;
    exit 0;
fi





