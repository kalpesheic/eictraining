
####Kubernetes StatefulSet ##########################

Current deployment stategy is not suitable for the mysql database as deployment will schedule pods dynamically.
Deployment will work only for the stateless applications
statefulset will work only for the statefull applications, all database are stateful applications.

StatefulSet
All required pods will be created sequently( first create master DB pod then Slave DB pod)
Whenever any pod got crash, will get same name while creating and deleting.

Why not using K8s cluster IP for the stateful applications.

#####Headless Service###############
headless servcice will not do any load balancing like clusterIP service.
it create dns at pod level example-(podname.headless-service.namespace.svc.cluster-domain.example)

#####
####Scale Up – Ordered Pod Creation#############
kubectl scale statefulset catalog-mysql --replicas=2
kubectl get pods -w
Observe that Pods start sequentially

#########Scale Down – Reverse Order Deletion

kubectl scale statefulset catalog-mysql --replicas=1
kubectl get pods -w

Observe reverse deletion

Delete Pod and Verify Identity
kubectl delete pod catalog-mysql-0
kubectl get pods
Restart Catalog App
kubectl rollout restart deploy/catalog

Mysql database pod uses an emptyDir volume, data stored inside the pod is ephemeral( it exists only for the pod's lifetime)
MySQL StatefulSet to multiple replicas only creates independent MySQL servers. Kubernetes does not configure replication automatically

StatefulSet = identity + storage + ordering
Deployment = stateless scaling + rollout
ConfigMap = configuration injection (not runtime management system)



 
 

 
MySQL startup logs like the above, it confirms that the Catalog microservice is successfully pointing to the MySQL database Pod

Verify Database Connection Inside Cluster
 
Mysql database pod uses an emptyDir volume, data stored inside the pod is ephemeral( it exists only for the pod's lifetime)
MySQL StatefulSet to multiple replicas only creates independent MySQL servers. Kubernetes does not configure replication automatically

StatefulSet = identity + storage + ordering
Deployment = stateless scaling + rollout
ConfigMap = configuration injection (not runtime management system)

labels-it has been used by Pod, deployments and nodes
Selector- service and replicaset.

#####QA###
In a Kubernetes StatefulSet, EKS with Multi-AZ enabled, what happens depends mainly on the storage type and volume binding behavior.

Most Statefulsets will use prersistentVolumeClaim and backend by EBS(Gp2/Gp3)
via ebs.csi.aws.com
if pod is rescheduling in same AZ, it will work properly, if this pod schedule on different AZ, this pod will be reamin in pending state as ebs volume
is not avaialble.
we may get error volume node affinity conflict or multi-attach error.

##Why this happen automatically
if we use 
volumeBindingMode: WaitForFirstConsumer
K8s creates the volume in the same AZ as the selected node and remembers node affinity, scheduler then tries to place future pod restart in the same AZ.
So normally-:
StatefulSet pod
PVC
EBS volume
node scheduling 
###
Best approch ###
Use node groups across all AZs
Use topology-aware scheduling-
Example-StorageClass
volumeBindingMode: WaitForFirstConsumer
Use PodAntiAffinity
To distribute replicas across AZs
topologyKey: topology.kubernetes.io/zone

####Best Practice for StatefulSets on EKS###
Use WaitForFirstConsumer
Maintain worker nodes in every AZ
Use StatefulSet with stable PVCs
Prefer EFS for shared RWX workloads
Use EBS for database workloads needing high IOPS and single-writer semantics
