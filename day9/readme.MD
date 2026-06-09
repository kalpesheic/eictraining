Persistent Volume Claim-(PVC) is a request for storage made by an application in Kubernetes.

Applications do not directly consume storage volumes. Instead, they create a PVC requesting

Example:

Request 10Gi storage using gp2 StorageClass.

###PVC is a namespace-scoped resource#####

Persistent Volume (PV)

A Persistent Volume is the actual storage resource provisioned inside the Kubernetes cluster.

It represents the real underlying storage such as:
AWS EBS volume
NFS share
Azure Disk
GCP Persistent Disk

PV and storageclass are a cluster-scoped resource.
A StorageClass enables dynamic storage provisioning in Kubernetes.

Example responsibilities of StorageClass:
volume type
filesystem type
reclaim policy
encryption settings
AWS EBS CSI Driver- Amazon EBS CSI Driver knows how to communicate with AWS and dynamically create EBS volumes for Kubernetes workloads.

####The EBS CSI Driver mainly consists of:####
EBS CSI Controller
EBS CSI Node Plugin
ebs-csi-controller-sa Service Account

Components of AWS EBS CSI Driver
1. EBS CSI Controller-The EBS CSI Controller runs as a Kubernetes Deployment.

Responsibilities:
provision EBS volumes
attach volumes
detach volumes

communicate with AWS EBS APIs, It handles dynamic provisioning requests coming from PVCs.

2. EBS CSI Node Plugin-The EBS CSI Node Plugin runs as a DaemonSet on every worker node.

Responsibilities:

mount EBS volumes
unmount EBS volumes
make volumes available to Pods

Once a volume is attached to the node, the node plugin mounts it to the Pod filesystem.

3. ebs-csi-controller-sa=it is the Kubernetes Service Account used by the EBS CSI Controller.

It authenticates with AWS using EKS Pod Identity or IAM Roles for Service Accounts (IRSA). after authentication, it can call AWS EBS APIs securely.Authentication Flow with EKS Pod Identity

The EBS CSI Controller does not store hard-coded AWS credentials.

Instead:
it uses EKS Pod Identity
Pod Identity Agent runs as a DaemonSet in the kube-system namespace
the agent communicates with AWS IAM

The Pod Identity Association maps:
Kubernetes Service Account
IAM Role
EBS CSI Controller

The IAM Role attached to the association has permissions such as:
create EBS volumes
delete EBS volumes
attach volumes
detach volumes

When the EBS CSI Controller needs to communicate with AWS:

Pod Identity Agent authenticates
IAM Role is assumed
temporary credentials are provided
AWS EBS API is called securely

***Dynamic Provisioning Workflow Step-by-Step Flow
When PVC request for the storage through storageclass, ebs csi controller will come in action, it calls AWS EBS API to using IAM role and dynamically create ebs storage.
this ebs volume will be created wherre POD is scheduled in worker nodes, worker nodes in same AZ.

K8S Bound PV and PVC accrdingly, this all thigns happend automatically

Once EBS volume is created, now ebs-csi-node which is running as a deaemonset, which is attached the volume and mount to the pod file system.

Volume claim template- in statefulset, each pod would be unique and need individal storage, volume template is useful to create new PV for the each statefulset


All these operations happen automatically.

StatefulSet and VolumeClaimTemplate
each Pod has a unique identity
each Pod requires dedicated persistent storage

volumeClaimTemplates are used to dynamically create separate PVCs and PVs for each StatefulSet Pod.

Example:

mysql-0 gets one volume
mysql-1 gets another volume
mysql-2 gets another volume

This ensures data isolation and persistence for stateful applications.
