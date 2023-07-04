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
    unhealthy_threshold = "${var.health_check_threshold}"
    timeout             = "${var.health_check_threshold}"
    path                = "${var.health-check-path}"
    port                = "${var.health-check-port}"
    matcher             = "200"
  }

  
}

resource "aws_lb_listener" "LBL" {
  count = "${var.use_https_only == "true" ? 0 : 1}"

  load_balancer_arn = "${aws_lb.application_LB.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action = {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.TGRP.arn}"
  }
}

resource "aws_lb_listener" "LBLR" {
  count = "${var.use_https_only == "true" ? 1 : 0}"

  load_balancer_arn = "${aws_lb.application_LB.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action = {
    type = "redirect"

    redirect = {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "LBLH" {
  count = "${var.ssl_certificate_arn != "" ? 1 : 0}"

  load_balancer_arn = "${aws_lb.application_LB.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.ssl_certificate_arn}"

  default_action = {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.TGRP.arn}"
  }
}