Allow mysql from EKS cluster security group(data.terraform_remote_state.eks.outputs.eks_cluster_security_group_id)
DB subnet group will be created as new DB will be created in private subnet.
Accessing catalog pod to RDS, we need following information in place.
A. IAM policy
B. IAM role
C. EKS PIA Assocation 
D. Service Account

first need IAM role that should have trust policy for the assuming role
assume_role_policy = data.aws_iam_policy_document.assume_role.json
Attach policy should have access to read credential from Secret manager.
# Attach IAM Policy to Role
 policy_arn = aws_iam_policy.retailstore_db_secret_policy.arn  # this is comming for secretfile

 Catalog pod-> Secret Store CSI-> ASCP->AWS Secret Manager

 for the accessing Catalog pod to RDS, it will first get credential from SSCSI(Secret Store CSI) and access RDS.
 


