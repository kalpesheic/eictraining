POD is the smallest deployable unit in K8s, each pod wraps one or more containers that that share.
Network(Same IP) Storage and lifecycle(schedule togather)
Every contianer has defined resources request and limt
Request- Defined request resources are mandatory/minimum requirement to run pod, if defined requests resources are not available on schedule node then particular POD will not be scheduled.

