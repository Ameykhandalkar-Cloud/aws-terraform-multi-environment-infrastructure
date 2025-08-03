# ========================================
# OUTPUTS.TF - INFRASTRUCTURE OUTPUT DATA
# ========================================
# 
# PURPOSE:
# This file defines output values that provide useful information about
# the created infrastructure after deployment. These outputs are essential
# for monitoring, automation, and integration with other tools.
# 
# WHAT THIS FILE PROVIDES:
# - Summary statistics of all deployed instances
# - Instance counts by environment (prod, dev, test)
# - Sample instances for quick reference and testing
# - Complete lists of instance IDs for automation scripts
# - Environment-specific instance groupings
# 
# OUTPUT CATEGORIES:
# 1. simple_summary - High-level metrics and counts
# 2. sample_instances - Quick reference instances from each environment
# 3. all_instance_ids - Complete list for bulk operations
# 4. instances_by_env - Environment-specific instance IDs
# 
# TERRAFORM CONCEPTS DEMONSTRATED:
# - Output blocks with descriptions
# - Data aggregation using length() function
# - List concatenation with concat() function
# - Resource reference syntax (aws_instance.resource_name[*].attribute)
# - Clean, readable output structure design
# 

# ========================================
# SIMPLIFIED OUTPUTS - BASIC VERSION
# Clean, easy-to-understand outputs for beginners
# ========================================

# Basic summary of instances
output "simple_summary" {
  description = "Simple summary of all instances"
  value = {
    total_instances = var.environment_configs.prod.count + var.environment_configs.dev.count + var.environment_configs.test.count
    prod_count      = length(aws_instance.prod_servers)
    dev_count       = length(aws_instance.dev_servers)
    test_count      = length(aws_instance.test_servers)
    aws_region      = var.aws_region
  }
}

# All instance IDs in one list
output "all_instance_ids" {
  description = "All instance IDs for automation"
  value = concat(
    aws_instance.prod_servers[*].id,
    aws_instance.dev_servers[*].id,
    aws_instance.test_servers[*].id
  )
}

# Sample instance from each environment
output "sample_instances" {
  description = "One instance from each environment"
  value = {
    prod_sample = aws_instance.prod_servers[0].tags.Name
    dev_sample  = aws_instance.dev_servers[0].tags.Name
    test_sample = aws_instance.test_servers[0].tags.Name
  }
}

# Instance IDs grouped by environment
output "instances_by_env" {
  description = "Instance IDs organized by environment"
  value = {
    production  = aws_instance.prod_servers[*].id
    development = aws_instance.dev_servers[*].id
    testing     = aws_instance.test_servers[*].id
  }
}
