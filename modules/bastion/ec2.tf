data "aws_ami" "windows_ami" {
  most_recent = true
  owners      = [var.bastion_aws_ami_owner]

  filter {
    name   = "name"
    values = [var.bastion_aws_ami_filter_name]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.windows_ami.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = true

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = var.instance_name
  }
}
