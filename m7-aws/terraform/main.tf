provider "aws" {
  region = var.region
}

resource "aws_instance" "first_instance" {
  count = length(data.aws_availability_zones.available_zones.names)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  ami = "ami-0694d931cee176e7d"
  instance_type = var.instance_type
  user_data = templatefile("01-ssh-public-key-config.tpl", {key_owner = "user@user"})
  vpc_security_group_ids = [aws_security_group.first_security_group.id]

  tags = {
    Name = "first instance name"
    Env = "test"
    ServerType = "frontend"
  }
}

resource "aws_instance" "second_instance" {
  ami = "ami-0694d931cee176e7d"
  instance_type = "t2.micro"
  user_data = templatefile("01-ssh-public-key-config.tpl", {key_owner = "user@user"})
  vpc_security_group_ids = [aws_security_group.first_security_group.id]

  depends_on = [ aws_instance.first_instance ]

  tags = {
    Name = "second instance name"
    Env = "test"
    ServerType = "backend"
  }
}

resource "aws_security_group" "first_security_group" {
    name = "first security group"
    description = "some description"

    dynamic "ingress" {
      for_each = var.ingress_ports
      content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }

    tags = {
      Name = "first sec group"
      Env = "test"
    }
}