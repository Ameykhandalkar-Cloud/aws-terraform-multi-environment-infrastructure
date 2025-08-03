# ========================================
# PROVIDER.TF - AWS PROVIDER CONFIGURATION
# ========================================
# 
# PURPOSE:
# This file configures the AWS provider that Terraform uses to create and
# manage AWS resources. It establishes the connection to AWS and defines
# the default region for all resources.
# 
# WHAT THIS FILE DOES:
# - Configures the AWS provider with the specified region
# - Sets up authentication context for AWS API calls
# - Establishes the default region for all AWS resources
# - Enables Terraform to communicate with AWS services
# TERRAFORM CONCEPTS DEMONSTRATED:
# - Provider configuration blocks
# - Variable references in provider settings
# - Infrastructure component separation
# AUTHENTICATION:
# This provider configuration assumes AWS credentials are configured via:
# - AWS CLI (aws configure)
# - Environment variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
# - IAM roles (when running on EC2)
# - AWS SSO profiles
# 
# SECURITY NOTE:
# Never hardcode AWS credentials in this file. Always use secure
# authentication methods like IAM roles or environment variables.
# ========================================

provider "aws" {
  region = var.aws_region # AWS region where all resources will be created
}
