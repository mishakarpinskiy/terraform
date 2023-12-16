data "aws_region" "current" {}
data "aws_availability_zones" "available_zones" {
    state = "available"
}
data "aws_vpcs" "all_vpcs" {}

data "aws_ami" "example" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "image-id"
    values = ["ami-0694d931cee176e7d"]
  }
  
}

data "aws_security_group" "secGroup" {
  filter {
    name = "tag:iteaHw"
    values = ["7-2"]
  }
}