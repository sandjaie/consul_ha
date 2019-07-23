################
## AMI data ####
################
data "aws_ami" "consul_ami" {
  executable_users = ["self"]
  most_recent      = true
  #name_regex       = "^consul\\d{3}"
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["consul-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "consul_userdata" {
  template = <<-EOF
  #!/bin/bash
  echo "Testing User data"
  EOF
}

resource "aws_iam_role" "consul_instance_role" {
  name               = "consul_instance_role"
  assume_role_policy = "${module.iam-policies.ec2_assumerole_json}"
}

resource "aws_iam_instance_profile" "consul_instance_profile" {
  name = "consul_instance_profile"
  role = "${aws_iam_role.consul_instance_role.name}"
}

#####################
## Launch Template ##
#####################
resource "aws_launch_template" "consul_launch_template" {
  name_prefix = "consul-"
  image_id  = "${data.aws_ami.consul_ami}"
  instance_type = "t2.micro"
  key_name = "${var.consul_key}"
  instance_initiated_shutdown_behavior = "terminate"

  network_interfaces {
    security_groups = [
      "${aws_security_group.consul-cluster-vpc.id}",
      "${aws_security_group.consul-cluster.id}"
    ]
    associate_public_ip_address = true
  }

  iam_instance_profile {
    name = "${aws_iam_instance_profile.consul_instance_profile.name}"
  }
  user_data = "${base64encode(data.template_file.consul_userdata.rendered)}"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type = "gp2"
      volume_size = 8
    }
  }

  lifecycle {
      create_before_destroy = true
  }
  tags = "${merge(local.consul_common_tags, map("Name", "consul-lt"))}"
}

##########
## ASG ###
##########
resource "aws_autoscaling_group" "consul" {
  availability_zones    = ["${var.az1}", "${var.az2}", "${var.az3}"]
  name                  = "consul-${aws_launch_template.consul_launch_template.name}"
  launch_configuration  = "${aws_launch_template.consul_launch_template.name}"
  desired_capacity      = 3
  min_size              = 2
  max_size              = 4
  health_check_type     = "ELB"
  force_delete          = true


  load_balancers = [
    "${aws_elb.consul-elb.id}"
    ]

  launch_template {
    id      = "${aws_launch_template.consul_launch_template.id}"
    version = "${aws_launch_template.consul_launch_template.latest_version}"
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = [
    "${local.common_tags}",
    {
      key                 = "Name"
      value               = "consul"
      propagate_at_launch = true
    }
  ]
}

#########
## ELB ##
#########
resource "aws_elb" "consul-elb" {
  name = "consul-elb"
  subnets = ["${var.subnet-az1}", "${var.subnet-az2}", "${var.subnet-az3}"]
  security_groups = [
    "${aws_security_group.consul-cluster-vpc.id}",
    "${aws_security_group.consul-cluster.id}"
  ]

  listener {
      instance_port     = 8500
      instance_protocol = "http"
      lb_port           = 8500
      lb_protocol       = "http"
  }

  health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 3
      target              = "HTTP:8500/v1/status/leader"
      interval            = 30
  }
  
  tags = "${merge(local.consul_common_tags, map("Name", "consul-elb"))}"
}
