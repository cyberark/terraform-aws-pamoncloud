locals {
  vpn_deployment = (var.vpn_customer_gateway_address != "" && var.vpn_external_vault_cidr != "")
  vpn_rules_flat = flatten([
    for component, rules in var.vpn_rules : [
      for rule_name, rule in rules : {
        component = component
        rule_name = rule_name
        rule      = rule
      }
    ]
  ])
}

resource "aws_security_group_rule" "vpn_rules_with_cidr" {
  count = local.vpn_deployment ? length(local.vpn_rules_flat) : 0

  type              = local.vpn_rules_flat[count.index].rule[0]
  from_port         = local.vpn_rules_flat[count.index].rule[1]
  to_port           = local.vpn_rules_flat[count.index].rule[2]
  protocol          = local.vpn_rules_flat[count.index].rule[3]
  description       = local.vpn_rules_flat[count.index].rule[4]
  security_group_id = aws_security_group.security_group[local.vpn_rules_flat[count.index].component].id
  cidr_blocks       = local.vpn_rules_flat[count.index].rule[5] != null ? [lookup(local.cidr_map, local.vpn_rules_flat[count.index].rule[5], lookup(local.subnet_cidr_map, local.vpn_rules_flat[count.index].rule[5], local.vpn_rules_flat[count.index].rule[5]))] : []

  depends_on = [resource.aws_security_group.security_group, resource.aws_customer_gateway.customer_gateway]
}

resource "aws_customer_gateway" "customer_gateway" {
  count = local.vpn_deployment ? 1 : 0

  bgp_asn    = 65000
  ip_address = var.vpn_customer_gateway_address
  type       = "ipsec.1"

  tags = {
    Name = "PAMonCloud Customer Gateway"
  }

  depends_on = [module.pam_vpc]
}

resource "aws_vpn_connection" "vpn_connection" {
  count = local.vpn_deployment ? 1 : 0

  customer_gateway_id = resource.aws_customer_gateway.customer_gateway[0].id
  vpn_gateway_id      = module.pam_vpc.vgw_id
  type                = "ipsec.1"
  static_routes_only  = true

  # VPN Tunnel-1 Options
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel1_phase1_dh_group_numbers      = ["14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
  tunnel1_phase2_dh_group_numbers      = ["14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
  tunnel1_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel1_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]

  # VPN Tunnel-2 Options
  tunnel2_ike_versions                 = ["ikev2"]
  tunnel2_phase1_dh_group_numbers      = ["14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
  tunnel2_phase2_dh_group_numbers      = ["14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
  tunnel2_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel2_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]

  tunnel1_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_output_format = "json"
      log_group_arn     = var.log_group_arn
    }
  }
  tunnel2_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_output_format = "json"
      log_group_arn     = var.log_group_arn
    }
  }

  tags = {
    Name = "PAMonCloud VPN Connection"
  }

  depends_on = [resource.aws_customer_gateway.customer_gateway]
}

resource "aws_vpn_connection_route" "vpn_connection_static_route" {
  count = local.vpn_deployment ? 1 : 0

  destination_cidr_block = var.vpn_external_vault_cidr
  vpn_connection_id      = resource.aws_vpn_connection.vpn_connection[0].id
}

variable "vpn_rules" {
  description = "Map of security group VPN rules for each component (define as 'name' = ['from port', 'to port', 'protocol', 'description', 'source_security_group_id', 'cidr'])"
  type        = map(map(list(any)))
  default = {
    Vault = {
      VaultSGIngress100 = ["ingress", 1858, 1858, "tcp", "Vault to external Vault network connection", "vpnCIDR"]
      VaultSGIngress101 = ["ingress", 5671, 5671, "tcp", "Vault to external Vault network connection", "vpnCIDR"]
      VaultSGIngress102 = ["ingress", -1, -1, "icmp", "external Vault network ICMP connection", "vpnCIDR"]

      VaultSGEgress100 = ["egress", 5671, 5671, "tcp", "Vault to external Vault network connection", "vpnCIDR"]
      VaultSGEgress101 = ["egress", 1858, 1858, "tcp", "Vault to external Vault network connection", "vpnCIDR"]
    }

    CPM = {
      CPMSGEgress100 = ["egress", 1858, 1858, "tcp", "CPM to external Vault network", "vpnCIDR"]
    }

    PSM = {
      PSMSGEgress100 = ["egress", 1858, 1858, "tcp", "PSM to external Vault network", "vpnCIDR"]
    }

    PSMP = {
      PSMPSGEgress100 = ["egress", 1858, 1858, "tcp", "PSMP to external Vault network", "vpnCIDR"]
    }

    PVWA = {
      PVWASGEgress100 = ["egress", 1858, 1858, "tcp", "PVWA to external Vault network", "vpnCIDR"]
      PVWASGEgress101 = ["egress", 5671, 5671, "tcp", "PVWA to external Vault network", "vpnCIDR"]
    }

    PTA = {
      PTASGIngress100 = ["ingress", 514, 514, "udp", "Allow external Vault network incoming syslog messages", "vpnCIDR"]
      PTASGIngress101 = ["ingress", 514, 514, "tcp", "Allow external Vault network incoming syslog messages", "vpnCIDR"]
      PTASGEgress102  = ["egress", 1858, 1858, "tcp", "Allow external Vault network outgoing connection to the CyberArk Vault for specific IP address", "vpnCIDR"]
      PTASGEgress103  = ["egress", 1858, 1858, "udp", "Allow external Vault network outgoing connection to the CyberArk Vault for specific IP address", "vpnCIDR"]
    }
  }
}