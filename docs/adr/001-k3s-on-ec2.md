# ADR 001: Using k3s on AWS EC2

* **Date**: 2026
* **Context**: DevOps Pet Project for Automated Application Deployment

---

## Context

To demonstrate hands-on skills with Kubernetes, CI/CD, and Infrastructure as Code (Terraform), a functional, production-like cluster was required.

The primary constraint for this architectural decision was a strict budget limit: the project had to fit entirely within the **AWS Free Tier ($0/month)** or operate with minimal infrastructure costs.

---

## Decision

We decided to deploy a single-node **k3s** cluster on an **AWS EC2 (`t3.micro`)** instance, fully provisioned via **Terraform**.

`k3s` is a certified, lightweight Kubernetes distribution by Rancher. Stripped of legacy code and cloud-provider-specific drivers, its binary footprint reduces RAM consumption to ~512 MB, making it ideal for resource-constrained nodes.

---

## Alternatives Considered

### 1. AWS EKS (Amazon Elastic Kubernetes Service)
* **Pros**: Fully managed Control Plane, native integration with AWS IAM and ALB.
* **Cons**: Fixed Control Plane cost of ~$73/month, which exceeds the educational budget.
* **Verdict**: **Rejected** due to cost constraints.

### 2. Local Cluster (Minikube / Kind / k3d)
* **Pros**: Free, straightforward setup for local development.
* **Cons**: Lacks exposure to real cloud networking concepts (VPC, Public Subnets, AWS Security Groups, Elastic IPs).
* **Verdict**: **Rejected** because the project requires demonstrating real Cloud Provider (AWS) integration.

---

## Consequences & Trade-offs

### Positive Consequences:
* **Zero Infrastructure Cost ($0)**: The project fits completely within the AWS Free Tier.
* **Real Cloud Experience**: Practical application of Terraform for provisioning AWS VPCs, Subnets, Security Groups, and EC2 instances.
* **Optimization Skills**: Hands-on experience tuning Linux and Kubernetes resources under tight RAM constraints.

### Negative Consequences & Mitigation:
* **Strict Memory Limits**: A `t3.micro` instance provides only 1 GB of RAM, which is extremely tight for Kubernetes system components.
* **Required Manual Tuning**:
  * Configured a **3 GB Swap file** on the EC2 instance to prevent Out-Of-Memory (OOM) kills.
  * Applied strict resource limits and requests (`requests`/`limits`) for application Pods.
  * Substituted heavy observability stacks (e.g., full Prometheus Operator / Grafana) with lightweight monitoring setups.
