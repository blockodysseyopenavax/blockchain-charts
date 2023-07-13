if [ -z "${NAMESPACE}" ]; then NAMESPACE=default; fi
NETWORK_NAME=devnet

helm --namespace ${NAMESPACE} upgrade --install ${NETWORK_NAME}-sirato-ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --values ../values/ingress-nginx/sirato-ingress-nginx.yaml