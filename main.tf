data "aws_vpc" "vorx_vpc" {
    filter {
      name = "tag:Name"
      values = ["vorx-prod-vpc"]
    }
}

data "aws_subnet" "vorx_public_sub_1a" {
    filter {
      name = "tag:Name"
      values = ["vorx-prod-vpc-public-us-east-1a"]
    }
}

module "jenkins_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Jenkins-SG"
  description = "Security group para nossa instancia do Jenkins Server"
  vpc_id      = data.aws_vpc.vorx_vpc.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp", "http-8080-tcp"]
  egress_rules        = ["all-all"]
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "Jenkins-Server"

  ami                    = "ami-03ededff12e34e59e"
  instance_type          = "t2.micro"
  key_name               = "vockey"
  monitoring             = true
  vpc_security_group_ids = [module.jenkins_sg.security_group_id]
  subnet_id              = data.aws_subnet.vorx_public_sub_1a.id
  user_data              = file("./dependencias.sh")

  tags = {
    Terraform = "true"
    Environment = "Production"
    CC = "10504"
    OwnerSquad = "Osaka"
    OwnerSRE = "Valfenda"
  }
}