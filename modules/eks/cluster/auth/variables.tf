locals {
  mapRoles = [{
    rolearn  = "arn:aws:iam::032847263600:role/AWSReservedSSO_TestLab-AdministratorAccess_92ac928e4000ac11",
    username = "{{SessionName}}",
    groups = [
      "system:masters"
    ]
    },
    {
      rolearn  = "arn:aws:iam::032847263600:role/seoul-irondome-eks-cluster-nodegroup-role",
      username = "system:node:{{EC2PrivateDNSName}}",
      groups = [
        "system:bootstrappers",
        "system:nodes"
      ]
  }]
  aws_auth_data = {
    mapRoles = yamlencode(local.mapRoles)
  }
}

variable "clusterName" {
  description = "cluster name"
}

variable "clusterEndpoint" {
  description = "cluster endpoint"
}

variable "clusterCaCertificate" {
  description = "cluster ca certificate"
}

variable "clusterToken" {
  description = "cluster auth token"
}