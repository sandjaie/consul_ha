variable "consul_key" {
    default = "ec2-terf"
}

variable "account_number" {
    default = "237392829617"
}

variable "default_vpc" {
    default = "vpc-f6b7f59e"
}

variable "region" {
    description = "Region in where consul-server is deployed"
    default = "ap-south-1"
}

variable "az1" {
    default = "ap-south-1a"
}

variable "az2" {
    default = "ap-south-1b"
}

variable "az3" {
    default = "ap-south-1c"
}

variable "subnet-az1" {
    default = "172.31.16.0/20"
}

variable "subnet-az2" {
    default = "172.31.0.0/20"
}

variable "subnet-az3" {
    default = "172.31.32.0/20"
}

variable "subnet-az1-id" {
    default = "subnet-78057410"
}

variable "subnet-az2-id" {
    default = "subnet-08fe5844"
}

variable "subnet-az3-id" {
    default = "subnet-1868a163"
}

variable "sg_allow_from_office" {
    default = "sg-0a7aea4c1c893774a"
}

variable "sg_allow_from_home" {
    default = "sg-0c02701c08501707c"
}

variable "consul_join_tag_key" {
  description = "The key of the tag to auto-jon on EC2."
  default     = "consul_server"
}

variable "internal_zone_id" {
    default = "Z1WRU6JEVL85AD"
}