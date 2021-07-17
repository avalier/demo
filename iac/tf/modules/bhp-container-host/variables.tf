
variable "name" {
  description = "A product identifier to be used as a prefix for scaffolded resources"
  type        = string
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type    = list(string)
  default = []
}

variable "private_subnets" {
  type    = list(string)
  default = []
}

variable "alb_port" {
  type    = number
  default = 80
}

variable "alb_health_check_path" {
  type    = string
  default = "/"
}

/*/
variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role Name"
  default     = "myEcsAutoScaleRole"
}
//*/