resource "aws_alb" "private" {
  name            = "lb-private"
  subnets         = aws_subnet.private.*.id
  internal        = true
  security_groups = [aws_security_group.private.id]
}

resource "aws_alb" "public" {
  name            = "lb-public"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.public.id]
}

resource "aws_alb_target_group" "private" {
  name        = "private-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_target_group" "public" {
  name        = "public-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "private" {
  load_balancer_arn = aws_alb.private.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.private.id
    type             = "forward"
  }
}

resource "aws_alb_listener" "public" {
  load_balancer_arn = aws_alb.public.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.public.id
    type             = "forward"
  }
}