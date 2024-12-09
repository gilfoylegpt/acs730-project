
resource "aws_lb" "app_lb" {
  name               = "${var.env}-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_websg_id]
  subnets            = var.network_datablock.outputs.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    var.default_tags, {
      "Name" = "${var.prefix}-${var.env}-app-lb"
    }
  )
}

resource "aws_lb_target_group" "app_tg" {
  name        = "${var.env}-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.network_datablock.outputs.vpc_id
  target_type = "instance"
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = merge(
    var.default_tags, {
      "Name" = "${var.prefix}-${var.env}-app-tg"
    }
  )
}

resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  count            = length(var.instance_id_list)
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = var.instance_id_list[count.index]
  port             = 80
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
