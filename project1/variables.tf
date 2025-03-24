data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

data "aws_vpc" "default" {
  default = true
}

variable "my_instance_type" {
  description = "Value of the EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "my_image_id" {
  description = "Value of the EC2 instance image"
  type        = string
  default     = "ami-0160e8d70ebc43ee1"
}


