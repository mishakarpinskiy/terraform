variable "region" {
    default = "eu-west-1"
}

variable "ingress_ports" {
  description = "allow ports inbound"
  type = list(any)
  default = ["80", "22", "3382", "3000", "8800", "3001"]
}

variable "instance_type" {
    description = "instance type"
    default = "t3.micro"
}