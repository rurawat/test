terraform {
  required_providers {
    aws = {
      #source  = "hashicorp/aws"
      #version = "~> 3.61"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  filter {
    name   = "tag:Name"
    values = ["alb_subnet"]
  }
}

locals {
  http_port = 80
  http_to_port   = 80
  egress_from_port  = 0
  egress_to_port    = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}


resource "aws_security_group" "test-sg" {
  name = "test-instance"
  # Allow inbound HTTP requests
  ingress {
    from_port   = local.http_port
    to_port     = local.http_to_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
  # Allow all outbound requests
  egress {
    from_port   = local.egress_from_port
    to_port     = local.egress_to_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }
}

module "webserver" {
  source = "./modules/webserver"
  aws_region = var.aws_region
  instance_ami_id = var.instance_ami_id
  instance_count =var.instance_count
  instance_type =var.instance_type
  instance_name = var.instance_name
  key_name = var.key_name
  sg = [aws_security_group.test-sg.id]
  subnet_id = var.subnet_id
}

module "alb" {
  source = "./modules/alb"
  sg = [aws_security_group.test-sg.id]
  subnet_id = var.subnet_elb
  alb_name = var.alb_name
  env = var.environment
}

module "target_group" {
  source = "./modules/target_group"
  target_group_name = var.target_group_name
  http_port =   local.http_port
  instance_id = module.webserver.test-instance_id
  alb_arn = module.alb.alb_arn
  env = var.environment
  vpc_id = data.aws_vpc.default.id
  sg = [aws_security_group.test-sg.id]
}

output "subnet" {
  value = "data.aws_vpc.default.id"
}