resource "aws_lb" "main" {
  name                       = "${var.name}-ecs"
  subnets                    = var.public_subnets_ids
  security_groups            = [aws_security_group.lb_sg.id]
  load_balancer_type         = "application"
  enable_deletion_protection = false
  internal                   = false 
  depends_on = [
    aws_security_group.lb_sg
  ]
}

resource "aws_lb_target_group" "app" {
  name        = "${var.name}-ecs-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "5"
    interval            = "30"
    protocol            = "HTTP" # Assuming health checks are over HTTP
    matcher             = "200"
    timeout             = "5"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "#{host}"
      path        = "/#{path}"
      query       = "#{query}"
    }
  }
}


resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.ssl_certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.app.arn
    type             = "forward"
  }
}
