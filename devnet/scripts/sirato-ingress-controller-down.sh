if [ -z "${NAMESPACE}" ]; then NAMESPACE=default; fi
NETWORK_NAME=devnet

helm --namespace ${NAMESPACE} uninstall ${NETWORK_NAME}-sirato-ingress-nginx