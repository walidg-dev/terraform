terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_instance" "app_server" {
  ami                    = var.my_image_id
  instance_type          = var.my_instance_type
  key_name               = "myawskey"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = file("init.sh")


  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "ExampleAppServerInstance"
  }
}


resource "aws_security_group" "ec2_sg" {
  name        = "example-sg"
  description = "Security group for rest server with HTTP port 8081 open within VPC"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    Name = "Example-sg"
  }
}

resource "aws_security_group_rule" "ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}


resource "aws_security_group_rule" "ingress_pg" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}
