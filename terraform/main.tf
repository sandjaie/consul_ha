provider "aws" {
  profile = "default"
  region  = "${var.region}"

  allowed_account_ids = [
    "${var.account_number}",
  ]
}

provider "template" {
  version = "~> 2.1.0"
}

terraform {
  required_version = "~> 0.12.0"
}

locals {
  git_project = "https://github.com/sandjaie/consul_ha"
  common_tags = {
  git_project = "${local.git_project}"
  managed_by  = "terraform"
  }
  app_group  = "devops"
  app_name    = "consulcluster"
  consul_common_tags = "${merge(local.common_tags, map("app_name", local.app_name, "app_group", local.app_group))}"
}
