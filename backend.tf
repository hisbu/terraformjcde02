terraform {
  backend "s3" {
    bucket = "jcde02-tfstate"
    key    = "terraform/tfstate"
    region = "us-west-1"
  }
}