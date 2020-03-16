resource "aws_security_group" "blueprint_sg_res" {
  name        = "${var.project_name}-sg"
  description = "firewall rules"
  vpc_id      = "${var.target_vpc}"

  # We might need other ports here as well based on dm team
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Server Definition
resource "aws_instance" "blueprint_inst_res" {
  ami                    = "${var.aws_ami}"
  instance_type          = "${var.server_type}"
  vpc_security_group_ids = ["${aws_security_group.blueprint_sg_res.id}", ]
  key_name               = "${var.target_keypairs}"
  subnet_id              = "${var.target_subnet}"

  tags = {
    Name = "${var.project_name}-server"
  }
}

output "pub_ip" {
  value = ["${aws_instance.blueprint_inst_res.public_ip}"]
}


