resource "aws_db_subnet_group" "postgres" {
  subnet_ids = data.aws_subnets.dit_paas_private.ids
}

resource "aws_security_group" "postgres" {
  description = "Security group ECS Task"
  vpc_id      = data.aws_vpc.dit_paas_cluster.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "Postgres access from 10.x"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "${var.rds.cluster_name}-${var.rds.db_name}-postgres"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "12.12"
  instance_class         = "db.t3.micro"
  skip_final_snapshot    = true
  multi_az               = false
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.postgres.id]
}
