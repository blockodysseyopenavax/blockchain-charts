if [ -z "${NAMESPACE}" ]; then NAMESPACE=default; fi
NETWORK_NAME=devnet

kubectl --namespace ${NAMESPACE} delete -f ../manifests/rpc-ingress.yaml