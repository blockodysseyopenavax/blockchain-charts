if [ -z "${NAMESPACE}" ]; then NAMESPACE=default; fi
NETWORK_NAME=devnet

helm --namespace ${NAMESPACE} upgrade --install ${NETWORK_NAME}-ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --values ../values/ingress-nginx/ingress-nginx.yaml