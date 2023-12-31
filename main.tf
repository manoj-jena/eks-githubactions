terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }

}

data "aws_availability_zones" "available" {
    state = "available"
}


#VPC Module 
module "vpc_infra" {
  source = "./modules/vpc"
  region                        = var.region
  availability_zones_count      = var.availability_zones_count
  project                       = var.project
  vpc_cidr                      = var.vpc_cidr
  subnet_cidr_bits              = var.subnet_cidr_bits
  tags = {
    Project     = var.project
    Owner       = var.owner
  }
}

#EKS cluster
module "eks_infra" {
  source = "./modules/eks"
  region                        = var.region
  project                       = var.project
  version                       = var.version
  tags = {
    Project     = var.project
    Owner       = var.owner
  }
}

#EKS cluster-node
module "eks_infra_node" {
  depends_on = [
    module.eks_infra,
    module.s3_artifacts_bucket
  ]
  source = "./modules/eks-node"
  project                       = var.project
  subnet_ids                    = var.subnet_ids
  min_size                      = var.min_size
  max_size                      = var.max_size 
  desired_size                  = var.desired_size
  ami_type                      = var.ami_type
  capacity_type                 = var.capacity_type
  disk_size                     = var.disk_size
  instance_types                = var.instance_types
  tags = {
    Project     = var.project
    Owner       = var.owner
  }
}

