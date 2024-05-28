resource "aws_iam_role" "k8s-demo-cluster" {
  name = "${var.cluster_name}-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "k8s-demo-nodes" {
  name = "${var.cluster_name}-worker"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {     
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# IAM Role Policy Attachments - k8s-demo-cluster
resource "aws_iam_role_policy_attachment" "k8s-demo-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.k8s-demo-cluster.name
}

resource "aws_iam_role_policy_attachment" "k8s-demo-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.k8s-demo-cluster.name
}

# IAM Role Policy Attachments - k8s-demo-nodes
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.k8s-demo-nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.k8s-demo-nodes.name
}

resource "aws_iam_role_policy_attachment" "ec2_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.k8s-demo-nodes.name
}


# Overly broad MongoDB server IAM instance profile
resource "aws_iam_instance_profile" "mongodb_instance_profile" {
  name = "mongodb_instance_profile"
  role = aws_iam_role.mongodb_iam_role.name
}

resource "aws_iam_role" "mongodb_iam_role" {
  name = "mongodb_iam_role"
  path = "/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {     
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "mongodb_role_policy_attachment-1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role = aws_iam_role.mongodb_iam_role.name
}

resource "aws_iam_role_policy_attachment" "mongodb_role_policy_attachment-2" {
  policy_arn = "arn:aws:iam::aws:policy/job-function/DataScientist"
  role = aws_iam_role.mongodb_iam_role.name
}

resource "aws_iam_user" "mongodb_backup_iam" {
  name = "mongdb_backup_iam"
  force_destroy = true
  tags = var.tags
}

resource "aws_iam_user_policy_attachment" "mongodb_backup_iam_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  user = aws_iam_user.mongodb_backup_iam.name
}
