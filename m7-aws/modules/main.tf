module "subnets" {
  source = "./subnets"
  vpc_id = aws_vpc.main.id
}

output "available_subnets" {
  value = module.subnets.available_subnets
}