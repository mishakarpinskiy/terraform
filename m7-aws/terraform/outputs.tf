output "aws_availability_zones" {
    value = data.aws_availability_zones.available_zones.names
}

output "public_ips" {
  value = {
    first_instance_public_ips = [for i in aws_instance.first_instance : [i.public_ip]]
  }
}

