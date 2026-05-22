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

 # SecretProviderClass

 it is used to connect K8s pods with external secret manager.
 
 It is K8s custom resource used by the secret store CSI driver to fetch secrets from the external secret manager like
 1. Aws Secret Manager
 2. Aws parameter Store
 3. Azure Key Vault
 4. HashiCorp Vault
5. Google Secret Manager
Pod
  ↓
CSI Driver
  ↓
AWS Provider
  ↓
AWS Secrets Manager / SSM Parameter Store

1. Whenever catalog pod get started, it will get the secret from the aws aws secret manager via secret store CSI driver, ASCP and PIA, it will mount to the below location in catalog pod.

" - name: aws-secrets
              mountPath: /mnt/secrets-store
              readOnly: true         
"
2. Create secret(catalog-db), once this secret is created, pod will be refernce in eve variable and expose to the internal application, after that Catalog pod will be able to connect with RDS.
 " - secretRef:
                name: catalog-db
"
01_secretproviderclass/
├── 01_catalog_db_secretproviderclass.yaml
└── 02_orders_db_secretproviderclass.yaml

Above manifest ensure that 
1. Secret Store CSI driver fetches credential from AWS Secret Manager
2. They are automatically synced to a native kubernetes secret
3. Pods mount these secret directly as environment variables.

secretObjects only works when-:
pod mounts CSI volume
pod starts successfully

 # Mount the CSI secrets volume - this will trigger secret creation              
            - name: aws-secrets
              mountPath: /mnt/secrets-store
              readOnly: true

  # Add the CSI secrets volume            
        - name: aws-secrets
          csi:
            driver: secrets-store.csi.k8s.io         


