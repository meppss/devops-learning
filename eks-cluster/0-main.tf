module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.12.0"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true
 
  enable_cluster_creator_admin_permissions = true
  
  # Networking
  vpc_id = aws_vpc.k8s-demo-vpc.id
  subnet_ids = aws_subnet.k8s-demo-subnet.*.id
  control_plane_subnet_ids = aws_subnet.k8s-demo-subnet.*.id

  tags = var.tags

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    default_node_group = {
      use_custom_launch_template = false

      disk_size = 35

      remote_access = {
        ec2_ssh_key = module.key_pair.key_pair_name
        source_security_group_ids = [aws_security_group.remote_access.id]
      }
    }
  }
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name_prefix    = "eks-mng-keypair"
  create_private_key = true

  tags = var.tags
}

resource "aws_security_group" "remote_access" {
  name_prefix = "${local.name}-remote-access"
  description = "Allow remote SSH access"
  vpc_id      = aws_vpc.k8s-demo-vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, 
  { 
    Name = "${local.name}-remote"
  })
}

module "lb_role" {
 source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

 role_name                              = "${var.cluster_name}_eks_lb"
 attach_load_balancer_controller_policy = true

 oidc_providers = {
     main = {
     provider_arn               = module.eks.oidc_provider_arn
     namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
     }
    }
}
resource "kubernetes_service_account" "service-account" {
 metadata {
     name      = "aws-load-balancer-controller"
     namespace = "kube-system"
     labels = {
     "app.kubernetes.io/name"      = "aws-load-balancer-controller"
     "app.kubernetes.io/component" = "controller"
     }
     annotations = {
     "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
     "eks.amazonaws.com/sts-regional-endpoints" = "true"
     }
    }
 }

resource "helm_release" "alb-controller" {
 name       = "aws-load-balancer-controller"
 repository = "https://aws.github.io/eks-charts"
 chart      = "aws-load-balancer-controller"
 namespace  = "kube-system"
 depends_on = [
     kubernetes_service_account.service-account
 ]

 set {
     name  = "region"
     value = var.region
 }

 set {
     name  = "vpcId"
     value = aws_vpc.k8s-demo-vpc.id
 }

 set {
     name  = "image.repository"
     value = "602401143452.dkr.ecr.${var.region}.amazonaws.com/amazon/aws-load-balancer-controller"
 }

 set {
     name  = "serviceAccount.create"
     value = "false"
 }

 set {
     name  = "serviceAccount.name"
     value = "aws-load-balancer-controller"
 }

 set {
     name  = "clusterName"
     value = var.cluster_name
 }
 }
