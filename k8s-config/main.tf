data "aws_eks_cluster" "k8s-demo-cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "k8s-demo-cluster-auth" {
  name = var.cluster_name
}

resource "local_sensitive_file" "kubeconfig" {
  content = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name = var.cluster_name,
    clusterca    = data.aws_eks_cluster.k8s-demo-cluster.certificate_authority[0].data,
    endpoint     = data.aws_eks_cluster.k8s-demo-cluster.endpoint,
  })
  filename = "./kubeconfig-${var.cluster_name}"
}

resource "kubernetes_namespace" "k8s_namespace" {
  metadata {
    name = "batmans_namespace"
  }
}

resource "helm_release" "nginx_ingress" {
  namespace = kubernetes_namespace.k8s_namespace.metadata.0.name
  wait      = true
  timeout   = 600

  name = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "v3.30.0"
}