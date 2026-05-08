Created VPC using Terraform step by step.

Terraform Block
Provider Block
Input Variables
Local Values
Data Sources
Resource Blocks
Outputs
State files (local)

Created terraform manifeasts files to understand functions

azs = slice(data.aws_availability_zones.available.names, 0, 3)

This is a Terraform data source, it fetches available Availability Zones (AZs) in your AWS region
Extracts only the names of AZs, Output is a list
slice(list, start, end)-Terraform function to get part of a list
Start from first element-0 and end index is 3
["ap-south-1a", "ap-south-1b", "ap-south-1c"]

tags = merge(var.tags, { Name = "${var.environment_name}-vpc" })

Assigns tags to an AWS resource (like VPC, EC2, etc.)
Terraform function to combine multiple maps
A variable (map) defined in your Terraform
Usually contains common tags
A map with a single key-value pair


