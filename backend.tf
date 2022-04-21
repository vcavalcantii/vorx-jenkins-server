terraform {
  backend "s3" {
    bucket = "vorx-infra-remote-state"
    key    = "jenkins-server-terraform.tfstate"
    region = "us-east-1"
  }
}