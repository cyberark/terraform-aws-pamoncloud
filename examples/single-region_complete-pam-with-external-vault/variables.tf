variable "key_name" {
  description = "The name of the EC2 key pair to use."
  type        = string
}

variable "vault_admin_password" {
  description = "Primary Vault Admin Password."
  type        = string
  sensitive   = true
}

variable "pvwa_ami_id" {
  description = "AMI ID to use for the EC2 instance deployment."
  type        = string
}

variable "cpm_ami_id" {
  description = "AMI ID to use for the EC2 instance deployment."
  type        = string
}

variable "psm_ami_id" {
  description = "AMI ID to use for the EC2 instance deployment."
  type        = string
}

variable "psmp_ami_id" {
  description = "AMI ID to use for the EC2 instance deployment."
  type        = string
}

variable "pta_ami_id" {
  description = "AMI ID to use for the EC2 instance deployment."
  type        = string
}

variable "vpn_customer_gateway_address" {
  description = "Public IP address of the remote network"
  type        = string
}

variable "vpn_external_vault_cidr" {
  description = "IPv4 address range of the remote network hosting the external Vault"
  type        = string
}

variable "primary_vault_ip" {
  description = "The IP address of the primary Vault."
  type        = string
}