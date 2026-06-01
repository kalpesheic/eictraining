POD is the smallest deployable unit in K8s, each pod wraps one or more containers that that share.
Network(Same IP) Storage and lifecycle(schedule togather)
Every contianer has defined resources request and limt

Request- Defined request resources are mandatory/minimum requirement to run pod, if defined requests resources are not available on schedule node then particular POD will not be scheduled.
Limit- This is limit of resource, it has ensured that mentioned resource limit wouldn't cross limit on particular node, this would be useful so that any particular pod wouldn't use more resources.
Readiness Probe- K8s will periodically make an HTTP get request to this respective endpoints slash health on port 8080, if its get 200 okay response, the pod is marked as ready and can start reciving traffic through.
If healthcheck is ok or getting 200 output mean healthcheck is ok and POD is ready to serve traffic, if healthcheck failed mean POD is not ready to take traffic.



