################################################################################
# EKS Managed Node Group
################################################################################
variable "project" {
  description = "Name of the EKS managed node group"
  type        = string
}

variable "subnet_ids" {
  description = "Identifiers of EC2 Subnets to associate with the EKS Node Group. These subnets must have the following resource tag: `kubernetes.io/cluster/CLUSTER_NAME`"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances/nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances/nodes"
  type        = number
}

variable "desired_size" {
  description = "Desired number of instances/nodes"
  type        = number
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values are `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `CUSTOM`, `BOTTLEROCKET_ARM_64`, `BOTTLEROCKET_x86_64`"
  type        = string
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
}

variable "disk_size" {
  description = "Disk size in GiB for nodes. Defaults to `20`. Only valid when `use_custom_launch_template` = `false`"
  type        = number
}


