data "aws_caller_identity" "current" {}


resource "aws_ecs_task_definition" "dit_paas_task" {
  family             = "dit-paas-${var.cluster_name}-${var.task_name}-task"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = templatefile(
    "${path.module}/ecs-task-definition.tmpl", {
    aws_region          : var.aws_region
    account_id          : data.aws_caller_identity.current.account_id
    application_name    : "${var.cluster_name}-${var.task_name}-container1"
    application_port    : 8000
    task_image          : var.task_image
    
  })
}

resource "aws_ecs_service" "dit_paas_task" {
  name            = "${var.cluster_name}-${var.task_name}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.dit_paas_task.arn
  desired_count   = var.service_desired_count
  launch_type     = "FARGATE"
  platform_version = "LATEST"
  load_balancer {
    target_group_arn = aws_lb_target_group.dit_paas_task.arn
    container_port   = 8000
    container_name   = "${var.cluster_name}-${var.task_name}-container1"
  }
  network_configuration {
    security_groups  = [aws_security_group.dit_paas_task.id]
    subnets          = [aws_subnet.dit_paas_cluster_private.id]
  }
}
