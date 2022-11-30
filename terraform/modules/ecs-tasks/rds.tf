#
# TO DO: Move this to a separate module and look at "bindings" here
#

resource "aws_db_subnet_group" "postgres" {
  name       = "postgres"
  subnet_ids = [aws_subnet.dit_paas_cluster_private.id, aws_subnet.dit_paas_cluster_private_b.id]
}

resource "aws_security_group" "postgres" {
  description = "Security group ECS Task"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "${var.cluster_name}-${var.task_name}-postgres"
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "12.12"
  instance_class       = "db.t3.micro"
  skip_final_snapshot  = true
  multi_az = false
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.postgres.id]
}
