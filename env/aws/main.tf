terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "environment" {
  type = string
}

module "networking" {
  source = "../../modules/networking"
  vpc_cidr = "10.0.0.0/16"
  environment = var.environment
  availability_zone = "us-east-1a"
  public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}

module "eks" {
  source = "../../modules/eks"
  cluster_name = "eks-${var.environment}"
  vpc_id = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
}

module "ecs" {
  source = "../../modules/ecs"
  cluster_name = "ecs-${var.environment}"
  vpc_id = module.networking.vpc_id
  private_subnet = module.networking.private_subnet_ids
  public_subnet = module.networking.public_subnet_ids
  container_image = "${aws_ecr_repository.my_app.repository_url}:latest"
}