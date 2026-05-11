
#### K8S Deployment################

Ensures the desired number of Pods are always running
Automatically replaces unhealthy Pods via its ReplicaSet
Supports rolling updates for version upgrades
Allows easy rollback to previous versions
Provides horizontal scaling with a single command

Flow: Deployment → manages → ReplicaSet → creates → Pods
Readiness Probe-If it fails, Pod is temporarily removed from Service endpoints
Liveness Probe-	If it fails repeatedly, kubelet restarts the container

RollingUpdate → replaces Pods gradually without downtime
maxUnavailable: 1 → ensures at most one Pod is down during rollout

runAsNonRoot: true-	Runs container as non-root user
readOnlyRootFilesystem: true-Prevents writes to filesystem
capabilities.drop: [ALL]-	Removes unnecessary Linux capabilities

Verify Deployment, ReplicaSet
kubectl get deployment
kubectl get replicaset
kubectl get pods -o wide

Scaling the Deployment
kubectl scale deployment catalog --replicas=3

Update the Deployment image
# List Deployment Revisions
kubectl rollout history deployment/catalog
# Update the Deployment
kubectl set image deployment/catalog catalog=public.ecr.aws/aws-containers/retail-store-sample-catalog:1.3.0
# List Deployment Revisions
kubectl rollout history deployment/catalog

Verify rollout status
kubectl rollout status deployment/catalog

# Rollback to previous version
kubectl rollout undo deployment/catalog
# List Deployment Revisions
kubectl rollout history deployment/catalog


##### K8S Service ##############

After creating the service, verify how Kubernetes automatically links Pods to the Service using labels.
kubectl get pods -o wide
kubectl get endpointslices -l kubernetes.io/service-name=catalog-service

Kubernetes uses the selector labels in the Service definition to automatically discover Pods that match those labels. It then creates an EndpointSlice object listing the Pod IPs and ports that belong to that Service.
####Kubernetes ConfigMap############
ConfigMaps help externalize configuration from the container image.
We defined all environment variables explicitly, even defaults.
Deployment consumed ConfigMap via envFrom.
Verified that environment variables were successfully injected into the container.