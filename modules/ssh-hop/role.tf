resource "aws_iam_role" "ssh_hop" {
  name = "${var.name_prefix}ssh_hop"

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

data "aws_iam_policy_document" "ssh_hop" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScaling*"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "ec2:DescribeInstances"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "ssh_hop" {
  name   = "${var.name_prefix}ssh_hop"
  role   = aws_iam_role.ssh_hop.id
  policy = data.aws_iam_policy_document.ssh_hop.json
}

resource "aws_iam_instance_profile" "ssh_hop" {
  name = "${var.name_prefix}ssh_hop"
  role = aws_iam_role.ssh_hop.name
}