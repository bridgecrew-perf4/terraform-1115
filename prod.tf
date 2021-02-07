provider "aws" {
  profile = "default"
  region  = "us-west-2"  
}

# resource "aws_s3_bucket" "prod_tf_course" {
#   bucket = "tf-course-20201224"
#   acl    = "private"
# }

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web" {
	name 				= "prod_web"
	description = "Allow standard http and https ports inbound and allow all on outbound"

	ingress {
		cidr_blocks = [ "0.0.0.0/0" ]
		from_port 	= 80
		protocol 		= "tcp"
		to_port 		= 80
	}
	ingress {
		cidr_blocks = [ "0.0.0.0/0" ]
		from_port 	= 443
		protocol 		= "tcp"
		to_port 		= 443
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

resource "aws_instance" "prod_web" {
	count 				= 2
  
	ami 					= "ami-0b79ddfbb9ee216ea"
  instance_type = "t2.nano"

	vpc_security_group_ids = [ aws_security_group.prod_web.id ]

	tags = {
		"Terraform" : "true"
	}
}

resource "aws_eip_association" "prod_web" {
	instance_id 	= aws_instance.prod_web.0.id
	allocation_id = aws_eip.prod_web.id
}

resource "aws_eip" "prod_web" {
	tags = {
		"Terraform" : "true"
	}
}