locals {
  # Network locals
  region                     = "eu-west-1"
  pam_vpc_cidr               = "10.0.0.0/16"
  network_type               = "nat"
  users_access_cidr          = "192.168.0.0/16"
  administrative_access_cidr = "192.168.1.0/24"

  # General locals
  common_tags = {
    Creator     = "CyberArk PAMonCloud via Terraform"
    Region_Role = "Primary"
    Tf_Plan_Creation_Date = plantimestamp()
  }
  vault_admin_username = "Administrator"

  # PVWA locals
  pvwa_instance_name     = "[PAMonCloud_TF] PVWA"
  pvwa_instance_type     = "m5.xlarge"
  pvwa_instance_hostname = "pvwa"

  # CPM locals
  cpm_instance_name     = "[PAMonCloud_TF] CPM"
  cpm_instance_type     = "m5.xlarge"
  cpm_instance_hostname = "cpm"

  # PSM locals
  psm_instance_name     = "[PAMonCloud_TF] PSM"
  psm_instance_type     = "m5.2xlarge"
  psm_instance_hostname = "psm"

  # PSMP locals
  psmp_instance_name     = "[PAMonCloud_TF] PSMP"
  psmp_instance_type     = "m5.xlarge"
  psmp_instance_hostname = "psmp"

  # PTA locals
  pta_instance_name     = "[PAMonCloud_TF] PTA"
  pta_instance_type     = "m5.xlarge"
  pta_instance_hostname = "pta"
}

provider "aws" {
  region = local.region

  default_tags {
    tags = local.common_tags
  }
}

################################################################################
# deploy_prerequisites Module
################################################################################
module "deploy_prep" {
  source = "../../modules/deploy_prerequisites"
}

################################################################################
# pam_network Module
################################################################################
module "pam_network" {
  source                     = "../../modules/pam_network"
  pam_vpc_cidr               = local.pam_vpc_cidr
  network_type               = local.network_type
  users_access_cidr          = local.users_access_cidr
  administrative_access_cidr = local.administrative_access_cidr
  # VPN related vars:
  vpn_customer_gateway_address = var.vpn_customer_gateway_address
  vpn_external_vault_cidr      = var.vpn_external_vault_cidr
  log_group_arn                = module.deploy_prep.log_group_arn
}

################################################################################
# VPN connection (tunnels) readiness
################################################################################
locals {
  tunnels_status = try([for tunnel in module.pam_network.vpn_vgw_telemetry : tunnel.status], [])
  tunnels_status_summary = join(", ", [for status in local.tunnels_status : upper(status)])
  all_tunnels_up  = length([for status in local.tunnels_status : status if upper(status) == "UP"]) == 2
}

resource "terraform_data" "vpn_ready_gate" {
  lifecycle {
    postcondition {
      condition     = local.all_tunnels_up
      error_message = <<-EOM
      CONDITION FAILED
      
      VPN readiness check failed: there are no 2 tunnels with UP status.
      VPN Connection: ${module.pam_network.vpn_gateway_id}
      Observed tunnels status: [${local.tunnels_status_summary}]
      Please finish the remote-side configuration and re-run 'terraform apply'.
      EOM
    }
  }
  depends_on = [module.deploy_prep, module.pam_network]
}

################################################################################
# component Module
################################################################################
module "pvwa_instance" {
  source                         = "../../modules/component"
  deployment_identifier          = module.deploy_prep.deployment_uid
  instance_name                  = local.pvwa_instance_name
  instance_type                  = local.pvwa_instance_type
  key_name                       = var.key_name
  subnet_id                      = module.pam_network.private_subnets_map["PVWA Main Subnet"].id
  vpc_security_group_ids         = [module.pam_network.security_group_ids["PVWA"]]
  ami_id                         = var.pvwa_ami_id
  primary_vault_ip               = var.primary_vault_ip
  instance_hostname              = local.pvwa_instance_hostname
  component                      = "PVWA"
  vault_admin_username           = local.vault_admin_username
  vault_admin_password           = var.vault_admin_password
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
  depends_on                     = [resource.terraform_data.vpn_ready_gate]
}

module "cpm_instance" {
  source                         = "../../modules/component"
  deployment_identifier          = module.deploy_prep.deployment_uid
  instance_name                  = local.cpm_instance_name
  instance_type                  = local.cpm_instance_type
  key_name                       = var.key_name
  subnet_id                      = module.pam_network.private_subnets_map["CPM Main Subnet"].id
  vpc_security_group_ids         = [module.pam_network.security_group_ids["CPM"]]
  ami_id                         = var.cpm_ami_id
  primary_vault_ip               = var.primary_vault_ip
  pvwa_private_endpoint          = module.pvwa_instance.instance_ip_address
  instance_hostname              = local.cpm_instance_hostname
  component                      = "CPM"
  vault_admin_username           = local.vault_admin_username
  vault_admin_password           = var.vault_admin_password
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
  depends_on                     = [module.pvwa_instance]
}

module "psm_instance" {
  source                         = "../../modules/component"
  deployment_identifier          = module.deploy_prep.deployment_uid
  instance_name                  = local.psm_instance_name
  instance_type                  = local.psm_instance_type
  key_name                       = var.key_name
  subnet_id                      = module.pam_network.private_subnets_map["PSM Main Subnet"].id
  vpc_security_group_ids         = [module.pam_network.security_group_ids["PSM"]]
  ami_id                         = var.psm_ami_id
  primary_vault_ip               = var.primary_vault_ip
  instance_hostname              = local.psm_instance_hostname
  component                      = "PSM"
  vault_admin_username           = local.vault_admin_username
  vault_admin_password           = var.vault_admin_password
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
  depends_on                     = [module.cpm_instance]
}

module "psmp_instance" {
  source                         = "../../modules/component"
  deployment_identifier          = module.deploy_prep.deployment_uid
  instance_name                  = local.psmp_instance_name
  instance_type                  = local.psmp_instance_type
  key_name                       = var.key_name
  subnet_id                      = module.pam_network.private_subnets_map["PSMP Main Subnet"].id
  vpc_security_group_ids         = [module.pam_network.security_group_ids["PSMP"]]
  ami_id                         = var.psmp_ami_id
  primary_vault_ip               = var.primary_vault_ip
  instance_hostname              = local.psmp_instance_hostname
  component                      = "PSMP"
  vault_admin_username           = local.vault_admin_username
  vault_admin_password           = var.vault_admin_password
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
  depends_on                     = [module.cpm_instance]
}

module "pta_instance" {
  source                         = "../../modules/component"
  deployment_identifier          = module.deploy_prep.deployment_uid
  instance_name                  = local.pta_instance_name
  instance_type                  = local.pta_instance_type
  key_name                       = var.key_name
  subnet_id                      = module.pam_network.private_subnets_map["PTA Main Subnet"].id
  vpc_security_group_ids         = [module.pam_network.security_group_ids["PTA"]]
  ami_id                         = var.pta_ami_id
  primary_vault_ip               = var.primary_vault_ip
  pvwa_private_endpoint          = module.pvwa_instance.instance_private_dns
  instance_hostname              = local.pta_instance_hostname
  component                      = "PTA"
  vault_admin_username           = local.vault_admin_username
  vault_admin_password           = var.vault_admin_password
  log_group_name                 = module.deploy_prep.log_group_name
  manage_ssm_password_lambda     = module.deploy_prep.manage_ssm_password_lambda
  retrieve_success_signal_lambda = module.deploy_prep.retrieve_success_signal_lambda
  depends_on                     = [module.psm_instance, module.psmp_instance]
}