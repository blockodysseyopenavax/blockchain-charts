provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-kind"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "kind-kind"
  }
}

locals {
  namespace = "default"

  network_name = "devnet"

  tags = {
    terraform = "true"
  }
}

# configs
resource "helm_release" "config" {
  namespace = local.namespace
  name      = "${local.network_name}-config"
  chart     = "../../charts/besu-network"
  values    = ["${file("../values/besu-network/config.yaml")}"]
}

# bootnodes
resource "helm_release" "bootnode_1" {
  namespace = local.namespace
  name      = "${local.network_name}-bootnode-1"
  chart     = "../../charts/besu-node"
  values    = ["${file("../values/besu-node/bootnode-1.yaml")}"]

  set {
    name  = "node.storageClassName"
    value = ""
  }

  depends_on = [helm_release.config]
}
resource "kubernetes_job_v1" "wait_for_bootnodes" {
  metadata {
    namespace = local.namespace
    name      = "${local.network_name}-wait-for-bootnodes"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name  = "curl"
          image = "curlimages/curl"
          args  = ["http://${local.network_name}-bootnode-1:8545/liveness"]
        }
      }
    }
  }
  wait_for_completion = true

  depends_on = [helm_release.bootnode_1]
}

# validators
resource "helm_release" "validator_1" {
  namespace = local.namespace
  name      = "${local.network_name}-validator-1"
  chart     = "../../charts/besu-node"
  values    = ["${file("../values/besu-node/validator-1.yaml")}"]

  set {
    name  = "node.storageClassName"
    value = ""
  }

  depends_on = [
    helm_release.config,
    helm_release.bootnode_1,
    kubernetes_job_v1.wait_for_bootnodes
  ]
}
resource "helm_release" "validator_2" {
  namespace = local.namespace
  name      = "${local.network_name}-validator-2"
  chart     = "../../charts/besu-node"
  values    = ["${file("../values/besu-node/validator-2.yaml")}"]

  set {
    name  = "node.storageClassName"
    value = ""
  }

  depends_on = [
    helm_release.config,
    helm_release.bootnode_1,
    kubernetes_job_v1.wait_for_bootnodes
  ]
}
resource "helm_release" "validator_3" {
  namespace = local.namespace
  name      = "${local.network_name}-validator-3"
  chart     = "../../charts/besu-node"
  values    = ["${file("../values/besu-node/validator-3.yaml")}"]

  set {
    name  = "node.storageClassName"
    value = ""
  }

  depends_on = [
    helm_release.config,
    helm_release.bootnode_1,
    kubernetes_job_v1.wait_for_bootnodes
  ]
}
resource "helm_release" "validator_4" {
  namespace = local.namespace
  name      = "${local.network_name}-validator-4"
  chart     = "../../charts/besu-node"
  values    = ["${file("../values/besu-node/validator-4.yaml")}"]

  set {
    name  = "node.storageClassName"
    value = ""
  }

  depends_on = [
    helm_release.config,
    helm_release.bootnode_1,
    kubernetes_job_v1.wait_for_bootnodes
  ]
}

# ingress controllers
resource "helm_release" "ingress_nginx" {
  namespace  = local.namespace
  name       = "${local.network_name}-ingress-nginx"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  values     = ["${file("../values/ingress-nginx/ingress-nginx.yaml")}"]

  # local cluster's LoadBalancer service may be in pending forever
  wait = false
}

# ingresses
resource "kubernetes_ingress_v1" "rpc_ingress" {
  metadata {
    namespace = local.namespace
    name      = "${local.network_name}-rpc-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"   = "false"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }
  spec {
    ingress_class_name = "${local.network_name}-nginx"
    rule {
      http {
        path {
          path_type = "Prefix"
          path      = "/"
          backend {
            service {
              name = "${local.network_name}-bootnode-1"
              port {
                number = 8545
              }
            }
          }
        }
        path {
          path_type = "Prefix"
          path      = "/bootnodes/1"
          backend {
            service {
              name = "${local.network_name}-bootnode-1"
              port {
                number = 8545
              }
            }
          }
        }
        path {
          path_type = "Prefix"
          path      = "/validators/1"
          backend {
            service {
              name = "${local.network_name}-validator-1"
              port {
                number = 8545
              }
            }
          }
        }
        path {
          path_type = "Prefix"
          path      = "/validators/2"
          backend {
            service {
              name = "${local.network_name}-validator-2"
              port {
                number = 8545
              }
            }
          }
        }
        path {
          path_type = "Prefix"
          path      = "/validators/3"
          backend {
            service {
              name = "${local.network_name}-validator-3"
              port {
                number = 8545
              }
            }
          }
        }
        path {
          path_type = "Prefix"
          path      = "/validators/4"
          backend {
            service {
              name = "${local.network_name}-validator-4"
              port {
                number = 8545
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.ingress_nginx,
    helm_release.bootnode_1,
    helm_release.validator_1,
    helm_release.validator_2,
    helm_release.validator_3,
    helm_release.validator_4,
  ]
}
