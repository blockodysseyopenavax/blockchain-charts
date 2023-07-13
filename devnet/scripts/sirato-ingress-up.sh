if [ -z "${NAMESPACE}" ]; then NAMESPACE=default; fi
NETWORK_NAME=devnet

kubectl --namespace ${NAMESPACE} apply -f ../manifests/sirato-ingress.yaml