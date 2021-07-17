
output "aws_region" {
  value = var.aws_region
}

output "vpc_id" {
  value = var.vpc_id
}

output "private_subnets" {
  value = var.private_subnets
}

output "public_subnets" {
  value = var.public_subnets
}

output "alb" {
  value = aws_alb.main
}

output "alb_dns_name" {
  value = aws_alb.main.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.main.id
}

output "ecs_cluster" {
  value = aws_ecs_cluster.main
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
}



output "alb_listener_id" {
  value = aws_alb_listener.main.id
}
