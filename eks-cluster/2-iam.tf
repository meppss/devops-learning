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

