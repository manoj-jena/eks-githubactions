#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# EKS Cluster 
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
variable "vpc_name" {
  description = "VPC name"
  type = string
  default     = "TSI-DEMO-VPC"
}
variable "cluster_name" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  type = string
  default     = "TSI-DEMO-EKS-CLUSTER"
}

variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
  default     = "eu-central-1"
}

variable "version-1" {
  description = "EKS version details"
  type        = string
  default     = "1.25"
}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# # EKS Managed Node Group
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
variable "subnet_ids" {
  description = "Identifiers of EC2 Subnets to associate with the EKS Node Group. These subnets must have the following resource tag: `kubernetes.io/cluster/CLUSTER_NAME`"
  type        = list(string)
  default     = null
}

variable "min_size" {
  description = "Minimum number of instances/nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances/nodes"
  type        = number
  default     = 5
}

variable "desired_size" {
  description = "Desired number of instances/nodes"
  type        = number
  default     = 2
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values are `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `CUSTOM`, `BOTTLEROCKET_ARM_64`, `BOTTLEROCKET_x86_64`"
  type        = string
  default     = "AL2_x86_64"
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}

variable "disk_size" {
  description = "Disk size in GiB for nodes. Defaults to `20`. Only valid when `use_custom_launch_template` = `false`"
  type        = number
  default     = 20
}

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# VPC Infra
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "TerraformEKS-TSI"
    "Owner"       = "Manoj-Bala"
  }
}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# S3 Bucket
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
variable "bucket" {
  description = "s3 bucket name"
  type        = string
  default     = "s3-manoj2"
}

variable "dynamodb_table" {
  description = "dynamodb table "
  type        = string
  default     = "terraform-db-table"
}

