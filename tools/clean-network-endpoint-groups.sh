#!/usr/bin/env bash

NETWORK_ENDPOINT_GROUPS_NAME=$(gcloud beta compute network-endpoint-groups list --limit 1 --format="value(name)")
NETWORK_ENDPOINT_GROUPS_ZONE=$(gcloud beta compute network-endpoint-groups list --limit 1 --format="value(zone.basename())")

if [ "$NETWORK_ENDPOINT_GROUPS_NAME" ]; then
    echo $NETWORK_ENDPOINT_GROUPS_NAME
    echo $NETWORK_ENDPOINT_GROUPS_ZONE
    gcloud beta compute network-endpoint-groups delete --quiet --zone=${NETWORK_ENDPOINT_GROUPS_ZONE} ${NETWORK_ENDPOINT_GROUPS_NAME}
fi
