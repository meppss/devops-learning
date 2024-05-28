data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "cloudinit_config" "user_data" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/scripts/cloud_init.yml")
  }
}

data "aws_iam_policy_document" "allow_access_from_public_readonly" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.mongodb_backups.arn,
      "${aws_s3_bucket.mongodb_backups.arn}/*",
    ]
  }
}