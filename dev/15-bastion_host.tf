# Openvpn Elastic IP
resource "aws_eip" "bastion_host" {
  instance = aws_instance.bastion_host.id
  tags = {
    Name = "bastion_host-elastic-ip"
  }
}

# Openvpn Security group
resource "aws_security_group" "bastion_host" {
  name   = "bastion_host"
  vpc_id = module.vpc.vpc_id

  # ssh port
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_host-${var.tag_env}"

  }
}

# Openvpn instance specification
resource "aws_instance" "bastion_host" {
  ami                    = "${data.aws_ami.latest-ubuntu.id}"
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
  key_name               = aws_key_pair.devops.id
  subnet_id              = element(module.vpc.public_subnets, 2)
  root_block_device {
    volume_size           = 30
    volume_type           = "gp2"
    delete_on_termination = true
  }
  lifecycle {
    ignore_changes = [
      user_data,
      vpc_security_group_ids,
      tags,
      volume_tags,
      root_block_device
    ]
  }
  tags = {
    Name = "${var.tag_env}-bastion_host"
  }
}

# Get Latest ubuntu 20.04 image
data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical account id
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
