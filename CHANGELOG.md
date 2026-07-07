# CyberArk PAMonCloud Terraform Package Release Notes
The PAMonCloud Terraform package includes CyberArk PAM product implementations, delivered as Terraform modules and examples to automate deployment on AWS. This solution provides enhanced flexibility and scalability for deploying core PAM components and associated infrastructure.

## [PAMonCloud Terraform on AWS v15.2] (07.07.2026)

### Added
- New `bastion` module for deploying a Bastion VM, integrated into the complete-PAM examples with related variables and outputs.

### Changed
- Updated Terraform version constraints to support versions 1.9.8 through 1.13.5 across all modules and examples.

## [PAMonCloud Terraform on AWS v15.0] (15.12.2025)

### Added
- Global tag for all Terraform assets. There are three new tags:
    Terraform plan creation date (unique and can be used to filter a specific env)
    Creator = CyberArk PAMonCloud via Terraform
    Region_Role = Primary/DR
- Single region complete PAM deployment with external Vault using site to site VPN.

## [PAMonCloud Terraform on AWS v14.6] (1.7.2025)

### Changed
- Component Image ID variables , which were previously optional, are now required.
- cpm_instance module now required PVWA's IP address to be provided.

### Removed
- Premade PAM images are no longer distributed. PAM Images can be obtained by using PAMonCloud's image building solution.
- Removed usage of aws_ami data source for fetching latest AMIs.

## [PAMonCloud Terraform on AWS v14.4] (12.12.2024)

### Added
- First Release of PAMonCloud over Terraform. This release of the PAMonCloud Terraform deployment tools for AWS provides enhanced flexibility and scalability.

- Cross-region deployments.

- Support for Windows Server 2022 images across all Windows-based components.

- **New Modules**: `pam_network`, `pam_network_peering`, `component`, `vault`, `vault_dr`, `deploy_prerequisites`  
New modules simplify the deployment of core PAM components and associated infrastructure.

- **New Examples**: `dual-region_complete-pam`, `dual-region_vault-with-dr`, `single-region_complete-pam`, `single-region_single-component`  
New examples demonstrate common deployment patterns for single and dual-region setups.