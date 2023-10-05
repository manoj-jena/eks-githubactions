variable "region" {
  description = "The aws region. 
  type        = string
  default     = "eu-central-1"
}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
variable "env" {
  description = "Environment name."
  type        = string
  default     = "techm-tsi"
}

variable "vpc_cidr_block" {
  description = "CIDR (Classless Inter-Domain Routing)."
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for subnets."
  type        = list(string)
  default     = 3
}

variable "private_subnets" {
  description = "CIDR ranges for private subnets."
  type        = list(string)
  default =  ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] 
}

variable "public_subnets" {
  description = "CIDR ranges for public subnets."
  type        = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] 
}

variable "private_subnet_tags" {
  description = "Private subnet tags."
  type        = map(any)
  default = {}
}

variable "public_subnet_tags" {
  description = "Private subnet tags."
  type        = map(any)
  default = {}
}
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
variable "eks_version" {
  description = "Desired Kubernetes master version."
  type        = string
  default     = "1.25"
}
variable "eks_name" {
  description = "Name of the cluster."
  type        = string
  default     = "Techm-TSI"
}
variable "subnet_ids" {
  description = "List of subnet IDs. Must be in at least two different availability zones."
  type        = list(string)
  default     = null
}
variable "node_iam_policies" {
  description = "List of IAM Policies to attach to EKS-managed nodes."
  type        = map(any)
  default = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

variable "node_groups" {
  description = "EKS node groups"
  type        = map(any)
  default = {
  one = {
  name = "node-group-1"
  instance_types = ["t3.small"]
  min_size = 1
  max_size = 3
  desired_size = 2
        }
  two = {
  name = "node-group-2"
  instance_types = ["t3.small"]
  min_size = 1
  max_size = 2
  desired_size = 1
        }
           }
  }
variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}
