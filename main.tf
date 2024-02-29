provider "aws" {
  region = local.awsRegion
  default_tags {
    tags = {
      Owner    = "jiyeonOh"
    }
  }
}

################################################################################
# EKS Cluster Infrastructure
# If You want to create Private Subnet, Please modify "tfvars" file
################################################################################

module "vpc" {
  source    = "./modules/vpc"
  name      = "${local.namePrefix}-vpc"
  cidrBlock = local.networkPrefix
}

module "igw" {
  source = "./modules/network/igw"
  name   = "${local.namePrefix}-igw"
  vpcId  = module.vpc.vpcId
}

module "publicRtb" {
  create = true
  source = "./modules/network/rtb"
  name   = "${local.namePrefix}-public-rtb"
  vpcId  = module.vpc.vpcId
  gwId   = module.igw.igwId
}

module "publicSubnetA" {
  create    = true
  source    = "./modules/subnet"
  name      = "${local.namePrefix}-public-subnet-a"
  vpcId     = module.vpc.vpcId
  rtbId     = module.publicRtb.rtbId
  cidrBlock = cidrsubnet(local.networkPrefix, 8, 1)
  isPublic  = true
  az        = "${local.awsRegion}a"
}

module "publicSubnetC" {
  create    = true
  source    = "./modules/subnet"
  name      = "${local.namePrefix}-public-subnet-c"
  vpcId     = module.vpc.vpcId
  rtbId     = module.publicRtb.rtbId
  cidrBlock = cidrsubnet(local.networkPrefix, 8, 2)
  isPublic  = true
  az        = "${local.awsRegion}c"
}

module "ngw" {
  create   = var.create
  source   = "./modules/network/ngw"
  name     = "${local.namePrefix}-ngw"
  subnetId = module.publicSubnetA.subnetId
}

module "privateRtb" {
  create = var.create
  source = "./modules/network/rtb"
  name   = "${local.namePrefix}-private-rtb"
  vpcId  = module.vpc.vpcId
  gwId   = module.ngw.natGwId
}

module "privateSubnetA" {
  create    = var.create
  source    = "./modules/subnet"
  name      = "${local.namePrefix}-private-subnet-a"
  vpcId     = module.vpc.vpcId
  rtbId     = module.privateRtb.rtbId
  cidrBlock = cidrsubnet(local.networkPrefix, 8, 3)
  isPublic  = false
  az        = "${local.awsRegion}a"
}

module "privateSubnetC" {
  create    = var.create
  source    = "./modules/subnet"
  name      = "${local.namePrefix}-private-subnet-c"
  vpcId     = module.vpc.vpcId
  rtbId     = module.privateRtb.rtbId
  cidrBlock = cidrsubnet(local.networkPrefix, 8, 4)
  isPublic  = false
  az        = "${local.awsRegion}c"
}

################################################################################
# EKS Cluster & Nodegroup
################################################################################

module "eksCluster" {
  source         = "./modules/eks/cluster"
  name           = "${local.namePrefix}-cluster"
  clusterVersion = local.clusterVersion
  vpcId          = module.vpc.vpcId
  subnetIds      = [module.publicSubnetA.subnetId, module.publicSubnetC.subnetId]
}

module "eksClusterAuth" {
  source               = "./modules/eks/cluster/auth"
  clusterName          = module.eksCluster.clusterName
  clusterEndpoint      = module.eksCluster.clusterEndpoint
  clusterCaCertificate = module.eksCluster.clusterCaCertificate
  clusterToken         = module.eksCluster.clusterToken
}

module "nodegroupRole" {
  source = "./modules/eks/nodegroup/role"
  name   = "${local.namePrefix}-nodegroup-role"
}

module "publicNodeGroupKeypair" {
  source = "./modules/eks/nodegroup/keypair"
  name   = "${local.namePrefix}-public-nodegroup-keypair"
}

module "publicNodegroup" {
  source              = "./modules/eks/nodegroup"
  clusterName         = module.eksCluster.clusterName
  nodegroupName       = "${local.namePrefix}-public-nodegroup"
  isPublic            = true
  vpcId               = module.vpc.vpcId
  eksNodeGroupRoleArn = module.nodegroupRole.eksNodeGroupRoleArn
  subnetIds           = [module.publicSubnetA.subnetId, module.publicSubnetC.subnetId]
  keyPairName         = module.publicNodeGroupKeypair.keyPairName
}