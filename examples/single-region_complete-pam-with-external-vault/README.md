# PAMonCloud for AWS - Single Region - Complete PAM with External Vault Deployment

Configuration in this directory creates a networking environment and EC2 instances of PAM components (PVWA, CPM, PSM, PSMP, PTA), deployed to function together with external Vault connected over site to site VPN. This setup is suitable for staging or production environments.

The setup includes the following components:
- Site to site VPN
- PVWA (Password Vault Web Access)
- CPM (Central Policy Manager)
- PSM (Privileged Session Manager)
- PSMP (Privileged Session Manager Proxy)
- PTA (Privileged Threat Analytics)

Each component is deployed in a way that ensures they function together seamlessly.

## Usage

To run this example you need input the required variables, then execute:

```bash
terraform init
terraform plan
terraform apply
```

Note that this example creates resources which can cost money (AWS EC2 Instance, for example). Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](https://github.com/hashicorp/terraform) | 1.9.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](https://github.com/hashicorp/terraform-provider-aws) | 5.73.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_pam_network"></a> [pam_network](/modules/pam_network/) | ../../modules/pam_network | n/a |
| <a name="module_deploy_prerequisites"></a> [deploy_prerequisites](/modules/deploy_prerequisites/) | ../../modules/deploy_prerequisites | n/a |
| <a name="module_component"></a> [component](/modules/component/) | ../../modules/component | n/a |

## Inputs

| Name | Description |
|------|-------------|
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the EC2 key pair to use. |
| <a name="input_vault_admin_password"></a> [vault\_admin\_password](#input\_vault\_admin\_password) | Primary Vault Admin Password. |
| <a name="input_vault_dr_password"></a> [vault\_dr\_password](#input\_vault\_dr\_password) | Primary Vault DR Password. |
| <a name="input_vault_dr_secret"></a> [vault\_dr\_secret](#input\_vault\_dr\_secret) | Primary Vault DR Secret. (Required only for DR implementations)|
| <a name="input_pvwa_ami_id"></a> [pvwa\_ami\_id](#input\_pvwa\_ami\_id) | AMI ID to use for the EC2 instance deployment. |
| <a name="input_cpm_ami_id"></a> [cpm\_ami\_id](#input\_cpm\_ami\_id) | AMI ID to use for the EC2 instance deployment. |
| <a name="input_psm_ami_id"></a> [psm\_ami\_id](#input\_psm\_ami\_id) | AMI ID to use for the EC2 instance deployment. |
| <a name="input_psmp_ami_id"></a> [psmp\_ami\_id](#input\_psmp\_ami\_id) | AMI ID to use for the EC2 instance deployment. |
| <a name="input_pta_ami_id"></a> [pta\_ami\_id](#input\_pta\_ami\_id) | AMI ID to use for the EC2 instance deployment. |
| <a name="input_vpn_customer_gateway_address"></a> [vpn\_customer\_gateway\_address](#input\_vpn\_customer\_gateway\_address) | Public IP address of the remote network. |
| <a name="input_vpn_external_vault_cidr"></a> [vpn\_external\_vault\_cidr](#input\_vpn\_external\_vault\_cidr) | IPv4 address range of the remote network hosting the external Vault. |
| <a name="input_primary_vault_ip"></a> [primary\_vault\_ip](#input\_primary\_vault\_ip) | The IP address of the primary Vault. |

## Outputs

| Name | Module | Description |
|------|--------|-------------|
| <a name="output_common_tags"></a> [common\_tags](#output\_common\_tags) | N/A | Common tags assigned to all resources. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | pam_network | VPC ID. |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | pam_network | Public Subnet IDs. |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | pam_network | Public route tables IDs. |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | pam_network | Private route tables IDs. |
| <a name="output_natgw_ids"></a> [natgw\_ids](#output\_natgw\_ids) | pam_network | List of NAT Gateway IDs. |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | pam_network | Security Group IDs for all components. |
| <a name="output_private_subnets_map"></a> [private\_subnets\_map](#output\_private\_subnets\_map) | pam_network | A map of subnet details (id and cidr_block) by name. |
| <a name="output_vpn_gateway_id"></a> [vpn\_gateway\_id](#output\_vpn\_gateway\_id) | pam_network | VPN gateway ID. |
| <a name="output_vpn_connection_id"></a> [vpn\_connection\_id](#output\_vpn\_connection\_id) | pam_network | VPN connection ID. |
| <a name="output_deployment_uid"></a> [deployment\_uid](#output\_deployment\_uid) | deploy_prerequisites | Deployment Unique ID. |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | deploy_prerequisites | CloudWatch Log Group name. |
| <a name="output_pvwa_instance_ip_address"></a> [pvwa\_instance\_ip\_address](#output\_pvwa\_instance\_ip\_address) | component | PVWA instance IP address. |
| <a name="output_pvwa_instance_private_dns"></a> [pvwa\_instance\_private\_dns](#output\_pvwa\_instance\_private\_dns) | component | PVWA instance private DNS. |
| <a name="output_pvwa_instance_id"></a> [pvwa\_instance\_id](#output\_pvwa\_instance\_id) | component | PVWA instance ID. |
| <a name="output_pvwa_instance_hostname"></a> [pvwa\_instance\_hostname](#output\_pvwa\_instance\_hostname) | component | PVWA instance hostname. |
| <a name="output_cpm_instance_ip_address"></a> [cpm\_instance\_ip\_address](#output\_cpm\_instance\_ip\_address) | component | CPM instance IP address. |
| <a name="output_cpm_instance_private_dns"></a> [cpm\_instance\_private\_dns](#output\_cpm\_instance\_private\_dns) | component | CPM instance private DNS. |
| <a name="output_cpm_instance_id"></a> [cpm\_instance\_id](#output\_cpm\_instance\_id) | component | CPM instance ID. |
| <a name="output_cpm_instance_hostname"></a> [cpm\_instance\_hostname](#output\_cpm\_instance\_hostname) | component | CPM instance hostname. |
| <a name="output_psm_instance_ip_address"></a> [psm\_instance\_ip\_address](#output\_psm\_instance\_ip\_address) | component | PSM instance IP address. |
| <a name="output_psm_instance_private_dns"></a> [psm\_instance\_private\_dns](#output\_psm\_instance\_private\_dns) | component | PSM instance private DNS. |
| <a name="output_psm_instance_id"></a> [psm\_instance\_id](#output\_psm\_instance\_id) | component | PSM instance ID. |
| <a name="output_psm_instance_hostname"></a> [psm\_instance\_hostname](#output\_psm\_instance\_hostname) | component | PSM instance hostname. |
| <a name="output_psmp_instance_ip_address"></a> [psmp\_instance\_ip\_address](#output\_psmp\_instance\_ip\_address) | component | PSMP instance IP address. |
| <a name="output_psmp_instance_private_dns"></a> [psmp\_instance\_private\_dns](#output\_psmp\_instance\_private\_dns) | component | PSMP instance private DNS. |
| <a name="output_psmp_instance_id"></a> [psmp\_instance\_id](#output\_psmp\_instance\_id) | component | PSMP instance ID. |
| <a name="output_psmp_instance_hostname"></a> [psmp\_instance\_hostname](#output\_psmp\_instance\_hostname) | component | PSMP instance hostname. |
| <a name="output_pta_instance_ip_address"></a> [pta\_instance\_ip\_address](#output\_pta\_instance\_ip\_address) | component | PTA instance IP address. |
| <a name="output_pta_instance_private_dns"></a> [pta\_instance\_private\_dns](#output\_pta\_instance\_private\_dns) | component | PTA instance private DNS. |
| <a name="output_pta_instance_id"></a> [pta\_instance\_id](#output\_pta\_instance\_id) | component | PTA instance ID. |
| <a name="output_pta_instance_hostname"></a> [pta\_instance\_hostname](#output\_pta\_instance\_hostname) | component | PTA instance hostname. |

## Resources

### Retrieve information about a resource (post deployment)
You can use the `terraform state show` command followed by: `module.<module_name>.<resource_name>`  
Example: `terraform state show 'module.vault_instance.aws_instance.vault'`  
For list objects, you can use `terraform state list` to get all objects within the list.

#### **EC2 Instances**
| Resource                              | Description                                    | Module                                       |
|---------------------------------------|------------------------------------------------|----------------------------------------------|
| `aws_instance.component`              | Component EC2 instance resource.               | [Component Instances](#component-instances)  |

#### **CloudWatch Resources**
| Resource                                                      | Description                                                | Module                           |
|---------------------------------------------------------------|------------------------------------------------------------|----------------------------------|
| `aws_cloudwatch_log_group.log_group`                          | CloudWatch log group.                                      | deploy_prep                      |
| `aws_cloudwatch_log_stream.additional_log_streams` (list)     | CloudWatch log streams for additional configuration.       | [All Instances](#all-instances)  |
| `aws_cloudwatch_log_stream.user_data_log_stream`              | CloudWatch log stream for user data logs.                  | [All Instances](#all-instances)  |

#### **IAM Roles/Policies**
| Resource                                                                                 | Description                                                     | Module                               |
|------------------------------------------------------------------------------------------|-----------------------------------------------------------------|--------------------------------------|
| `aws_iam_instance_profile.instance_profile`                                              | IAM instance profile.                                           | [All Instances](#all-instances)      |
| `aws_iam_role.instance_role`                                                             | IAM role for the instance.                                      | [All Instances](#all-instances)      |
| `aws_iam_role.lambda_manage_ssm_password_role`                                           | IAM role for managing SSM password in Lambda.                   | deploy_prep                          |
| `aws_iam_role.lambda_remove_permissions_role`                                            | IAM role for removing permissions in Lambda.                    | deploy_prep                          |
| `aws_iam_role.lambda_retrieve_success_signal_role`                                       | IAM role for retrieving success signal in Lambda.               | deploy_prep                          |
| `aws_iam_role_policy.instance_cloudwatch_policy`                                         | IAM policy for CloudWatch logging.                              | [All Instances](#all-instances)      |
| `aws_iam_role_policy.instance_kms_policy`                                                | IAM policy for AWS KMS.                                         | [All Instances](#all-instances)      |
| `aws_iam_role_policy.instance_s3_policy`                                                 | IAM policy for S3 access.                                       | vault_instance                       |
| `aws_iam_role_policy.instance_ssm_policy`                                                | IAM policy for SSM management.                                  | [All Instances](#all-instances)      |
| `aws_iam_role_policy.lambda_manage_ssm_password_policy`                                  | IAM policy for managing SSM password in Lambda.                 | deploy_prep                          |
| `aws_iam_role_policy.lambda_remove_permissions_policy`                                   | IAM policy for removing permissions via Lambda.                 | [Vault Instances](#vault-instances)  |
| `aws_iam_role_policy.lambda_retrieve_success_signal_policy`                              | IAM policy for retrieving success signal in Lambda.             | deploy_prep                          |
| `aws_iam_role_policy_attachment.instance_ssm_managed_policy`                             | IAM role policy attachment for AWS managed SSM policy.          | [All Instances](#all-instances)      |
| `aws_iam_role_policy_attachment.lambda_manage_ssm_password_execution_managed_policy`     | IAM policy attachment for Lambda to manage SSM password.        | deploy_prep                          |
| `aws_iam_role_policy_attachment.lambda_remove_permissions_execution_managed_policy`      | IAM policy attachment for Lambda to remove permissions.         | deploy_prep                          |
| `aws_iam_role_policy_attachment.lambda_retrieve_success_signal_execution_managed_policy` | IAM policy attachment for Lambda to retrieve success signal.    | deploy_prep                          |
| `data.aws_iam_policy_document.instance_assume_role_policy`                               | IAM policy document defining instance assume role policy.       | [All Instances](#all-instances)      |
| `data.aws_iam_policy_document.lambda_assume_role_policy`                                 | IAM policy document for Lambda assume role.                     | deploy_prep                          |
| `data.aws_iam_policy_document.lambda_remove_permissions_policy`                          | IAM policy document for removing permissions via Lambda.        | [Vault Instances](#vault-instances)  |

#### **Lambda Resources**
| Resource                                             | Description                                                   | Module                                                       |
|------------------------------------------------------|---------------------------------------------------------------|--------------------------------------------------------------|
| `aws_lambda_function.manage_ssm_password_lambda`     | Lambda for managing SSM password.                             | deploy_prep                                                  |
| `aws_lambda_function.remove_permissions_lambda`      | Lambda for removing permissions.                              | deploy_prep                                                  |
| `aws_lambda_function.retrieve_success_signal_lambda` | Lambda for retrieving success signal.                         | deploy_prep                                                  |
| `aws_lambda_invocation.remove_admin_password`	       | Lambda invocation for removing admin password.	              | [Component Instances](#component-instances)                  |
| `aws_lambda_invocation.store_admin_password`	       | Lambda invocation for storing admin password.	              | [Component Instances](#component-instances)                  |
| `aws_lambda_invocation.wait_for_userdata_completion` | Lambda invocation to monitor user data completion.            | [All Instances](#all-instances)                              |

#### **Network and Security**
| Resource                                                                             | Description                                             | Module               |
|--------------------------------------------------------------------------------------|---------------------------------------------------------|----------------------|
| `aws_network_acl.vault_nacl`                                                         | Vault network ACL.                                      | pam_network          |
| `aws_security_group.security_group` (list)                                           | List of Security groups for all instances.              | pam_network          |
| `aws_security_group_rule.rules_with_cidr` (list)                                     | List of security group rules with CIDR blocks.          | pam_network          |
| `module.pam_vpc.aws_default_network_acl.this[0]`                                     | Default network ACL for the VPC.                        | pam_network          |
| `module.pam_vpc.aws_default_route_table.default[0]`                                  | Default route table for the VPC.                        | pam_network          |
| `module.pam_vpc.aws_default_security_group.this[0]`                                  | Default security group for the VPC.                     | pam_network          |
| `module.pam_vpc.aws_eip.nat[0]`                                                      | Elastic IP for the NAT gateway.                         | pam_network          |
| `module.pam_vpc.aws_internet_gateway.this[0]`                                        | Internet gateway for the VPC.                           | pam_network          |
| `module.pam_vpc.aws_nat_gateway.this[0]`                                             | NAT gateway for the VPC.                                | pam_network          |
| `module.pam_vpc.aws_route.private_nat_gateway[0]`                                    | Route for private subnets to the NAT gateway.           | pam_network          |
| `module.pam_vpc.aws_route.public_internet_gateway[0]`                                | Route for public subnets to the internet gateway.       | pam_network          |
| `module.pam_vpc.aws_route_table.private[0]`                                          | Route table for private subnets.                        | pam_network          |
| `module.pam_vpc.aws_route_table.public[0]`                                           | Route table for public subnets.                         | pam_network          |
| `module.pam_vpc.aws_route_table_association.private` (list)                          | List of route table associations for private subnets.   | pam_network          |
| `module.pam_vpc.aws_route_table_association.public[0]`                               | Route table association for public subnets.             | pam_network          |
| `module.pam_vpc.aws_subnet.private` (list)                                           | List of private subnets.                                | pam_network          |
| `module.pam_vpc.aws_subnet.public[0]`                                                | Public subnet.                                          | pam_network          |
| `module.pam_vpc.aws_vpc.this[0]`                                                     | The VPC resource.                                       | pam_network          |
| `module.pam_network.module.pam_vpc.aws_vpn_gateway.this[0]`                          | The VPN gateway.                                        | pam_network          |
| `module.pam_network.module.pam_vpc.aws_vpn_gateway_route_propagation.private` (list) | List of VPN gateway route propagation.                  | pam_network          |

#### **Miscellaneous**
| Resource                                          | Description                                                 | Module                                        |
|---------------------------------------------------|-------------------------------------------------------------|-----------------------------------------------|
| `data.archive_file.manage_ssm_password_zip`       | Archive file for managing SSM passwords.                    | deploy_prep                                   |
| `data.archive_file.remove_permissions_zip`        | Archive file for removing permissions.                      | deploy_prep                                   |
| `data.archive_file.retrieve_success_signal_zip`   | Archive file for retrieving success signal.                 | deploy_prep                                   |
| `data.aws_availability_zones.available`           | AWS availability zones information.                         | pam_network                                   |
| `data.aws_caller_identity.current`                | AWS Caller Identity of current user.                        | [All Instances](#all-instances), deploy_prep  |
| `data.aws_partition.current`                      | Current AWS partition.                                      | [All Instances](#all-instances), deploy_prep  |
| `data.aws_region.current`                         | Current AWS region.                                         | [All Modules](#all-modules)                   |
| `null_resource.always_recreate`                   | Triggers resource recreation.                               | [All Modules](#all-modules)                   |
| `null_resource.userdata_updated`                  | Manages updates to user data.                               | [Component Instances](#component-instances)   |
| `random_string.deployment_uid`                    | Unique identifier for deployment.                           | [All Instances](#all-instances), deploy_prep  |

### Each nickname includes the following modules

<a name="vault-instances"></a>
**_Vault Instances_**:  
   `vault_instance`, `vault_dr_instance`

<a name="component-instances"></a>
**_Component Instances_**:  
   `pvwa_instance`, `cpm_instance`, `psm_instance`, `psmp_instance`, `pta_instance`

<a name="all-instances"></a>
**_All Instances_**:  
   `vault_instance`, `vault_dr_instance`, `pvwa_instance`, `cpm_instance`, `psm_instance`, `psmp_instance`, `pta_instance`

<a name="all-modules"></a>
**_All Modules_**:  
   `vault_instance`, `vault_dr_instance`, `pvwa_instance`, `cpm_instance`, `psm_instance`, `psmp_instance`, `pta_instance`, `deploy_prep`, `pam_network`

<!-- END_TF_DOCS -->
