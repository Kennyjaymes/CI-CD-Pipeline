module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.29"

  vpc_id  = aws_vpc.main.id
  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 1
    }
  }
}