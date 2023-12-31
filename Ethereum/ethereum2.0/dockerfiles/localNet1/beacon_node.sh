#!/usr/bin/env bash

#
# Starts a beacon node based upon a genesis state created by `./setup.sh`.
#

set -Eeuo pipefail

source ./vars.env

SUBSCRIBE_ALL_SUBNETS=
DEBUG_LEVEL=${DEBUG_LEVEL:-info}

# Get options
while getopts "d:sh" flag; do
  case "${flag}" in
    d) DEBUG_LEVEL=${OPTARG};;
    s) SUBSCRIBE_ALL_SUBNETS="--subscribe-all-subnets";;
    h)
       echo "Start a beacon node"
       echo
       echo "usage: $0 <Options> <DATADIR> <NETWORK-PORT> <HTTP-PORT>"
       echo
       echo "Options:"
       echo "   -s: pass --subscribe-all-subnets to 'lighthouse bn ...', default is not passed"
       echo "   -d: DEBUG_LEVEL, default info"
       echo "   -h: this help"
       echo
       echo "Positional arguments:"
       echo "  DATADIR       Value for --datadir parameter"
       echo "  NETWORK-PORT  Value for --enr-udp-port, --enr-tcp-port and --port"
       echo "  HTTP-PORT     Value for --http-port"
       echo "  EXECUTION-ENDPOINT     Value for --execution-endpoint"
       echo "  EXECUTION-JWT     Value for --execution-jwt"
       exit
       ;;
  esac
done

# Get positional arguments
data_dir=${@:$OPTIND+0:1}
network_port=${@:$OPTIND+1:1}
http_port=${@:$OPTIND+2:1}
execution_endpoint=${@:$OPTIND+3:1}
execution_jwt=${@:$OPTIND+4:1}
ipaddress=${@:$OPTIND+5:1}
bootnode_enr=${@:$OPTIND+6:1}
echo $data_dir
echo $network_port
echo $http_port
echo $execution_endpoint
echo $execution_jwt
echo $bootnode_enr
echo $ipaddress
lighthouse_binary=lighthouse

exec $lighthouse_binary \
	--debug-level $DEBUG_LEVEL \
	bn \
	$SUBSCRIBE_ALL_SUBNETS \
	--datadir $data_dir \
	--testnet-dir $TESTNET_DIR \
	--enable-private-discovery \
  --disable-peer-scoring \
	--staking \
	--enr-address $ipaddress \
	--enr-udp-port $network_port \
	--enr-tcp-port $network_port \
	--port $network_port \
	--http-port $http_port \
	--disable-packet-filter \
	--target-peers $((BN_COUNT - 1)) \
  --execution-endpoint $execution_endpoint \
  --execution-jwt $execution_jwt \
  --boot-nodes $bootnode_enr
