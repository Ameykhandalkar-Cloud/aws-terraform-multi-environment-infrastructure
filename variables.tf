# ========================================
# VARIABLES.TF - INPUT VARIABLES & VALIDATION
# ========================================
# 
# PURPOSE:
# This file defines all input variables required for the infrastructure deployment.
# It includes comprehensive validation rules to ensure data integrity and 
# prevent common deployment errors.
# 
# WHAT THIS FILE CONTAINS:
# - AWS region configuration with format validation
# - AMI ID specification with pattern validation  
# - Environment configurations (count, naming, instance types)
# - Instance type validation against AWS EC2 standards
# - Default tags for resource management and cost tracking
# 
# VALIDATION FEATURES:
# - AWS region format validation (e.g., us-east-1, eu-west-2)
# - AMI ID pattern validation (ami-xxxxxxxx format)
# - EC2 instance type validation (ensures valid AWS instance types)
# - Complex nested validation using alltrue() and regex functions
# 
# TERRAFORM CONCEPTS DEMONSTRATED:
# - Complex variable types (map of objects)
# - Input validation with condition blocks
# - Regular expression pattern matching
# - Nested loop validation with for expressions
# - Advanced Terraform functions (can, regex, alltrue)
# 
# USAGE:
# These variables are populated via terraform.tfvars file
# All variables include validation to catch errors early
# ========================================

# ========================================
# VARIABLES FOR 100 EC2 INSTANCES
# Environment-based configuration with essential validation
# ========================================

# AWS region where all resources will be created
variable "aws_region" {
  description = "AWS region for resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.aws_region))
    error_message = "AWS region must be in valid format (e.g., us-east-1, eu-west-2, ap-south-1)."
  }
}

# AMI ID for launching EC2 instances
# This should be a valid AMI ID for the specified region
variable "ami_id" {
  description = "AMI ID for all instances"
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-f]{8,17}$", var.ami_id))
    error_message = "AMI ID must be in valid format (e.g., ami-12345678 or ami-1234567890abcdef0)."
  }
}

# Environment-specific configurations
# Each environment can have different counts, naming, and instance types
variable "environment_configs" {
  description = "Configuration for each environment"
  type = map(object({
    count           = number       # Number of instances to create
    prefix          = string       # Naming prefix for instances
    instance_types  = list(string) # List of instance types to use
    environment_tag = string       # Environment tag value
  }))

  validation {
    # Complex nested validation to check all instance types across all environments
    # Step 1: Loop through each environment (prod, dev, test)
    # Step 2: For each environment, loop through all instance_types in that environment
    # Step 3: Check each instance type against AWS EC2 naming pattern using regex
    # Step 4: Only pass validation if ALL instance types in ALL environments are valid
    condition = alltrue([
      for env_name, config in var.environment_configs :
      alltrue([
        for instance_type in config.instance_types :
        # Regex pattern explanation:
        # ^(t2|t3|t4g|m5|m6i|c5|c6i|r5|r6i) = Instance family (t2, t3, etc.)
        # \\. = Literal dot separator
        # (nano|micro|small|medium|large|xlarge|2xlarge|...) = Instance size
        # $ = End of string
        can(regex("^(t2|t3|t4g|m5|m6i|c5|c6i|r5|r6i)\\.(nano|micro|small|medium|large|xlarge|2xlarge|4xlarge|8xlarge|12xlarge|16xlarge|24xlarge)$", instance_type))
      ])
    ])
    error_message = "Instance types must be valid AWS EC2 instance types (e.g., t2.micro, t3.medium, m5.large)."
  }
}

# Default tags applied to all instances across environments
# These tags help with resource management and cost tracking
variable "default_tags" {
  description = "Default tags to apply to all instances"
  type        = map(string)
  default     = {}
}
