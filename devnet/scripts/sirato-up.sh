if [ -z "${NAMESPACE}" ]; then NAMESPACE=default; fi
NETWORK_NAME=devnet

helm --namespace ${NAMESPACE} upgrade --install ${NETWORK_NAME}-sirato ../../charts/sirato-free --values ../values/sirato-free/config.yaml