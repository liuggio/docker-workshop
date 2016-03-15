#!/bin/bash

source $(dirname $0)/../in.sh || source `pwd`/in.sh || exit 1

export bold=$(tput bold)
export normal=$(tput sgr0)

CONSUL_MACHINE=discovery
docker-machine create -d virtualbox                        \
                --engine-label type=master                 \
                --engine-label env=production              \
                $CONSUL_MACHINE
run_consul_machine "$CONSUL_MACHINE"
run_registrator_machine "$CONSUL_MACHINE" "$CONSUL_MACHINE"


MASTER_MACHINE=master
docker-machine create -d virtualbox                        \
                --swarm                                    \
                --swarm-master                             \
                --swarm-discovery="consul://$(docker-machine ip $CONSUL_MACHINE):8500"  \
                --engine-opt="cluster-store=consul://$(docker-machine ip $CONSUL_MACHINE):8500" \
                --engine-opt="cluster-advertise=eth1:2376" \
                --engine-label type=master                 \
                --engine-label env=production              \
                $MASTER_MACHINE
run_registrator_machine "$MASTER_MACHINE" "$CONSUL_MACHINE"

SWARM_NODES=("node-01" "node-02")
for i in "${SWARM_NODES[@]}"; do
	log "Creating Swarm node $i"

    docker-machine create -d virtualbox                    \
                --swarm                                    \
                --swarm-discovery="consul://$(docker-machine ip $CONSUL_MACHINE):8500"  \
                --engine-opt="cluster-store=consul://$(docker-machine ip $CONSUL_MACHINE):8500" \
                --engine-opt="cluster-advertise=eth1:2376"  \
                --engine-label type=node                    \
                --engine-label env=production               \
                $i

    run_registrator_machine "$i" "$CONSUL_MACHINE"
done

docker-machine ls

eval "$(docker-machine env $MASTER_MACHINE)"
sleep 2

docker info

docker network create -d overlay multihost

docker-compose up

docker info
# -e constraint:env==production  -e constraint:type==node
# affinity:image==~registrator

docker run -d              \
    --name="long-running"  \
    --net="multihost"      \
    --env="constraint:node==$MASTER_MACHINE" \
    alpine top

docker ps

docker run -d              \
   --net="multihost"       \
   --env="constraint:node==frontend"  \
   alpine sh -c "ping long-running"


