provider "aws" {
	region = "${var.aws_region}"
}

resource "aws_security_group" "tomcat" {
	name = "tomcat"
	description = "Tomcat Security Group"
	ingress	{
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks     = ["0.0.0.0/0"]
	}
}


resource "aws_instance" "tomcat1" {
	count = "1"
	ami = "${var.ami}"
	key_name = "${var.key_name}"
	instance_type = "${var.ins_type}"
	availability_zone = "${var.az_1a}"
	security_groups = ["${aws_security_group.tomcat.name}"]
	user_data = "${file("install_tomcat.sh")}"
	tags = {
		Name = "Tomcat"
	}
}	

