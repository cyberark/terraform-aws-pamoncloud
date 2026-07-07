output "instance_id" {
  description = "ID of the Bastion EC2 instance."
  value       = aws_instance.bastion.id
}

output "private_ip" {
  description = "Private IP address of the Bastion instance."
  value       = aws_instance.bastion.private_ip
}

output "public_ip" {
  description = "Public IP address of the Bastion instance (use for RDP)."
  value       = aws_instance.bastion.public_ip
}
