variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "cluster_name" {
  type        = string
  description = "The cluster to run the task in"
}

variable "cluster_id" {
  type        = string
  description = "The ID of the cluster to run the task in"
}

variable "task_name" {
  type        = string
  description = "The name of the task"
}

variable "vpc_id" {
  type        = string
  description = "ID of the Cluster VPCs"
}

variable "vpc_cidr_network_octets" {
  type        = string
  description = "CIDR network range for the VPC"
}

variable "task_image" {
  type        = string
  description = "ECR task image"
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Standard tags to add to deployed resources"
}

variable "service_desired_count" {
  type        = string
  default     = 0
  description = "The number of instances to run of the service."
}
