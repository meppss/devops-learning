resource "aws_security_group" "k8s-demo-sg" {
    name = "k8s-demo-sg"
    vpc_id = aws_vpc.k8s-demo-vpc.id

    tags = merge(var.tags, {
        Name = "k8s-demo-sg"
    })    
    # SSH access from the VPC
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        }
    }
# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${aws_eks_cluster.k8s-demo-eks-cluster.name}-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.k8s-demo-vpc.id
  tags = merge(var.tags, {
    Name = "${aws_eks_cluster.k8s-demo-eks-cluster.name}-sg"
  })
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  to_port                  = 65535
  type                     = "egress"
}

# EKS Nodes Security Group
resource "aws_security_group" "eks_nodes_sg" {
  name        = "${aws_eks_node_group.k8s-demo-eks-node-group.node_group_name}-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.k8s-demo-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name                                        = "${aws_eks_node_group.k8s-demo-eks-node-group.node_group_name}-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  })
}

resource "aws_security_group_rule" "nodes" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "nodes_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  to_port                  = 65535
  type                     = "ingress"
}