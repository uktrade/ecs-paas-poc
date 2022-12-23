resource "aws_lb" "dit_paas_task" {
  name            = "${var.config.ecs.service.cluster_name}-${var.config.ecs.service.task_name}-alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = data.aws_subnets.dit_paas_public.ids
  internal        = false
}

resource "aws_lb_listener" "dit_paas_task" {
  load_balancer_arn = aws_lb.dit_paas_task.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "dit_paas_task" {
  listener_arn = aws_lb_listener.dit_paas_task.arn
  priority     = 4
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dit_paas_task.arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_target_group" "dit_paas_task" {
  name        = "${var.config.ecs.service.cluster_name}-${var.config.ecs.service.task_name}-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.dit_paas_cluster.id
  target_type = "ip"
  deregistration_delay = 10

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = 8000
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_security_group" "dit_paas_task" {
  description = "Security group ECS Task"
  vpc_id      = data.aws_vpc.dit_paas_cluster.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb" {
  description = "Security group ECS Task"
  vpc_id      = data.aws_vpc.dit_paas_cluster.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
