module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "cicd-eks"
  cluster_version = "1.29"
  subnets         = [aws_subnet.public.id]
  vpc_id          = aws_vpc.main.id
}
