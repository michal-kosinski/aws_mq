terraform {
  required_version = "> 1.5.0"
}

provider "aws" {
  default_tags {
    tags = {
      CostCenter = "DevOpsCraft"
      Owner      = "mikosins"
      IaC        = "true"
    }
  }
}