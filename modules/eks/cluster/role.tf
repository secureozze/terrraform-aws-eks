data "aws_iam_policy_document" "eksClusterRoleTrustRelationship" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eksClusterRole" {
  name               = "${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.eksClusterRoleTrustRelationship.json
}

resource "aws_iam_role_policy_attachment" "eksClusterRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eksClusterRole.name
}

resource "aws_iam_role_policy_attachment" "eksVpcResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eksClusterRole.name
}