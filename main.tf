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
#----------
depends_on = [
aws_iam_role_policy_attachment.eks_policy
  ]

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
# EKS Cluster IAM Role creation
#---------
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# IAM Policy Creation
#-----
resource "aws_iam_policy" "eks_policy" {
  #count       = var.create_new_role ? 1 : 0
  name        = "${var.cluster_name}-eks-policy"
  description = "Policy to allow eks to execute"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
    {
            "Action": "eks:*",
            "Effect": "Allow",
            "Resource": "*"
    },
    {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

#Resource attach
#----------
resource "aws_iam_role_policy_attachment" "eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}
#--------
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
