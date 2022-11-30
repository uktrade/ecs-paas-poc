resource "aws_vpc" "dit_paas_cluster" {
  cidr_block = "${var.vpc_cidr_network_octets}.0.0/16"
  enable_dns_hostnames = false
  tags = {"Name" = "dit-paas-${var.cluster_name}-cluster-vpc"} 
}
