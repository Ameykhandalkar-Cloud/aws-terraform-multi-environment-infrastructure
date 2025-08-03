# ========================================
# MAIN.TF - CORE INFRASTRUCTURE RESOURCES
# ========================================
# 
# PURPOSE:
# This file contains the primary infrastructure resources for creating
# 100 EC2 instances distributed across three environments (prod, dev, test).
# 
# WHAT THIS FILE DOES:
# - Creates 40 production instances with performance-focused instance types
# - Creates 35 development instances with cost-balanced instance types  
# - Creates 25 testing instances with cost-optimized instance types
# - Implements intelligent instance type distribution using conditional logic
# - Applies comprehensive tagging strategy for resource management
# 
# TERRAFORM CONCEPTS DEMONSTRATED:
# - Resource blocks with count parameter
# - Conditional expressions for instance type allocation
# - Dynamic naming with format() function
# - Tag merging with merge() function
# - Modulo operations for cycling through instance types
# 

# ========================================
# PRODUCTION INSTANCES
# Creates production servers with higher-performance instance types
# First half: t3.medium, Second half: t3.large
# ========================================

resource "aws_instance" "prod_servers" {
  # Count from terraform.tfvars (default: 40)
  count = var.environment_configs.prod.count

  # AMI and instance type configuration
  ami = var.ami_id
  # Conditional instance type: first half get t3.medium, second half get t3.large
  instance_type = count.index < (var.environment_configs.prod.count / 2) ? var.environment_configs.prod.instance_types[0] : var.environment_configs.prod.instance_types[1]

  # Tags: Combination of default tags + environment-specific tags
  tags = merge(var.default_tags, {
    Name        = "${var.environment_configs.prod.prefix}-${format("%02d", count.index + 1)}"
    Environment = var.environment_configs.prod.environment_tag
    Type        = count.index < (var.environment_configs.prod.count / 2) ? var.environment_configs.prod.instance_types[0] : var.environment_configs.prod.instance_types[1]
  })
}

# ========================================
# DEVELOPMENT INSTANCES
# Creates development servers with cost-effective instance types
# Alternates between t2.micro and t2.small
# ========================================

resource "aws_instance" "dev_servers" {
  # Count from terraform.tfvars (default: 35)
  count = var.environment_configs.dev.count

  # AMI and instance type configuration
  ami = var.ami_id
  # Cycles through instance types: t2.micro, t2.small, t2.micro, t2.small...
  instance_type = var.environment_configs.dev.instance_types[count.index % length(var.environment_configs.dev.instance_types)]

  # Tags: Combination of default tags + environment-specific tags
  tags = merge(var.default_tags, {
    Name        = "${var.environment_configs.dev.prefix}-${format("%02d", count.index + 1)}"
    Environment = var.environment_configs.dev.environment_tag
    Type        = var.environment_configs.dev.instance_types[count.index % length(var.environment_configs.dev.instance_types)]
  })
}

# ========================================
# TEST INSTANCES
# Creates testing servers with minimal instance types
# All instances use t2.micro for cost optimization
# ========================================

resource "aws_instance" "test_servers" {
  # Count from terraform.tfvars (default: 25)
  count = var.environment_configs.test.count

  # AMI and instance type configuration
  ami = var.ami_id
  # All test instances use the same instance type (t2.micro)
  instance_type = var.environment_configs.test.instance_types[0]

  # Tags: Combination of default tags + environment-specific tags
  tags = merge(var.default_tags, {
    Name        = "${var.environment_configs.test.prefix}-${format("%02d", count.index + 1)}"
    Environment = var.environment_configs.test.environment_tag
    Type        = var.environment_configs.test.instance_types[0]
  })
}
