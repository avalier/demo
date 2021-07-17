
variable "name" {
  description = "A product identifier to be used as a prefix for scaffolded resources"
  type        = string
}

variable "host" {
  type = object({
    vpc_id                = string,
    public_subnets        = list(string),
    private_subnets       = list(string),
    ecs_cluster_id        = string,
    alb_listener_id       = string,
    alb_security_group_id = string
  })
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  type        = string
}

variable "app_port" {
  type    = number
  default = 80
}

variable "app_path" {
  type    = string
  default = "/*"
}

variable "app_health" {
  type    = string
  default = "/"
}

variable "app_priority" {
  type    = number
  default = 100
}

variable "app_desired_count" {
  type    = number
  default = 2
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
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