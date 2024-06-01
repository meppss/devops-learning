data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }
}
data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}
data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.cluster_name
}

data "template_file" "user_data" {
  template = file("${path.module}/scripts/cloud_init.tftpl")
  vars = {
      "MONGODB_SRV_IP"        = "${local.mongo_private_ip}",
      "MONGODB_USER"          = "${local.mongo_username}",
      "MONGODB_PASS"          = "${local.mongo_pass}"
      "MONGO_DB"              = "admin"
      "S3_NAME"               = "${aws_s3_bucket.mongodb_backups.bucket}"
      "S3_PATH"               = "batcave_files"
  }
}

data "aws_iam_policy_document" "allow_access_from_public_readonly" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      "${aws_s3_bucket.mongodb_backups.arn}/batcave_files/*"
    ]
  }
}

data "aws_iam_policy_document" "allow_access_from_public_getonly" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.mongodb_backups.arn}/batcave_files/*"
    ]
  }
}

data "aws_iam_policy_document" "allow_access_from_public_ec2" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListObject"
    ]

    resources = [
      "${aws_s3_bucket.mongodb_backups.arn}/batcave_files/*"
    ]

    condition {
      test = "IpAddress"
      variable = "aws:SourceIp"
      values = ["3.137.173.10"]
    }
  }
}
