data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "template_file" "user_data" {
  template = file("${path.module}/scripts/cloud_init.cfg")
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
