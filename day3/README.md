-var-file is one of the highest-precedence sources, second only to -var defined direcly on the command line
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

1. list- A list is an ordered collection of values.
2. Map- A map store key and value pairs
3. Object- object is a structured map with defined attributes
4. Set- A set is a like a list but contains unique values
5. tuple- Like a list can contain different data types
6. merge- combine multiple maps
7. concat- comibine of list
8. flattern()- Convert nested list into a single list.
9. lookup()-retrive value from a map safely.
10. keys()- get map keys
11. values()- get map values
12. length()- count element
13. to(set)- remove duplicate
14. tolist()- convert list
15. join()- list->string
16. spilit()- string->list
17. try()- handel missing attributes safely.

