locals {
  healthy_threshold = 2
  interval   = 15
  unhealthy_threshold  = 2
  timeout    = 3
  path = "/"
  protocol = "HTTP"
  matcher = 200
}

resource "aws_lb_target_group" "test_tg" {
  name               = var.target_group_name
  target_type        = "instance"
  port               = var.http_port
  protocol           = local.protocol
  vpc_id             = var.vpc_id
  health_check {
    healthy_threshold   = local.healthy_threshold
    interval            = local.interval
    unhealthy_threshold = local.unhealthy_threshold
    timeout             = local.timeout
    path                = local.path
    port                = var.http_port
    matcher             = local.matcher
  }
}


resource "aws_lb_target_group_attachment" "test_tg_attachment" {
  target_group_arn = aws_lb_target_group.test_tg.arn
  #target_id        = [for sc in range(var.inst_count) : data.aws_instances.nlb_insts.ids[sc]]
  for_each = toset(var.instance_id)
  target_id        = each.value
  port             = var.http_port
}

resource "aws_lb_listener" "lb_listener_http" {
  load_balancer_arn    = var.alb_arn
  port                 = var.http_port
  protocol             = local.protocol
  default_action {
    target_group_arn = aws_lb_target_group.test_tg.arn
    type             = "forward"
  }
}



