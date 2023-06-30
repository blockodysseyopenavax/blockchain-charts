# https://nauco.tistory.com/94
# https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/guide/service/nlb/

helm upgrade --install network-ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --set controller.service.annotations."service\.beta\.kubernetes\.io\/aws-load-balancer-scheme"=internet-facing \
  --set controller.service.annotations."service\.beta\.kubernetes\.io\/aws-load-balancer-type"=external \
  --set controller.service.annotations."service\.beta\.kubernetes\.io\/aws-load-balancer-nlb-target-type"=ip