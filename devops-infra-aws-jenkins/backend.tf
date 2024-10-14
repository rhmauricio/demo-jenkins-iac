/*
terraform {
  backend "s3" {
    bucket     = "gb-bpop-commons-pt-tfstates"
    key        = "ops/devops-aws-jks.tfstate"
    region     = "us-east-1"
    encrypt    = "true"
    kms_key_id = "126395a6-a2eb-448e-8a19-"
  }

  required_version = ">= 0.13"
}
*/
