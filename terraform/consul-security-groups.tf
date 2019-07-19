resource "aws_security_group" "consul-cluster-vpc" {
  name        = "consul-cluster-vpc"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${var.default_vpc}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "Consul Cluster Internal VPC"
    Project = "consul-cluster"
  }
}

resource "aws_security_group" "consul-cluster" {
  name        = "consul-cluster"
  description = "Security group that consul services talk to each other"
  vpc_id      = "${var.default_vpc}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "The port used by servers to handle incoming requests from other agents."
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "The port used to handle gossip in the LAN. Required by all agents."
    from_port   = 8301
    to_port     = 8301
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "The port used by servers to gossip over the WAN to other servers."
    from_port   = 8302
    to_port     = 8302
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "The port used by all agents to handle RPC from the CLI."
    from_port   = 8400
    to_port     = 8400
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "The port used by clients to talk to the HTTP API"
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "The port used to resolve DNS queries."
    from_port   = 8600
    to_port     = 8600
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0", "::/0"]
  }

  tags {
    Name    = "Consul Cluster Public Web"
    Project = "consul-cluster"
  }
}