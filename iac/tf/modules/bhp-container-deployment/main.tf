locals {
  host = var.host
}

#
# Roles
#

# ECS task execution role
resource "aws_iam_role" "main" {
  name               = "${var.name}-task-execution"
  assume_role_policy = data.aws_iam_policy_document.main.json
}

# ECS task execution role data
data "aws_iam_policy_document" "main" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "main" {
  role       = "${var.name}-task-execution"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  depends_on = [aws_iam_role.main]
}

#
# Security Groups
#

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "main" {
  name        = "${var.name}-task"
  description = "allow inbound access from the ALB only"
  vpc_id      = local.host.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [local.host.alb_security_group_id]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  depends_on = [
    aws_iam_role.main
  ]
}

#
# ALB
#


resource "aws_alb_target_group" "main" {
  name        = var.name
  port        = var.app_port
  vpc_id      = local.host.vpc_id
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.app_health
    unhealthy_threshold = "2"
  }
}

#
# ECS
#

resource "aws_ecs_task_definition" "main" {
  family                   = var.name
  execution_role_arn       = aws_iam_role.main.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  #container_definitions   = data.template_file.main.rendered
  container_definitions = jsonencode([
    {
      name      = var.name
      image     = var.app_image
      essential = true
      portMappings = [{
        protocol      = "tcp"
        containerPort = var.app_port
        hostPort      = var.app_port
      }]
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = var.name
  cluster         = local.host.ecs_cluster_id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.app_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.main.id]
    subnets          = local.host.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = var.name
    container_port   = var.app_port
  }

  depends_on = [aws_iam_role_policy_attachment.main, aws_alb_target_group.main]
}

resource "aws_alb_listener_rule" "main" {
  listener_arn = local.host.alb_listener_id
  priority     = var.app_priority

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = ["${var.app_path}"]
    }
  }

  /*
  condition {
    host_header {
      values = ["example.com"]
    }
  }
  #*/
}

