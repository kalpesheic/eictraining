# helm rollback ui 
rolls back to the last successfully release 

# helm rollback ui 1 --dry-run
preview rollback without applying.

# rollback to previous release
helm history ui

# Verify rollback
helm list
helm history ui
kubectl get pods -w


helm rollback ui → rolls back to the last successful release.
helm rollback ui 1 --dry-run → preview rollback without applying.

Pods may not restart automatically because ConfigMap/env changes don’t always trigger a rollout. If that happens, restart the Deployment manually.


Uninstall Retail UI Release
# List Helm releases
helm ls
# Uninstall the 'ui' release
helm uninstall ui

# This gives a nice summary of resources created by the release.
helm status ui --show-resources

# After install/upgrade, see effective values
helm get values ui --all

# Shows all Kubernetes manifests (raw YAML) rendered and applied by Helm:
helm get manifest ui

# Pods created by the release
kubectl get pods

# Services (expect ClusterIP for internal communication)
kubectl get svc

# Ingress (ALB will be created by the controller)
kubectl get ingress

# Describe the Ingress to view ALB details and events
kubectl describe ingress ui

 # Lint & Render
 Lint is the command which help to validate syntex and ensure that required values are in place.
 helm lint ui

 # Lint the chart templates
helm lint ui

 # Render the chart locally (defaults)
helm template ui ./ui | less

# Render with your custom values (adjust path if your repo differs)
helm template ui ./ui -f ../retailstore-apps/values-ui.yaml | less

# With custom values + extra debug
helm template ui ./ui -f ../retailstore-apps/values-ui.yaml --debug | less

# helm chart
package of K8s manifests
resuable application template
parameterized deployment

# helm release 
deployed chart instance 
version-controlled deployment state
helm list and helm history

# differnce between helm install and helm upgrade
install new deployment
modify existing release

# helm depedency
Manage subcharts
resusable components

# helm template
local rendering, dubug manifests, before deploying we could see how files would be look like, here
no cluster interaction.

helm template mychart

# helm init
validate chart syntex, catches template issues.

# what happens  if helm upgrade fail
it may chance, resources may updates partially
helm upgrade --atomic
--atomic-> automatic rollback on failure
# production best practices for helm

Seperate value per env
avoid hardcoded configs
use linting
use atomic upgrades
version chart properly 
avoid secret exposure

