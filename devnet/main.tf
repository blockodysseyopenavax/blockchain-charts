provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = local.cluster_name
}

locals {
  region       = "ap-northeast-2"
  cluster_name = "blockchain-eks-dev"

  namespace = "devnet"

  network_name = "devnet"

  tags = {
    terraform = "true"
  }
}

# bootnodes
resource "helm_release" "bootnode_1" {
  namespace = local.namespace
  name      = "${local.network_name}-bootnode-1"
  chart     = "../charts/besu-node"
  values    = ["${file("values/besu-node/bootnode-1.yaml")}"]
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
  chart     = "../charts/besu-node"
  values    = ["${file("values/besu-node/validator-1.yaml")}"]

  depends_on = [
    helm_release.bootnode_1,
    kubernetes_job_v1.wait_for_bootnodes
  ]
}
resource "helm_release" "validator_2" {
  namespace = local.namespace
  name      = "${local.network_name}-validator-2"
  chart     = "../charts/besu-node"
  values    = ["${file("values/besu-node/validator-2.yaml")}"]

  depends_on = [
    helm_release.bootnode_1,
    kubernetes_job_v1.wait_for_bootnodes
  ]
}
resource "helm_release" "validator_3" {
  namespace = local.namespace
  name      = "${local.network_name}-validator-3"
  chart     = "../charts/besu-node"
  values    = ["${file("values/besu-node/validator-3.yaml")}"]

  depends_on = [
    helm_release.bootnode_1,
    kubernetes_job_v1.wait_for_bootnodes
  ]
}
resource "helm_release" "validator_4" {
  namespace = local.namespace
  name      = "${local.network_name}-validator-4"
  chart     = "../charts/besu-node"
  values    = ["${file("values/besu-node/validator-4.yaml")}"]

  depends_on = [
    helm_release.bootnode_1,
    kubernetes_job_v1.wait_for_bootnodes
  ]
}

# regular nodes
resource "helm_release" "rpc_1" {
  namespace = local.namespace
  name      = "${local.network_name}-rpc-1"
  chart     = "../charts/besu-node"
  values    = ["${file("values/besu-node/rpc-1.yaml")}"]

  depends_on = [
    helm_release.bootnode_1,
    kubernetes_job_v1.wait_for_bootnodes
  ]
}

# ingress controller
resource "helm_release" "ingress_nginx" {
  namespace  = local.namespace
  name       = "${local.network_name}-ingress-nginx"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  values     = ["${file("values/ingress-nginx/ingress-nginx.yaml")}"]
}

# rpc ingress
resource "kubernetes_ingress_v1" "rpc_ingress" {
  metadata {
    namespace = local.namespace
    name      = "${local.network_name}-rpc-ingress"
    annotations = {
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
              name = "${local.network_name}-rpc-1"
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
    helm_release.rpc_1,
  ]
}

# sirato explorer
resource "helm_release" "sirato" {
  namespace = local.namespace
  name      = "${local.network_name}-sirato"
  chart     = "../charts/sirato-free"
  values    = ["${file("values/sirato-free/config.yaml")}"]
}

# sirato ingress controller
resource "helm_release" "sirato_ingress_nginx" {
  namespace  = local.namespace
  name       = "${local.network_name}-sirato-ingress-nginx"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  values     = ["${file("values/ingress-nginx/sirato-ingress-nginx.yaml")}"]
}

# sirato ingress
resource "kubernetes_ingress_v1" "sirato_ingress" {
  metadata {
    namespace = local.namespace
    name      = "${local.network_name}-sirato-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
      "nginx.ingress.kubernetes.io/use-regex"      = "true"
    }
  }
  spec {
    ingress_class_name = "${local.network_name}-sirato-nginx"
    rule {
      http {
        path {
          path_type = "Prefix"
          path      = "/api/(.*)"
          backend {
            service {
              name = "${local.network_name}-sirato-api"
              port {
                number = 8090
              }
            }
          }
        }
        path {
          path_type = "Prefix"
          path      = "/(.*)"
          backend {
            service {
              name = "${local.network_name}-sirato-web"
              port {
                number = 3000
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.sirato_ingress_nginx
  ]
}