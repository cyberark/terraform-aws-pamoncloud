#### Provision Vault DR Instance

resource "aws_instance" "vault_dr" {
  ami                    = var.custom_ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.id
  user_data              = local.user_data

  root_block_device {
    encrypted = true
  }
  ebs_block_device {
    device_name = "/dev/sdb"
    encrypted   = true
  }

  tags = {
    Name = var.instance_name
  }

  # Wait for instance to become reachable before resource "Creation complete"
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${self.id} --region ${local.region}"
  }
}