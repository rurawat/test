variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "instance_ami_id" {
  type = string
  default = "ami-033b95fb8079dc481"
}

variable "instance_count" {
  type = number
  default = 1
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_name" {
  default = "test"
}

variable "key_name" {
  default = "test_key"
}

variable "alb_name" {default = "test-alb"}
variable "environment"{default = "dev"}
variable "target_group_name"{
  default = "test-target"
}
variable "subnet_id" {
  default = "subnet-005f15f570169aa38"
}
variable "subnet_elb" {
  default = ["subnet-005f15f570169aa38", "subnet-01dfa700db9e9a2f6"]
}