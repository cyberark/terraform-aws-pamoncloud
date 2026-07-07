variable "pam_vpc_cidr" {
  type = string
}

variable "users_access_cidr" {
  description = "Allowed IPv4 address range for users access to CyberArk components"
  type        = string
  validation {
    condition     = can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/([0-9]|[1-2][0-9]|3[0-2]))$", var.users_access_cidr))
    error_message = "Must be a valid IP CIDR range of the form x.x.x.x/x."
  }
}

variable "administrative_access_cidr" {
  description = "Allowed IPv4 address range for Remote Desktop administrative access to CyberArk instances"
  type        = string
  validation {
    condition     = can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/([0-9]|[1-2][0-9]|3[0-2]))$", var.administrative_access_cidr))
    error_message = "Must be a valid IP CIDR range of the form x.x.x.x/x."
  }
}

variable "bastion_access_cidr" {
  description = "List of allowed IPv4 CIDR blocks for RDP access to the Bastion instance"
  type        = list(string)
  default     = []
}

variable "network_type" {
  description = "The type of networking to deploy. Valid options: 'privatelink' or 'nat'"
  type        = string
  validation {
    condition     = contains(["privatelink", "nat"], lower(var.network_type))
    error_message = "Invalid network type. Valid options are: 'privatelink', 'nat'"
  }
}

variable "vpn_customer_gateway_address" {
  description = "Public IP address of the remote network"
  type        = string
  default     = ""
}

variable "vpn_external_vault_cidr" {
  description = "IPv4 address range of the remote network hosting the external Vault"
  type        = string
  default     = ""
  validation {
    condition     = var.vpn_external_vault_cidr != var.pam_vpc_cidr
    error_message = "Overlapping CIDRs. vpn_external_vault_cidr can't overlap with pam_vpc_cidr"
  }
}

variable "log_group_arn" {
  description = "ARN of the CloudWatch log group."
  type        = string
  default     = ""
  validation {
    condition = (
      var.log_group_arn == "" ||
      can(regex(
        "^arn:(aws|aws-us-gov):logs:[a-z0-9-]+:[0-9]{12}:log-group:[A-Za-z0-9_./-]+(?::\\*)?$",
        var.log_group_arn
        )
      )
    )
    error_message = "The value must be a valid CloudWatch log group ARN (e.g. arn:aws:logs:region:123456789012:log-group:my-log-group or with :* suffix)."
  }
}