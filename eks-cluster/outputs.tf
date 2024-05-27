output "cluster_url" {
  value = aws_eks_cluster.k8s-demo-eks-cluster.endpoint
}

output "cluster_ca" {
  value = aws_eks_cluster.k8s-demo-eks-cluster.certificate_authority[0].data
}
output "mongodb_server_ip" {
  value = aws_instance.mongodb_server.public_ip
}