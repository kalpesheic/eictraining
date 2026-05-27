# Observability
1. Traces - Complete path, how long, where and why
2. Metrics - CPU, RAM, Resonse time, error rate-what, when 
3. Logs - What, when

Will use Aws X-Ray for the tracing, will use Amazon manage promotheious and grafana for the metrics, for the logs will use cloudwatch logs.

OTEL collector will send request to exporter 1 and 2 and same would information to observabilty infra( Jagger, prometheus, grafana and Aws x-ray and aws cludwatch)
Whenver new monitoring tool will introduce then no need to change anything at OETL side just need to add one more expoter and add here.
ADOT= Aws distro for open telemetry
It is AWS supported implemention of open telemetry that helps collect application and infra telemetry such as metics, logs and trace from K8s.

ADOT collector deployed via helm/add-on
prometheus metrics scaped 
Data exported to cloudwatch, managed prometheus and X-Ray
This is EKS addons which can collect traces, application matrics 
Collector as deployment will fetch data from the application pods, it would scraps trace/metrics 
and send to collector, once process data and export data to AMP or cloudwatch or ingest traces data to AWS x-ray.

Certmanager is prerequesties for the ADOT addons.
 
# EKS Add-on Kube State Matrics 
It is for the K8S layer, deployment, services, configmap etc.
Node Exporter is a infra layer, which is monitor CPU, RAM, Disk at node level, node exporter is deamonset 

first create service account and create cluster role and that cluster role has required access(app resources, extension resources, matrics endpoints)

# Kubernetes Cluster Role Binding
role name is "otel-collector-cluster-role-binding" which is bind with SA and rbac role.

resource "kubernetes_cluster_role_binding_v1" "otel_collector" {
  metadata {
    name = "otel-collector-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.otel_collector.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.adot_collector.metadata[0].name
    namespace = kubernetes_service_account_v1.adot_collector.metadata[0].namespace
  }
}

4 processors 
A. Memory limiter(to prevent OOM)
B. Filter: filter out healthcheck traces
C. K8s attribute processor 
D. Batch Processor 
