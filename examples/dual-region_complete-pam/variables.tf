variable "deploy_bastion" {
  description = "When true, deploys a Bastion EC2 instance in the public subnet."
  type        = bool
  default     = false
}

variable "bastion_access_cidr" {
  description = "List of allowed IPv4 CIDR blocks for RDP access to the Bastion instance"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "The name of the EC2 key pair to use."
  type        = string
}

variable "vault_files_bucket" {
  description = "The name of the S3 bucket where Vault license and recovery key are stored."
  type        = string
}

variable "vault_master_password" {
  description = "Primary Vault Master Password."
  type        = string
  sensitive   = true
}

variable "vault_admin_password" {
  description = "Primary Vault Admin Password."
  type        = string
  sensitive   = true
}

variable "vault_dr_password" {
  description = "Vault DR User Password."
  type        = string
  sensitive   = true
}

variable "vault_dr_secret" {
  description = "Vault DR User Secret."
  type        = string
  sensitive   = true
}

variable "vault_ami_id" {
  description = "AMI ID to use for the EC2 instance deployment."
  type        = string
}

variable "vault_dr_ami_id" {
  description = "AMI ID to use for the EC2 instance deployment."
  type        = string
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