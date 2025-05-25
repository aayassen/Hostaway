# DevOps Engineer Task - Hostaway

Welcome! This exercise will assess your practical DevOps skills. Please follow the instructions below. **All components must run locally—no hosted/cloud solutions.**

---

## Task Overview

1. Set up a local Kubernetes cluster using Minikube.
2. Use Terraform to provision the cluster with separate namespaces for internal vs external applications and any different environments.
3. Install ArgoCD on the cluster using Helm.
4. Demonstrate GitOps workflows with ArgoCD:

- Deploy a simple Nginx app with output "hello it's me"
- We should be able to deploy a new version to staging, promote it to production, rollback to any version.

5. Define key monitoring metrics and thresholds (can be in README). For each, specify:

- What to monitor.
- The threshold for alerting.
- Why it’s important.

## Deliverables

- All code (Terraform, Helm charts, manifests, app code) in a GitHub repository.
- A `README.md` with:
  - Setup instructions (including prerequisites). Should be a 1 command install and run.
  - How to use ArgoCD for deployments, promotions, and rollbacks.
  - Defined monitors and thresholds.

## Notes

- **Do not use any managed/cloud services.** Everything must run locally.
- If you encounter issues, document your troubleshooting steps.

Good luck! If you have any questions, please reach out by email.

## Solution

In this solution I have initialized a local minikube cluster with a single node and ingress addons

### Prerequisites

1. for Minikube setup we will need minikube cli ready and docker as it's used as a minikube driver.
2. open-tofu for infrastructure as a code.
3. kubectl cli ready for the interaction with the local cluster.
4. docker client to build and push the images inside minikube cluster

### Steps

1. run the start.sh script and check if any error messages are showing.

```bash
./start.sh
```

2. port-forward to argocd and you should find that the applications are created.


### monitoring

#### 1. HTTP Request Success Rate
***What to Monitor:***  
The percentage of HTTP requests to the Nginx application that return a 2xx (success) status code.

***Threshold for Alerting:*** 
Alert if the success rate falls below 99% over a 5-minute period.

***Why It’s Important:*** 
A low success rate indicates potential issues with the application, such as misconfigurations, server errors, or issues with the backend services it proxies. Maintaining a high success rate ensures users experience reliable access to the application.

#### 2. HTTP Error Rate (4xx/5xx)
***What to Monitor:*** 
The rate of HTTP requests returning 4xx (client errors) or 5xx (server errors) status codes.

***Threshold for Alerting:*** 
Alert if the error rate exceeds 1% of total requests over a 5-minute period.

***Why It’s Important:***
High error rates can indicate client-side issues (e.g., bad requests) or server-side problems (e.g., application bugs, resource exhaustion). Monitoring this helps identify and resolve issues that degrade user experience or signal infrastructure problems.

#### 3. Request Latency
***What to Monitor:*** 
The latency of HTTP requests, measured as the 95th percentile (p95) response time.

***Threshold for Alerting:*** 
Alert if p95 latency exceeds 500ms over a 5-minute period.

***Why It’s Important:*** 
High latency can degrade user experience, indicating potential bottlenecks in the application, network, or Kubernetes infrastructure. Monitoring latency ensures the application remains responsive.

#### 4. Pod Health (CrashLoopBackOff or Unhealthy Pods)

***What to Monitor:*** 
The status of Nginx pods, specifically detecting pods in CrashLoopBackOff or not in a "Ready" state.

***Threshold for Alerting:***
Alert if any pod is in CrashLoopBackOff or not ready for more than 5 minutes.

***Why It’s Important:*** 
Pods in CrashLoopBackOff or unhealthy states indicate application failures, misconfigurations, or resource issues. This metric ensures the application is running as expected and helps catch deployment or runtime issues early.

#### 5. CPU Utilization

***What to Monitor:*** 
The CPU usage of Nginx pods as a percentage of allocated CPU resources.

***Threshold for Alerting:*** 
Alert if CPU usage exceeds 80% of allocated resources for 5 minutes.

***Why It’s Important:***
High CPU usage can indicate resource contention, inefficient application performance, or unexpected traffic spikes. Monitoring this helps ensure the application has sufficient resources and prevents performance degradation.

#### 6. Memory Utilization

***What to Monitor:*** 
The memory usage of Nginx pods as a percentage of allocated memory resources.

***Threshold for Alerting:*** 
Alert if memory usage exceeds 80% of allocated resources for 5 minutes.

***Why It’s Important:*** 
Excessive memory usage can lead to pod evictions or crashes due to Out-Of-Memory (OOM) errors. Monitoring memory ensures the application operates within resource limits and maintains stability.

#### 7. ArgoCD Sync Status

***What to Monitor:*** 
The sync status of the Nginx application in ArgoCD, ensuring the desired state (Git) matches the cluster state.

***Threshold for Alerting:*** 
Alert if the application is OutOfSync or in a Degraded state for more than 10 minutes.

***Why It’s Important:*** 
An OutOfSync or Degraded status indicates a failure in the GitOps workflow, such as a misconfiguration or failed deployment. This ensures the application remains consistent with the desired configuration in the Git repository.

#### 8. Ingress Traffic Volume
***What to Monitor:*** 
The rate of incoming HTTP requests to the Nginx application.

***Threshold for Alerting:*** 
Alert if traffic volume deviates by more than 50% from the 1-hour moving average (e.g., sudden spikes or drops).

***Why It’s Important:*** 
Sudden changes in traffic volume can indicate legitimate usage spikes, potential DDoS attacks, or application outages. Monitoring this helps maintain scalability and detect anomalies.


