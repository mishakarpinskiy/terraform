variable "vpc_id" {
  description = "ID vpc from amazon"
}

resource "aws_subnet" "private" {
  vpc_id = var.vpc_id
}

output "available_subnets" {
  value = aws_subnet.private[*].id
}