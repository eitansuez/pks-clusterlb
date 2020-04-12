#!/bin/bash

# This script:
# 1. identifies the master node vm id
# 2. gives it the network tag for the firewall rule, and 
# 3. adds the instance to the lb's target pool
#
# run this script after you've created your cluster

CLUSTER_NAME=$1

if [ -z $CLUSTER_NAME ]; then
  echo "Please supply the name of your cluster"
  exit 1
fi

UUID=`pks cluster $CLUSTER_NAME --json | jq -r .uuid`
NETWORK_TAG="service-instance-${UUID}-master"
TARGET_POOL_NAME="${CLUSTER_NAME}-lb"
FIREWALL_TAG_NAME="${CLUSTER_NAME}-lb"

#INSTANCE_ID=`gcloud compute instances list --filter="tags:$NETWORK_TAG" --format='value(name)'`
VM_JSON=`gcloud compute instances list --filter="tags:$NETWORK_TAG" --format='json(name,zone)'`

INSTANCE_ID=`echo $VM_JSON | jq -r .[0].name`
ZONE=`echo $VM_JSON | jq -r .[0].zone`
echo "master node for cluster $CLUSTER_NAME is $INSTANCE_ID in $ZONE"

echo "adding tag $FIREWALL_TAG_NAME to master node.."
gcloud compute instances add-tags ${INSTANCE_ID} --tags=${FIREWALL_TAG_NAME} --zone=${ZONE}

echo "adding $INSTANCE_ID to target pool $TARGET_POOL_NAME.."
gcloud compute target-pools add-instances ${TARGET_POOL_NAME} --instances=${INSTANCE_ID} --instances-zone=${ZONE}

# echo "master node network tags.."
# gcloud compute instances list --filter="name:${INSTANCE_ID}" --format='table(name,tags.list())'
