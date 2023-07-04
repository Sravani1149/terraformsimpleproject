resource "aws_launch_configuration" "launch_config" {
  name_prefix                 = "${var.launch-config-name}"
  image_id                    = "${data.aws_ami.ubuntu.image_id}"
  instance_type               = "${var.instance-type}"
  iam_instance_profile        = "${var.iam-role-name != "" ? var.iam-role-name : ""}"
  key_name                    = "${var.instance-key-name != "" ? var.instance-key-name : ""}"
  user_data                   = "${var.user-data-script != "" ? file("${var.user-data-script}") : ""}"
  associate_public_ip_address = "${var.instance-associate-public-ip == "true" ? true : false}"
  security_groups             = ["${aws_security_group.SGRP.id}"]
}

resource "aws_autoscaling_group" "asg" {
  # name                      = "${var.asg-name}"
  name                      = "${aws_launch_configuration.launch_config.name}"
  min_size                  = "${var.asg-min-size}"
  desired_capacity          = "${var.asg-def-size}"
  max_size                  = "${var.asg-max-size}"
  launch_configuration      = "${aws_launch_configuration.launch_config.name}"
  vpc_zone_identifier       = ["${aws_subnet.subnet01.id}", "${aws_subnet.subnet02.id}"]
  target_group_arns         = ["${aws_lb_target_group.TGRP.arn}"]
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "ELB"
  min_elb_capacity          = "${var.asg-min-size}"

  

  
}
