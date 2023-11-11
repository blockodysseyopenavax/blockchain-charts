helm --kube-context kind-kind install besu-rpc-1 . --values ./values/besu-rpc-1.yaml
helm --kube-context kind-kind install besu-validator-1 . --values ./values/besu-validator-1.yaml
helm --kube-context kind-kind install besu-validator-2 . --values ./values/besu-validator-2.yaml
helm --kube-context kind-kind install besu-validator-3 . --values ./values/besu-validator-3.yaml
helm --kube-context kind-kind install besu-validator-4 . --values ./values/besu-validator-4.yaml
