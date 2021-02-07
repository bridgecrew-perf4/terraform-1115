provider "aws" {
  profile = "default"
  region  = "us-west-2"  
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-course-20201224"
  acl    = "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web" {
	name 				= "prod_web"
	description = "Allow standard http and https ports inbound and allow all on outbound"

	ingress {
		cidr_blocks = [ "0.0.0.0/0" ]
		from_port 	= 80
		protocol 	= "tcp"
		to_port 	= 80
	}
	ingress {
		cidr_blocks = [ "0.0.0.0/0" ]
		from_port 	= 443
		protocol 	= "tcp"
		to_port 	= 443
	}
	egress {
		cidr_blocks = [ "0.0.0.0/0" ]
		from_port 	= 0
		protocol 	= "-1"
		to_port 	= 0
	}

	tags = {
		"Terraform" : "true"
	}
}