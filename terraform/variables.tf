variable "consul_key" {
    default = "consul_access"
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
    default = "subnet-78057410"
}

variable "subnet-az2" {
    default = "subnet-08fe5844"
}

variable "subnet-az3" {
    default = "subnet-1868a163"
}