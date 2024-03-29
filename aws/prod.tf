provider "aws" {
  profile = "default"
  region  = "us-west-2"  
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
	availability_zone = "us-west-2a"
	tags = {
		"Terraform" : "true"
	}
}

resource "aws_default_subnet" "default_az2" {
	availability_zone = "us-west-2b"
	tags = {
		"Terraform" : "true"
	}
}

resource "aws_security_group" "prod_web" {
	name 				= "prod_web"
	description = "Allow standard http and https ports inbound and allow all on outbound"

	ingress {
		cidr_blocks = [ "0.0.0.0/0" ]
		from_port   = 80
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
		protocol    = "-1"
		to_port     = 0
	}

	tags = {
		"Terraform" : "true"
	}
}

resource "aws_elb" "prod_web" {
	name 	= "prod-web"
	subnets 				= [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
	security_groups = [aws_security_group.prod_web.id]

	listener {
		instance_port 		= 80
		instance_protocol = "http"
		lb_port 					= 80
		lb_protocol 			= "http"
	}
	tags = {
		"Terraform" : "true"
	}
}

resource "aws_launch_template" "prod_web" {
  name_prefix   = "prod-web"
  image_id      = "ami-0b79ddfbb9ee216ea"
  instance_type = "t2.micro"
	tags = {
		"Terraform" : "true"
	}
} 

resource "aws_autoscaling_group" "prod_web" {
  availability_zones  = ["us-west-2a","us-west-2b"]
  vpc_zone_identifier = [aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
	id      = aws_launch_template.prod_web.id
	version = "$Latest"
  }
	tag {
		key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
	}
}

resource "aws_autoscaling_attachment" "prod_web" {
  autoscaling_group_name = aws_autoscaling_group.prod_web.id
  elb                    = aws_elb.prod_web.id
}

