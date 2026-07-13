variable "vpc_cidr" {
  type = string
  description = "vpc cidr"
}

variable "public_subnet_cidr" {
  type = string
  description = "public subnet cidr"
}

variable "private_subnet_cidr" {
  type = string
  description = "private subnet cidr"
}

variable "availability_zone" {
  type = string
  description = "availability zone"
}

variable "region" {
  type = string
  description = "region"
  default = "us-west-2"
}

variable "environment" {
  type = string
  description = "environment"
}