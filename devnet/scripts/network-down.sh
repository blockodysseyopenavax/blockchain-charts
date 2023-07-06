if [ -z "${NAMESPACE}" ]; then NAMESPACE=default; fi
NETWORK_NAME=devnet

helm --namespace ${NAMESPACE} uninstall ${NETWORK_NAME}-validator-4
helm --namespace ${NAMESPACE} uninstall ${NETWORK_NAME}-validator-3
helm --namespace ${NAMESPACE} uninstall ${NETWORK_NAME}-validator-2
helm --namespace ${NAMESPACE} uninstall ${NETWORK_NAME}-validator-1
helm --namespace ${NAMESPACE} uninstall ${NETWORK_NAME}-bootnode-1
helm --namespace ${NAMESPACE} uninstall ${NETWORK_NAME}-config

if [ "${DELETE_PVC}" = "true" ]; then
  kubectl --namespace ${NAMESPACE} delete pvc data-${NETWORK_NAME}-validator-4-0
  kubectl --namespace ${NAMESPACE} delete pvc data-${NETWORK_NAME}-validator-3-0
  kubectl --namespace ${NAMESPACE} delete pvc data-${NETWORK_NAME}-validator-2-0
  kubectl --namespace ${NAMESPACE} delete pvc data-${NETWORK_NAME}-validator-1-0
  kubectl --namespace ${NAMESPACE} delete pvc data-${NETWORK_NAME}-bootnode-1-0
fi