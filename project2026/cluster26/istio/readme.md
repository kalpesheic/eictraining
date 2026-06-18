# Istio
Istio is useful for the traffic managment specailly east-west traffic, east-west traffic mean internal traffic management of K8s cluster internally.
Traffic comes from the end user to K8s, which is called North-South traffic.

# Why need Istio
Istio enhance capabilities of service to serivce communication such as mutual TLS(MTLS), without ISTIO internal service are talking without tls, isto add mutual Istio.
Using Istio, we can plan deployment startegy like, canary or blue-green deployment.
Istio helps for the observabilites, it comes with kiali
kiali track service to service communication, it help to understand behaviour of services with matrix, no need to install additional obseravibilites tool.
# how Istio works
Isto is inject new container in all pods, which is next to the real container, in this new container is called side-car container, each side-car container has envoy proxy which is managed all in-bound and outbound traffic to particular pod, any request is comming to the main container will be routed through only side-car container.
This side-car is responsible for the MTLS and deployment startgies(canary deployment etc), circuit building and obserability
Admission Controller-  Whenever user request for the new pod creation, this request goes to API server, API server has multiple components, API server will autorized and authenticate request and store objects in ETCD, admission controller intercept request between API server and ETCD, it will modify or validate requests.
Arround 30 Plus admission controller are avaialble in K8s, it is precompiled with API server
Admission controller knows as a admission webhooks which will be used by many components
A. istio- inject istio-proxy sidecar
B. Aws load balancer controller- validate Ingress and Targetgroupbinding
C. Cert Manager- Validate and Default Cetificate resources
D. Gatekeeper(OPA)- Policy Validation
E. Argo CD

# Dynamic Admission Controller

Istio should add side-car contianer, isto should now that when POD cretion request created, somehow API server should notify to Istio that now you can procced with side-car injection, that concept call is dynamic admission controller, dynamic admission controller wouldn't mutated( manipulate) or change, it would forward requst to ISTIOD (admission webhook)



Steps to download and sample application
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.30.1
export PATH=$PWD/bin:$PATH
Deploy your application
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl get pods
Now that the Bookinfo services are up and running, you need to make the application accessible from outside of your Kubernetes cluster

Create an Istio Gateway using the following command
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
gateway.networking.istio.io/bookinfo-gateway created
virtualservice.networking.istio.io/bookinfo created

Need to make port forwarding to open outside of cluster.
Set GATEWAY_URL
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

Traffic shifting- Canary deployment
Need to run below yaml
https://github.com/iam-veeramalla/istio-guide/blob/main/traffic-management/traffic-shifting/01-old-version.yaml

Istio uses subsets, in destination rules, to define versions of a service. Run the following command to create default destination rules for the Bookinfo services:

kubectl apply -f samples/bookinfo/networking/destination-rule-all.yaml

Display the destination rules with the following command
kubectl get destinationrules -o yaml

# Traffic Shifting
https://github.com/iam-veeramalla/istio-guide/blob/main/traffic-management/traffic-shifting/02-traffic-shifting.yaml















