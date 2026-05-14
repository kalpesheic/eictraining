Stoarage Class- it is a object, how dynamically provosioned storage for application, insted of creating manually, create disk/volumes, kubernetes 
automatically create storage when pod requests it.

| Field                  | Meaning                     |
| ---------------------- | --------------------------- |
| `name`                 | StorageClass name           |
| `provisioner`          | Plugin creating storage     |
| `type: gp3`            | AWS EBS gp3 disk            |
| `fsType`               | Filesystem format           |
| `allowVolumeExpansion` | Resize volume later         |
| `WaitForFirstConsumer` | Create volume in correct AZ |


volumeBindingMode: WaitForFirstConsumer- prevents Multi-AZ scheduling issues with EBS volumes.
Flow becomes:- POD created->Scheduler select nodes->k8s detect AZ-> EBS volume create in same AZ-> Pod start


### which roles and polices are required to create EKS cluster ###########
1. Eks cluster role(Eksclusterrole)-this role will be assume by the EKS control plane
attach- AmazonEKSClusterPolicy and attached trust relationship.
2. Node group IAM role- this role attach to worker nodes 
attached following policies
AmazonEKSworkerNodePolicy - worker nodes join cluster
AmazonEC2containerregisterreadonly- pull docker images
AmazonEKS_CNI_Policy- Networking

3. EBS CSI Drive role- This need for the dynmaic PVC provisioning
policy name- AmazonEBSCISDriverPolicy
Used with IRSA+ OIDC

4. Need to be enabled OIDC provider for the IRSA, CSI Driver, Loadbalancer Controller, ExternalDNS and Autoscaler.


####K8s-Secret###############
K8s by default using base64 encoded, we can keep confidential information in secret and fetch this information through RBAC role.
ConfigMap- Store non-sensitive data
Secret- Store sensitive data securely(Credential, token)
envFrom- Load configmap and secret into pod env
Security- base64encoding + restict through RBAC role.

Types of K8S secrets
opaque-                       Generic secrets
kubernetes.io/tls-            TLS certi
Kubernetes.io/dockerconfijson-         docker registry auth
kubernetes.io/service-account-token-    SA token
Basic Auth-             username and password

############EKS Pod Identity ################
PIA enables pods in our cluster to securely assume IAM roles without static credential or using IRSA annoatation.
EKS POD identity is considered a secure and recommended modern approach for aws access in K8s workload when combined with good secruity practices.

1. Create IAM role- Create role that can be assummed by the new eks service principal.
 A. trust policy can be restricted by cluster ARN or AWS account 
 B. Attach required IAM policy.
2. Create POD Assocaition- it will done via the EKS console or CreatePodIdentityAssociation API.SA
3. Webhook Mutation

Key notes-:
Pods receive temporary IAM credentials automatically — no aws configure needed.
Leverages the standard AWS SDK credential chain (no code changes required).
Requires the EKS Pod Identity Agent Add-on running on worker nodes.
Supported only with newer versions of AWS SDKs and CLI.

Pod identity is the alternative way for the IRSA role, while using IRSA there were few complexcity like create IODC, apporve IODC, attached trust policy 
and access of particular service like s3 or secrent manager or rds that we want to connect from pod.

#####
AWS secret and configuration provider(ASAP)
K8s Sercret Store CSI driver

Helm benefits- 
Reusabilty
versioning
release management(upgrade and rollback)
packaging and sharing
simplified deployment
consistency 
helm repository
