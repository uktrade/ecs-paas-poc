data "aws_vpc" "dit_paas_cluster" {
  filter {
    name = "tag:Name"
    values = ["dit-paas-${var.rds.cluster_name}-cluster-vpc"]
  }
}

data "aws_subnets" "dit_paas_private" {
  filter {
    name   = "tag:Subnet"
    values = ["dit-paas-${var.rds.cluster_name}-private"]
  }
}
