data "aws_caller_identity" "current" {}


resource "aws_ecs_task_definition" "dit_paas_task" {
  family             = "dit-paas-${var.config.ecs.service.cluster_name}-${var.config.ecs.service.task_name}-task"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name = "${var.config.ecs.service.cluster_name}-${var.config.ecs.service.task_name}-container1"
      image = var.config.ecs.service.task_image
      cpu = 0
      essential = true
      environment = local.env_vars
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group = "true"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

locals {
  env_vars = [
    for k, v in var.config.ecs.env : {
      name = k
      value = v
    }
  ]
}

resource "aws_ecs_service" "dit_paas_task" {
  name            = "${var.config.ecs.service.cluster_name}-${var.config.ecs.service.task_name}-service"
  cluster         = "dit-paas-${var.config.ecs.service.cluster_name}-cluster"
  task_definition = aws_ecs_task_definition.dit_paas_task.arn
  desired_count   = var.config.ecs.service.service_desired_count
  launch_type     = "FARGATE"
  platform_version = "LATEST"
  load_balancer {
    target_group_arn = aws_lb_target_group.dit_paas_task.arn
    container_port   = 8000
    container_name   = "${var.config.ecs.service.cluster_name}-${var.config.ecs.service.task_name}-container1"
  }
  network_configuration {
    security_groups  = [aws_security_group.dit_paas_task.id]
    subnets          = data.aws_subnets.dit_paas_private.ids
  }
}
