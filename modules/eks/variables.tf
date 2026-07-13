variable "cluster_name" {
  description = "name of eks cluster"
  type = string
}

variable "vpc_id" {
  description = "vpc id for eks cluster"
  type = string
}

variable "private_subnet_ids" {
  description = "private subnet ids for eks cluster"
  type = list(string)
}