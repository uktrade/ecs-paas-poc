locals {
  vpc_tags = {
  }
}

resource "aws_subnet" "dit_paas_cluster_private" {
  vpc_id = var.vpc_id
  cidr_block = "${var.vpc_cidr_network_octets}.1.0/25"
  availability_zone = "${var.aws_region}a"
    tags = {"Name" = "dit-paas-${var.cluster_name}-${var.task_name}-private"}
}

resource "aws_subnet" "dit_paas_cluster_private_b" {
  vpc_id = var.vpc_id
  cidr_block = "${var.vpc_cidr_network_octets}.2.0/25"
  availability_zone = "${var.aws_region}b"
    tags = {"Name" = "dit-paas-${var.cluster_name}-${var.task_name}-private-b"}
}

resource "aws_subnet" "dit_paas_cluster_public" {
  vpc_id = var.vpc_id
  cidr_block = "${var.vpc_cidr_network_octets}.1.128/25"
  availability_zone = "${var.aws_region}a"
    tags = {"Name" = "dit-paas-${var.cluster_name}-${var.task_name}-public"}
}

# Added this otherwise the ALB complains.
resource "aws_subnet" "dit_paas_cluster_public_b" {
  vpc_id = var.vpc_id
  cidr_block = "${var.vpc_cidr_network_octets}.2.128/25"
  availability_zone = "${var.aws_region}b"
  tags = {"Name" = "dit-paas-${var.cluster_name}-${var.task_name}-public-b"}
}

resource "aws_internet_gateway" "dit_paas_cluster_public" {
  vpc_id = var.vpc_id
  tags = merge(
    {"Name" = "${var.cluster_name}-${var.task_name}-ig"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags = merge(
    {"Name" = "${var.cluster_name}-${var.task_name}-private"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.dit_paas_cluster_private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags = merge(
    {"Name" = "${var.cluster_name}-${var.task_name}-public"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.dit_paas_cluster_public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dit_paas_cluster_public.id
}

# NAT Gateway

resource "aws_eip" "public" {
  vpc = true
  tags = merge(
    {"Name" = "${var.cluster_name}-${var.task_name}-eip-nat-a"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_nat_gateway" "public" {
  allocation_id = aws_eip.public.id
  subnet_id     = aws_subnet.dit_paas_cluster_public.id
  tags = merge(
    {"Name" = "${var.cluster_name}-${var.task_name}-nat-gateway"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public.id
}
