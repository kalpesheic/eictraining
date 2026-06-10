
K8s automatically keeps key, keeps secrets in base64 encoded format.

### which roles and polices are required to create EKS cluster ###########
1. Eks cluster role(Eksclusterrole)-this role will be assume by the EKS control plane
attach- AmazonEKSClusterPolicy and attached trust relationship.

2. Node group IAM role- this role attach to worker nodes attached following policies
A. AmazonEKSworkerNodePolicy - worker nodes join cluster
B. AmazonEC2containerregisterreadonly- pull docker images
C. AmazonEKS_CNI_Policy- Networking

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

Pod identity is the alternative way for the IRSA role, while using IRSA there were few complexcity like create IODC, apporve IODC.

POC- will try to access S3 bucket from the POD which is schedueld in EKS cluster.
1. Need to create IAM role, that role has attached policy which should have read only permission to access S3.
2. deploy PIA POD in EKS cluster, this is deamonset, mean evey worker nodes has PIA, PIA is avaialble as a Addon in cluster.
3. Create Service account(SA) which will be associated with POD/Deployment.
4. create POD identity assocation in EKS cluster, PIA assocation required above 3 things should be in place(IAM role, S3 readonly permission and SA and namespace)

StoarageClass- it is a object, how dynamically provosioned storage for application, insted of creating manually, create disk/volumes, kubernetes 
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


#####
By default K8s storing secret in base-64, if somebody has admin access of K8s cluster can access easily, for the better security, we can store all sensitive information in AWS secret manager, for the accessing aws secret manager from the K8S.
we would required
A. AWS secret and configuration provider(ASCP)
B. K8s Sercret Store CSI driver
both run in deamonset, they are responsible to fetching Serect from AWS serect manager and mouting them in to K8s pods. 
PIA authenticates the POD with AWS IAM without any credential in EKS cluster then the secret store CSI driver and ASCP use that IAM role to securely fetch the credential from the secret manager.
whatever it has fetched will get mounted inside the POD.

 K8s Sercret Store CSI driver- it is K8s native service which is call it as CSI plugin that allows your PODs to mount serect and certificate store outside K8s. 
 it will get secret from AWS Secret manager, that part is done by ASCP and mount secret and certificate will be taking care by CSI driver.
 CSI driver will be stored as a deamonset.

####
Each cloud provider has own CSI driver, in AWS has AWS CSI driver which provison storage and mount EBS volumes to our K8s Pods
PVC- it is template which requests the storage
PV- Actual storage resource provisioned in the EKS cluster
SC= how storage created, it should be aws ebs volume with GP2 volume or GP3 volume

EBS CSI Driver- lets assume that Cluster admin has installed amazon ebs csi drver and configured storage, CSI drver know that, how to communicate with AWS API and dynamically 
create the EBS volumes, it has 3 pices which is seating on kube-system 
1. EBS CSI Node- it is deamonset, runs on evey node, mount and unmount volumes
2. EBS CSI Controller- it handel provisioing and attach and dettached volumes.
3. EBS-CSI-Controller-SA- used to authenticate through PIA with AWS api, once authentication is completed, allow to provision storage.


Helm benefits- 
Reusabilty
versioning
release management(upgrade and rollback)
packaging and sharing
simplified deployment
consistency 
helm repository
