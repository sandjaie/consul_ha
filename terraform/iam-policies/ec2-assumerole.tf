data "aws_iam_policy_document" "ec2_assumerole" {
  statement {
    sid = "AllowEC2ToAssumeInstanceProfile"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

output "ec2_assumerole_json" {
  value = "${data.aws_iam_policy_document.ec2_assumerole.json}"
}
