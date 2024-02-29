data "aws_iam_policy_document" "eksNodeGroupRoleTrustRelationship" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

  }
}

resource "aws_iam_role" "eksNodeGroupRole" {
  name               = "${var.name}"
  assume_role_policy = data.aws_iam_policy_document.eksNodeGroupRoleTrustRelationship.json
}

resource "aws_iam_role_policy_attachment" "nodeGroupEcrReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eksNodeGroupRole.name
}

resource "aws_iam_role_policy_attachment" "nodeGroupCniPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksNodeGroupRole.name
}

resource "aws_iam_role_policy_attachment" "nodeGroupWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eksNodeGroupRole.name
}

resource "aws_iam_role_policy_attachment" "nodeGroupSsmPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eksNodeGroupRole.name
}

resource "aws_iam_role_policy_attachment" "nodeGroupCloudWatchPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eksNodeGroupRole.name
}