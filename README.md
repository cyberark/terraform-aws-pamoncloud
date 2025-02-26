# CyberArk PAM Deployment with Terraform

## Overview  
Welcome to the **CyberArk PAM Terraform Modules** repository! This project provides robust tools and scripts to simplify the deployment of **CyberArk's Privileged Access Manager (PAM)** on **Amazon Web Services (AWS)**.  

With our Terraform modules, you can deploy CyberArk PAM across various architectures:  
- **Fully cloud-native**
- **Cross-region**
- **Hybrid**

These solutions are designed to be flexible, scalable, and adaptable to your organization's specific requirements.

## Features  
- **Modular architecture**: Use only the components you need for your environment.  
- **Customizable configurations**: Adjust settings to fit your organization’s unique PAM deployment.  
- **Examples included**: Step-by-step examples to help you get started quickly.  

## Prerequisites  
Before using these modules, ensure you have the following:  
- A valid **CyberArk PAM license**  
- **Terraform** installed  
- AWS account with necessary permissions for deploying resources  

Refer to the [Prerequisites](https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20cloud/deploy_terraform.htm#Prerequisites) section in our documentation for detailed setup instructions.

## Quick Start  
To get started:  
1. Clone this repository:  
   ```bash
   git clone https://github.com/cyberark/terraform-aws-pamoncloud.git
   cd terraform-aws-pamoncloud
   ```

2. Log in to your AWS account: [Terraform Instructions for AWS Authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration)

3. Review the provided examples under the `examples/` directory.

4. Customize the variables as needed. You can use any of the methods described in the [Terraform Configuration Language Documentation](https://developer.hashicorp.com/terraform/language/values/variables#assigning-values-to-root-module-variables).

5. Deploy with Terraform:  
   ```bash
   terraform init  
   terraform apply  
   ```

6. Follow the post-deployment steps in the [Post Installation Guide](https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20cloud/post-installation.htm).

## Documentation  
- [User Guide](https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20cloud/deploy_terraform.htm): Comprehensive instructions for deployment, configuration, and troubleshooting.  
- [Modules](/modules): Detailed documentation for each Terraform module.  
- [Examples](/examples): Ready-to-use examples for various architectures.  

## Licensing  
This repository is subject to the following licenses:  
- **CyberArk Privileged Access Manager**: Licensed under the [CyberArk Software EULA](https://www.cyberark.com/EULA.pdf).  
- **Terraform templates**: Licensed under the Apache License, Version 2.0 ([LICENSE](LICENSE)).  

## Contributing  
We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for more details.

## About  
CyberArk is a global leader in **Identity Security**, providing powerful solutions for managing privileged access. Learn more at [www.cyberark.com](https://www.cyberark.com).  