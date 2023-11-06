helm uninstall besu-rpc-1
helm uninstall besu-validator-1
helm uninstall besu-validator-2
helm uninstall besu-validator-3
helm uninstall besu-validator-4
kubectl delete pvc data-besu-rpc-1-0
kubectl delete pvc data-besu-validator-1-0
kubectl delete pvc data-besu-validator-2-0
kubectl delete pvc data-besu-validator-3-0
kubectl delete pvc data-besu-validator-4-0