resource "aws_lb" "test-alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.sg
  subnets            = var.subnet_id
  enable_deletion_protection = true
  tags = {
     env = var.env
  }
}

output "alb_dns" {
  value = aws_lb.test-alb.dns_name
}
output "alb_arn" {
  value = aws_lb.test-alb.arn
}