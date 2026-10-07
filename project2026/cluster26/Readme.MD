SQS + KEDA on Amazon EKS — POC Summary Report

Objective
The objective of this POC was to implement event-driven autoscaling on Amazon EKS using KEDA and Amazon SQS.
The POC demonstrates that:
•	Amazon SQS acts as the event source.
•	KEDA monitors the SQS queue.
•	KEDA exposes the queue metric to Kubernetes HPA.
•	HPA automatically increases/decreases the number of sqs-worker pods based on queue depth.
•	AWS authentication is configured using a Kubernetes Secret and KEDA Trigger Authentication.

                
 AWS Cloud
                       │
                       ▼
              ┌─────────────────┐
              │   Amazon SQS    │
              │  keda-demo-queue│
              └────────┬────────┘
                       │
                 Queue Messages
                       │
                       ▼
              ┌─────────────────┐
              │      KEDA       │
              │  SQS Scaler     │
              └────────┬────────┘
                       │
                External Metric
                       │
                       ▼
              ┌─────────────────┐
              │ Kubernetes HPA  │
              └────────┬────────┘
                       │
                Scale 1 → 10
                       │
                       ▼
              ┌─────────────────┐
              │ EKS Deployment  │
              │   sqs-worker    │
              └────────┬────────┘
                       │
                ┌──────┼──────┐
                ▼      ▼      ▼
              Pod    Pod    Pod ...


Kubernetes Resources
The following resources were created:
Namespace
   │
   ├── Secret
   │     └── aws-credentials
   │
   ├── TriggerAuthentication
   │     └── aws-credentials
   │
   ├── Deployment
   │     └── sqs-worker
   │
   └── ScaledObject
         └── sqs-worker-scaler


KEDA automatically creates/manages an HPA associated with the ScaledObject.

SQS Configuration
Queue name- keda-demo-queue
Region- ap-south-1
Queue url- https://sqs.ap-south-1.amazonaws.com/454143665149/keda-demo-queue
KEDA Configuration
The final ScaledObject configuration was
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: sqs-worker-scaler
  namespace: keda-demo
spec:
  cooldownPeriod: 30
  maxReplicaCount: 10
  minReplicaCount: 1
  pollingInterval: 15

  scaleTargetRef:
    name: sqs-worker

  triggers:
  - type: aws-sqs-queue
    authenticationRef:
      name: aws-credentials
    metadata:
      awsRegion: ap-south-1
      queueLength: "5"
      queueURL: https://sqs.ap-south-1.amazonaws.com/454143665149/keda-demo-queue


AWS Authentication
A Kubernetes Secret was created containing
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
KEDA accesses these credentials through
TriggerAuthentication
        │
        ▼
aws-credentials Secret
        │
        ▼
KEDA SQS Scaler

The final TriggerAuthentication
apiVersion: keda.sh/v1alpha1
kind: TriggerAuthentication
metadata:
  name: aws-credentials
  namespace: keda-demo
spec:
  secretTargetRef:
  - parameter: awsAccessKeyID
    name: aws-credentials
    key: AWS_ACCESS_KEY_ID

  - parameter: awsSecretAccessKey
    name: aws-credentials
    key: AWS_SECRET_ACCESS_KEY

Important troubleshooting lesson
Initially the key fields contained Base64-encoded credential values instead of the Kubernetes Secret key names.
Incorrect: key: <Base64 encoded value>
Correct: key: AWS_ACCESS_KEY_ID and key: AWS_SECRET_ACCESS_KEY
This was causing error 
error parsing SQS queue metadata: awsAccessKeyID not found
After correcting the TriggerAuthentication, KEDA successfully became
READY=True
Testing Procedure
Step 1 — Verify KEDA
kubectl get pods -n keda
Expected KEDA components
keda-operator
keda-admission-webhooks
keda-operator-metrics-apiserver
Verify ScaledObject
kubectl get scaledobject -n keda-demo
Expected: READY=True
Verify HPA
kubectl get hpa -n keda-demo




KEDA creates an HPA for the sqs-worker Deployment
Send test messages-: 20 messages were sent to SQS

QUEUE_URL="https://sqs.ap-south-1.amazonaws.com/454143665149/keda-demo-queue"

for i in $(seq 1 20); do
  aws sqs send-message \
    --queue-url "$QUEUE_URL" \
    --message-body "KEDA test message $i" \
    --region ap-south-1
Done

Step 5 — Monitor scaling
kubectl get pods -n keda-demo -w
kubectl get hpa -n keda-demo -w
kubectl get scaledobject sqs-worker-scaler -n keda-demo -w

Test Result
POC Status: SUCCESSFUL ✅
SQS messages
     ↓
Queue depth increases
     ↓
KEDA detects SQS metric
     ↓
KEDA provides external metric
     ↓
HPA calculates desired replicas
     ↓
EKS Deployment scales out
     ↓
Queue is cleared
     ↓
KEDA/HPA scales back toward minimum replicas
The configured scaling boundaries were
Minimum replicas = 1
Maximum replicas = 10
10. Scale-Down Test
After testing, the queue can be emptied using
aws sqs purge-queue \
  --queue-url "$QUEUE_URL" \
  --region ap-south-1

Because the POC configured
minReplicaCount: 1
cooldownPeriod: 30
the workload can eventually scale back toward
1 replica

Key Learnings
•	KEDA is an event-driven autoscaler, not just a CPU/memory-based autoscaler.
•	KEDA can monitor AWS services such as SQS and expose metrics to Kubernetes HPA.
•	TriggerAuthentication is used to provide authentication information to KEDA scalers.
•	Secret.key must contain the Secret key name, not the Base64-encoded secret value.
•	READY=True on the ScaledObject is an important indicator that KEDA successfully initialized the scaler.
•	HPA can be automatically created and managed by KEDA.
•	minReplicaCount and maxReplicaCount control the scaling boundaries.
•	cooldownPeriod controls how long KEDA waits before scaling down after the trigger becomes inactive.
Production Recommendations
The POC used AWS access keys for simplicity. For production, do not store long-lived AWS access keys in Kubernetes Secrets.

