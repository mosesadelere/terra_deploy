module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"
  cluster_name = var.cluster_name

  vpc_id = var.vpc_id
  subnet_ids = var.private_subnet_ids

  #use Fargate to avoid ec2 worker node creation
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        }
      ]
    }
  }

}