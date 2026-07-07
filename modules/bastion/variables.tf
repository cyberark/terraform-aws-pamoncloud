variable "instance_name" {
  description = "The name of the Bastion EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The type of the Bastion EC2 instance."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the Bastion instance resides (public_subnet)."
  type        = string
  validation {
    condition     = can(regex("^subnet-[a-f0-9]{8,}$", var.subnet_id))
    error_message = "Subnet ID must be in the format 'subnet-xxxxxxxx' where 'x' is a hexadecimal digit."
  }
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with the EC2 instance."
  type        = list(string)
  validation {
    condition     = length(var.vpc_security_group_ids) > 0
    error_message = "At least one security group ID must be provided."
  }
  validation {
    condition     = alltrue([for sg in var.vpc_security_group_ids : can(regex("^sg-[a-f0-9]{8,}$", sg))])
    error_message = "Each provided security group ID must be in the format 'sg-xxxxxxxx' where 'x' is a hexadecimal digit."
  }
}

variable "key_name" {
  description = "The name of the EC2 key pair to use for the Bastion instance. Use this key to retrieve the Windows Administrator password (e.g. via EC2 console Get Windows Password or aws ec2 get-password-data)."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]{1,255}$", var.key_name))
    error_message = "Key name must be between 1 and 255 characters long and can only contain alphanumeric characters, hyphens (-), and underscores (_)."
  }
}

variable "bastion_aws_ami_owner" {
  description = "The owner of the Bastion AWS AMI."
  type        = string
  default     = ""
}

variable "bastion_aws_ami_filter_name" {
  description = "The name of the Bastion AWS AMI."
  type        = string
  default     = ""
}