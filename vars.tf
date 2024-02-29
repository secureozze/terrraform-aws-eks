locals {
  awsRegion     = "ap-northeast-2"
  namePrefix    = "seoul-eks"
  networkPrefix = "10.10.0.0/16"
}

################################################################################
# EKS Cluster Infrastructure
# If You want to create Private Subnet, Please modify "terraform.tfvars" file
################################################################################

variable "create" {
  description = "Controls if private subnet should be created"
  default     = false
}

################################################################################
# EKS Cluster
################################################################################

locals {
  clusterVersion = "1.27"
}