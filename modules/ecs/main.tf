resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
  # setting this to Fargate ensures we only use serverless compute and do not create EC2 worker nodes
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}