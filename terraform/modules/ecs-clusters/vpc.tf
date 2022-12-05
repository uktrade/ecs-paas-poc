resource "aws_vpc" "dit_paas_cluster" {
  cidr_block = "${var.vpc_cidr_network_octets}.0.0/16"
  enable_dns_hostnames = false
  tags = {"Name" = "dit-paas-${var.cluster_name}-cluster-vpc"} 
}

# resource "aws_internet_gateway" "graphistry_public" {
#   vpc_id = aws_vpc.graphistry.id
#   tags = merge(
#     {"Name" = "${var.service}-${var.environment}-ig"},
#     var.default_tags,
#     local.vpc_tags
#   )
# }

# resource "aws_subnet" "dit_paas_cluster_private" {
#   vpc_id = aws_vpc.dit_paas_cluster.id
#   cidr_block = "${var.vpc_cidr_network_octets}.0.0/24"
#   availability_zone = "${var.aws_region}a"
# #   tags = merge(
#     tags = {"Name" = "dit-paas-${var.cluster_name}-private-${var.aws_region}a"}
# #     var.default_tags,
# #     local.vpc_tags
# #   )
# }

# resource "aws_subnet" "dit_paas_cluster_public" {
#   vpc_id = aws_vpc.graphistry.id
#   cidr_block = "${var.vpc_cidr_network_octets}.3.0/24"
#   availability_zone = "${var.aws_region}a"
#   tags = merge(
#     {"Name" = "${var.service}-public-${var.environment}-${var.aws_region}a"},
#     var.default_tags,
#     local.vpc_tags
#   )
# }

# resource "aws_subnet" "public_b" {
#   vpc_id = aws_vpc.graphistry.id
#   cidr_block = "${var.vpc_cidr_network_octets}.4.0/24"
#   availability_zone = "${var.aws_region}b"
#   tags = merge(
#     {"Name" = "${var.service}-public-${var.environment}-${var.aws_region}b"},
#     var.default_tags,
#     local.vpc_tags
#   )
# }

# resource "aws_subnet" "public_c" {
#   vpc_id = aws_vpc.graphistry.id
#   cidr_block = "${var.vpc_cidr_network_octets}.5.0/24"
#   availability_zone = "${var.aws_region}c"
#   tags = merge(
#     {"Name" = "${var.service}-public-${var.environment}-${var.aws_region}c"},
#     var.default_tags,
#     local.vpc_tags
#   )
# }

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.graphistry.id
#   tags = merge(
#     {"Name" = "${var.service}-${var.environment}-private"},
#     var.default_tags,
#     local.vpc_tags
#   )
# }

# resource "aws_route_table_association" "private_a" {
#   subnet_id      = aws_subnet.private_a.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "private_b" {
#   subnet_id      = aws_subnet.private_b.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "private_c" {
#   subnet_id      = aws_subnet.private_c.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.graphistry.id
#   tags = merge(
#     {"Name" = "${var.service}-${var.environment}-public"},
#     var.default_tags,
#     local.vpc_tags
#   )
# }

# resource "aws_route" "graphistry_public_route" {
#   route_table_id         = aws_route_table.public.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.graphistry_public.id
# }

# resource "aws_route_table_association" "public_a" {
#   subnet_id      = aws_subnet.public_a.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "public_b" {
#   subnet_id      = aws_subnet.public_b.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "public_c" {
#   subnet_id      = aws_subnet.public_c.id
#   route_table_id = aws_route_table.public.id
# }

# # NAT Gateway

# resource "aws_eip" "public_a" {
#   vpc = true
#   tags = merge(
#     {"Name" = "${var.service}-${var.environment}-eip-nat-a"},
#     var.default_tags,
#     local.vpc_tags
#   )
# }

# resource "aws_nat_gateway" "public_a" {
#   allocation_id = "${aws_eip.public_a.id}"
#   subnet_id     = "${aws_subnet.public_a.id}"
#   tags = merge(
#     {"Name" = "${var.service}-${var.environment}-nat-gateway-a"},
#     var.default_tags,
#     local.vpc_tags
#   )
# }

# resource "aws_route" "graphistry_private_route" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.public_a.id
# }
