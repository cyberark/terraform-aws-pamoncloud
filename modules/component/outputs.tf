output "deployment_uid" {
  value = local.deployment_uid
}

output "instance_ip_address" {
  value = aws_instance.component.private_ip
}

output "instance_private_dns" {
  value = aws_instance.component.private_dns
}

output "instance_id" {
  value = aws_instance.component.id
}

output "instance_hostname" {
  value = var.instance_hostname
}