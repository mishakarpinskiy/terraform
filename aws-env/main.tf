provider "aws" {
  region = var.region
}

resource "aws_instance" "backend" {
  count = 2
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  ami = data.aws_ami.example.id
  instance_type = var.instance_type
  user_data = file("ssh-key.tpl")
  vpc_security_group_ids = [data.aws_security_group.secGroup.id]
  tags = {
    Name = "backend"
    Env = "test"
    ServerType = "backend-server"
  }
  depends_on = [ aws_instance.db ]
}

resource "aws_instance" "frontend" {
  ami = data.aws_ami.example.id
  instance_type = var.instance_type
  user_data = file("ssh-key.tpl")
 vpc_security_group_ids = [data.aws_security_group.secGroup.id]
  tags = {
    Name = "frontend"
    Env = "test"
    ServerType = "frontend-server"
  }
  depends_on = [ aws_instance.backend ]
}

resource "aws_instance" "db" {
  ami = data.aws_ami.example.id
  instance_type = var.instance_type
  user_data = file("ssh-key.tpl")
  vpc_security_group_ids = [data.aws_security_group.secGroup.id]
  tags = {
    Name = "db"
    Env = "test"
    ServerType = "db-server"
  }
}

resource "aws_eip" "backend" {
   count = 2
   domain = "vpc"
   instance = aws_instance.backend[count.index].id
 }

 resource "aws_eip" "frontend" {
   domain = "vpc"
   instance = aws_instance.frontend.id
 }

 resource "aws_ebs_volume" "db-volume" {
   size = 1
   availability_zone = data.aws_availability_zones.available_zones.names[0]
 }

 resource "aws_volume_attachment" "mount-ebs-db" {
  device_name = "/dev/sdb"
  instance_id = aws_instance.db.id
  volume_id = aws_ebs_volume.db-volume.id
}