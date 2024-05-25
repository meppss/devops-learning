resource "aws_eks_cluster" "k8s-demo-eks-cluster" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.k8s-demo-cluster.arn

  vpc_config {
    subnet_ids = aws_subnet.k8s-demo-subnet.*.id
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.k8s-demo-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.k8s-demo-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "k8s-demo-eks-node-group" {
  cluster_name    = aws_eks_cluster.k8s-demo-eks-cluster.name
  node_group_name = var.cluster_name
  node_role_arn   = aws_iam_role.k8s-demo-node.arn
  subnet_ids      = aws_subnet.k8s-demo-subnet.*.id

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.k8s-demo-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.k8s-demo-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.k8s-demo-AmazonEC2ContainerRegistryReadOnly,
  ]
}

output "cluster_url" {
  value = aws_eks_cluster.k8s-demo-eks-cluster.endpoint
}

output "cluster_ca" {
  value = aws_eks_cluster.k8s-demo-eks-cluster.certificate_authority[0].data
}