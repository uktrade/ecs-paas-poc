variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "vpc_cidr_network_octets" {
  type        = string
  description = "CIDR network range for the VPC"
}
