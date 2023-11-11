helm --kube-context kind-kind uninstall besu-rpc-1
helm --kube-context kind-kind uninstall besu-validator-1
helm --kube-context kind-kind uninstall besu-validator-2
helm --kube-context kind-kind uninstall besu-validator-3
helm --kube-context kind-kind uninstall besu-validator-4
kubectl --context kind-kind delete pvc data-besu-rpc-1-0
kubectl --context kind-kind delete pvc data-besu-validator-1-0
kubectl --context kind-kind delete pvc data-besu-validator-2-0
kubectl --context kind-kind delete pvc data-besu-validator-3-0
kubectl --context kind-kind delete pvc data-besu-validator-4-0
