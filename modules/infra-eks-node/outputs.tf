################################################################################
# Node Group
################################################################################
output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = try(aws_eks_node_group.this[0].arn, null)
}

output "node_group_id" {
  description = "EKS Cluster name and EKS Node Group name separated by a colon (`:`)"
  value       = try(aws_eks_node_group.this[0].id, null)
}

output "node_group_resources" {
  description = "List of objects containing information about underlying resources"
  value       = try(aws_eks_node_group.this[0].resources, null)
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = try(aws_eks_node_group.this[0].status, null)
}
