The Kubernetes project recommends using Gateway instead of Ingress. The Ingress API has been frozen

Service type- ingress- will create ALB
Service type- load balancer- will create NLB

Ingress- path based routring, hostbase routing and header base routing.

AWS load balancer controller- will be deployed in kube-system namespace.


1 download policy from(https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json)
this json file(AWSLoadBalancerControllerIAMPolicy) has all required permission.

2. Create IAM role and attach the AWSLoadBalancerControllerIAMPolicy to that role and trust policy.
(This policy allows the load balancer controller to manage aws resources such ELB, targer group and security groups)

3.  Create Trust Policy-Trust policy allows the EKS POD identity agent(PIA) to assume this role on behalf of the load balancer controller pod.
 
4. EKS Pod Identity Association between the IAM Role and ServiceAccount-this sercurly link Service account to the IAM role via EKS POD identity.

######################################
Ingress is a Kubernetes API object used to expose HTTP/HTTPS applications externally using:

host-based routing
path-based routing
TLS termination

Ingress Controller-Ingress resource only contains routing rules but Ingress Controller is the actual component that watches ingress manifests, creates load balancer configurations and routes traffic

alb.ingress.kubernetes.io/target-type: ip ==== ALB directly forwards traffic to POD IPs
it is avoid use of NodePort, better performance and direct pod routing.

Target type- IP- Directly targetting to the POD IP, No nodeport hope involved, in that case will get good performance.
Will use AWS VPC CNI Plugin for this, it is available as a add-on.

![alt text](image.png)

aws-node pods are running as a daemonset which is related to AWS VPC-CNI 

user-> ALB-> target group(IP mode)-> POD 

inside pod, 
routes directly to pod 
required VPC CNI
better for EKS 

Target type- Instance mode-
ALB send traffic to Node port and node port forward requests to the correct pod- traffic send to worker node and from there requests send to the POD.

User-> ALB->targer group(mode instane)-> NodePort->POD 

route to worker node
use NodePort
older approch

Traffic flow in ALB ingress
User-> route52-> ALB-> Ingress rules-> Service-> Pod

What is ingressClassName- It tells K8S which ingress controller should handle this ingress resource.
Because a cluster can have multiple ingress controllers, NGINX Ingress Controller or Amazon Web Services AWS Load Balancer Controller


type: NodePort
  ports:
    - port: 80
      targetPort: http
      protocol: TCP 
      name: http

As per the above block, where clusterIP comes into picture
when traffic reaches NodeIP:31555, kubeprxy applies iptables/IPVS rules
315555->cluster IP
Then ClusterIP service load balances traffic to pods.


NodePort itself does NOT directly know pods.
ClusterIP service knows:
endpoints
pod IPs
load balancing
That is why traffic must pass through ClusterIP layer
