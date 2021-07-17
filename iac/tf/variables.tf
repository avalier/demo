variable "AWS_DEFAULT_REGION" {
  default = "ap-southeast-2"
}

variable "AWS_ACCESS_KEY_ID" {
  default = ""
}

variable "AWS_SECRET_ACCESS_KEY" {
  default = ""
}

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "ap-southeast-2"
}

variable "domain_name" {
  type    = string
  default = ""
}

variable "ecr_registry" {
  description = "AWS ECR Registry."
  type        = string
  default     = ""
}