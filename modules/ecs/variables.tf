variable "cluster_name" {
  description = "ecs cluster name"
  type = string
  default = "complete-devops-project-cluster"
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "private_subnet" {
  description = "List of private subnet IDs"
  type = list(string)
}

variable "public_subnet" {
  description = "List of public subnet IDs"
  type = list(string)
}

variable "container_image" {
  description = "Container image to deploy"
  type = string
}