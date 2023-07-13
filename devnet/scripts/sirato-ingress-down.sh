if [ -z "${NAMESPACE}" ]; then NAMESPACE=default; fi
NETWORK_NAME=devnet

kubectl --namespace ${NAMESPACE} delete -f ../manifests/sirato-ingress.yaml