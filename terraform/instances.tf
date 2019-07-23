################
## AMI data ####
################
data "aws_ami" "consul_ami" {
  most_recent      = true
  owners           = ["${var.account_number}"]

  filter {
    name   = "name"
    values = ["consul-*"]
  }
}

data "template_file" "consul_userdata" {
  template = <<-EOF
  #!/bin/bash
  echo '{
    "bind_addr": "'`curl http://169.254.169.254/latest/meta-data/local-ipv4`'",
    "server": true,
    "bootstrap_expect": 3,
    "datacenter": "dc1",
    "data_dir": "/opt/consul",
    "log_level": "INFO",
    "log_file": "/var/log/consul",
    "client_addr": "0.0.0.0"
    }' | sudo tee /etc/consul.d/config.json
    sudo service consul restart
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
  image_id  = "${data.aws_ami.consul_ami.id}"
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
resource "aws_autoscaling_group" "consul_asg" {
  availability_zones    = ["${var.az1}", "${var.az2}", "${var.az3}"]
  name                  = "asg-${aws_launch_template.consul_launch_template.name}"
  desired_capacity      = 3
  min_size              = 2
  max_size              = 4
  health_check_type     = "EC2"
  force_delete          = true
  #placement_group       = "${aws_placement_group.consul_placement_group.id}"

  load_balancers = [
    "${aws_elb.consul-elb.name}"
    ]

  launch_template {
    id      = "${aws_launch_template.consul_launch_template.id}"
    version = "${aws_launch_template.consul_launch_template.latest_version}"
  }

  lifecycle {
    create_before_destroy = true
  }
  
  tags =[
    {
      key                 = "Name"
      value               = "consul_asg"
      propagate_at_launch = true
    },
    {
      key                 = "app_name"
      value               = "consulcluster"
      propagate_at_launch = true
    },
    {
      key                  = "app_group"
      value                = "devops"
      propagate_at_launch  = true
    }
  ]
}

# resource "aws_placement_group" "consul_placement_group" {
#   name     = "consul_placement_group"
#   strategy = "cluster"
# }

#########
## ELB ##
#########
resource "aws_elb" "consul-elb" {
  name = "consul-elb"
  subnets = ["${var.subnet-az1-id}", "${var.subnet-az2-id}", "${var.subnet-az3-id}"]
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
