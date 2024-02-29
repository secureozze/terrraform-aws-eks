variable "isPublic" {
  description = "nodegroup is in public or not"
}

variable "clusterName" {
  description = "cluster name"
}

variable "nodegroupName" {
  description = "nodegroup name"
}

variable "vpcId" {
  description = "vpc Id"
}

variable "subnetIds" {
  description = "subnet Ids"
}

variable "keyPairName" {
  description = "aws key pair name"
}

variable "eksNodeGroupRoleArn" {
  description = "nodegroup role arn"
}