output "cluster" {
  value = tomap({
    "id" = aws_ecs_cluster.dit_paas_cluster.id
    "vpc_id" = aws_vpc.dit_paas_cluster.id
  })
}
