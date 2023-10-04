provider "kubernetes" {
host = module.eks.cluster_endpoint
cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

data "aws_availability_zones" "available" {
    state = "available"
}
locals {
  cluster_name = var.cluster_name
  owner        = "TSI"
}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# Module for creating a VPC
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

module "vpc" {
source = "terraform-aws-modules/vpc/aws"
version = "5.0.0"

name = var.vpc_name

cidr = "10.0.0.0/16"
azs = slice(data.aws_availability_zones.available.names, 0, var.availability_zones_count)

private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

enable_nat_gateway = true
single_nat_gateway = true
enable_dns_hostnames = true

public_subnet_tags = {
"kubernetes.io/cluster/${local.cluster_name}" = "shared"
"kubernetes.io/role/elb" = 1
}

private_subnet_tags = {
"kubernetes.io/cluster/${local.cluster_name}" = "shared"
"kubernetes.io/role/internal-elb" = 1
}
}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# Module for creating a EKS clsuter
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

module "eks" {
source = "terraform-aws-modules/eks/aws"
version = "~> 19.0"

cluster_name = var.cluster_name
cluster_version = var.eks_cluster_version

vpc_id = module.vpc.vpc_id
subnet_ids = module.vpc.private_subnets
cluster_endpoint_public_access = true

eks_managed_node_group_defaults = {
ami_type = "AL2_x86_64"

}
eks_managed_node_groups = {
one = {
name = "node-group-1"

instance_types = ["t2.medium"]

min_size = 1
max_size = 3
desired_size = 2
}

two = {
name = "node-group-2"

instance_types = ["t2.medium"]

min_size = 1
max_size = 2
desired_size = 1
}
}
}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
