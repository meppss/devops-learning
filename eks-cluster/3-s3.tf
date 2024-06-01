resource "aws_s3_bucket" "mongodb_backups" {
    bucket = "batcomputer-robin01"
}

resource "aws_s3_bucket_public_access_block" "mongodb_backups_public_access" {
  bucket = aws_s3_bucket.mongodb_backups.id

  block_public_acls = false
  ignore_public_acls = false
  
}

resource "aws_s3_bucket_policy" "mongodb_backups_policy" {
  bucket = aws_s3_bucket.mongodb_backups.id
  policy = data.aws_iam_policy_document.allow_access_from_public_readonly.json
}

resource "aws_s3_bucket_policy" "mongodb_backups_policy_download" {
  bucket = aws_s3_bucket.mongodb_backups.id
  policy = data.aws_iam_policy_document.allow_access_from_public_getonly.json
}

resource "aws_s3_bucket_policy" "mongodb_backups_policy_mongobackupupload" {
  bucket = aws_s3_bucket.mongodb_backups.id
  policy = data.aws_iam_policy_document.allow_access_from_public_ec2.json
}

