variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-1"
}

variable "access_key" {}
variable "secret_key" {}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role Name"
  default = "myEcsAutoScaleRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "private_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "jcruzn/private-api:1.4"
}

variable "public_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "jcruzn/public-api:1.1"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "ecs_username" {
  description = "User to manage ECS instances"
  default = "ecs_user"
}