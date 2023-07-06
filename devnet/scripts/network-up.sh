if [ -z "${NAMESPACE}" ]; then NAMESPACE=default; fi
NETWORK_NAME=devnet

helm --namespace ${NAMESPACE} upgrade --install ${NETWORK_NAME}-config ../../charts/besu-network --values ../values/besu-network/config.yaml --wait && \
helm --namespace ${NAMESPACE} upgrade --install ${NETWORK_NAME}-bootnode-1 ../../charts/besu-node --values ../values/besu-node/bootnode-1.yaml --wait && \
helm --namespace ${NAMESPACE} upgrade --install ${NETWORK_NAME}-validator-1 ../../charts/besu-node --values ../values/besu-node/validator-1.yaml && \
helm --namespace ${NAMESPACE} upgrade --install ${NETWORK_NAME}-validator-2 ../../charts/besu-node --values ../values/besu-node/validator-2.yaml && \
helm --namespace ${NAMESPACE} upgrade --install ${NETWORK_NAME}-validator-3 ../../charts/besu-node --values ../values/besu-node/validator-3.yaml && \
helm --namespace ${NAMESPACE} upgrade --install ${NETWORK_NAME}-validator-4 ../../charts/besu-node --values ../values/besu-node/validator-4.yaml