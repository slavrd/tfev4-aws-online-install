resource "aws_iam_role" "tfe_instance" {
  name = "${var.name_prefix}tfe-instance"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF

  tags = var.common_tags
}

data "aws_iam_policy_document" "tfe_instance" {
  statement {
    sid = "S3Access"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.tfe_s3_bucket}",
      "arn:aws:s3:::${var.tfe_s3_bucket}/*",
      "arn:aws:s3:::${var.installation_assets_s3_bucket_name}/*"
    ]
  }
  statement {
    sid = "AsgLifecycleHook"
    actions = [
      "autoscaling:CompleteLifecycleAction"
    ]
    resources = [
      aws_autoscaling_group.tfe.arn
    ]
  }
}

resource "aws_iam_role_policy" "tfe_instance" {
  name   = "${var.name_prefix}tfe-policy"
  role   = aws_iam_role.tfe_instance.id
  policy = data.aws_iam_policy_document.tfe_instance.json
}

resource "aws_iam_instance_profile" "tfe_instance" {
  name = "${var.name_prefix}tfe-instance"
  role = aws_iam_role.tfe_instance.name
}