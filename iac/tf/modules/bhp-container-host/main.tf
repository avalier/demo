
#
# Fargate
#

resource "aws_ecs_cluster" "main" {
  name = var.name
}

#
# ALB
#

# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "main" {
  name        = var.name
  description = "controls access to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.alb_port
    to_port     = var.alb_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "main" {
  name            = var.name
  subnets         = var.public_subnets
  security_groups = [aws_security_group.main.id]
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "main" {
  load_balancer_arn = aws_alb.main.id
  port              = var.alb_port
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      status_code  = "404"
      content_type = "text/plain"
      message_body = ""
    }
  }
}
