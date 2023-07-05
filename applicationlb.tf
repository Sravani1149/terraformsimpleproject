resource "aws_lb" "application_LB" {
  name                       = "${var.alb-name}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = ["${aws_security_group.SGRP.id}"]
  subnets                    = ["${aws_subnet.subnet01.id}", "${aws_subnet.subnet02.id}"]
  enable_deletion_protection = false

  
}

resource "aws_lb_target_group" "TGRP" {
  name_prefix = "${var.target-group-name}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.myvpc.id}"

  health_check = {
    interval            = "${var.health_check_interval}"
    healthy_threshold   = "${var.health_check_threshold}"
    unhealthy_threshold = var.health_check_threshold
    timeout             = var.health_check_threshold
    path                = var.health-check-path
    port                = var.health-check-port
    matcher             = "200"
  }

  tags = {
    Name = "application_TGRP"
  }
}
# load balancer target group attachement
resource "aws_lb_target_group_attachment" "TGRPA" {
  target_group_arn = aws_lb_target_group.TGRP.arn
  port             = 80
  target_id        = aws_instance.Krishna.id
}

# load balancer listeners
resource "aws_lb_listener" "forward" {
  load_balancer_arn = aws_lb.application_LB.arn
  port              = 81
  protocol          = "HTTP"
  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.TGRP.arn

  }
}

resource "aws_lb_listener" "redirect" {
  load_balancer_arn = aws_lb.application_LB.arn
  port              = 80
  protocol          = "HTTP"
  default_action {

    type = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"

    }
  }
}