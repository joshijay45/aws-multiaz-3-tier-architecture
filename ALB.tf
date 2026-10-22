resource "aws_alb" "app_alb" {
  name = "${var.project_name}-alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  internal = false

  subnets = [
    aws_subnet.public_subnet1.id,
    aws_subnet.public_subnet2.id

  ]
}

resource "aws_alb_target_group" "app_tg" {
  name = "${var.project_name}-app-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.app_vpc.id

  health_check {
    path = "/"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 15
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.app_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.app_tg.arn
  }
}