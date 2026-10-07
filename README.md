# Infrastructure Automation & Microservice Deployment on AWS k3s

[![CI/CD Pipeline](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-blue?logo=githubactions)](https://github.com)
[![Infrastructure-as-Code](https://img.shields.io/badge/IaC-Terraform-violet?logo=terraform)](https://github.com)
[![Orchestration](https://img.shields.io/badge/Orchestration-k3s-orange?logo=kubernetes)](https://github.com)
[![Cloud](https://img.shields.io/badge/Cloud-AWS-yellow?logo=amazon-aws)](https://github.com)

A pet project demonstrating an end-to-end DevOps pipeline for provisioning cloud infrastructure, bootstrapping a lightweight Kubernetes (`k3s`) cluster on AWS EC2, and automating microservice delivery with continuous integration and deployment.

---

## Architecture & Tech Stack

| Component | Technology | Responsibility / Description |
| :--- | :--- | :--- |
| **Infrastructure as Code** | **Terraform** | Provisions AWS VPC, Security Groups, EC2 (`t3.micro`), Elastic IP, and IAM roles. |
| **Container Orchestration** | **k3s (Kubernetes)** | Lightweight Kubernetes distribution running on AWS EC2 for workload orchestration. |
| **CI/CD Pipeline** | **GitHub Actions** | Automates Docker image build/push to Docker Hub, SSH deployment, and Kubernetes manifest execution. |
| **Workload / Application** | **Docker & Kubernetes** | Microservice containerized and deployed with resource limits and health checks. |
| **Monitoring & Observability** | **Prometheus & Grafana** | Cluster metrics collection, scraping, and visualization dashboard stack. |
| **Documentation** | **Markdown** | Comprehensive guides for setup, troubleshooting, and architectural decisions. |

---
```text
[ Local Code Change ]
        │
        ▼
[ Git Push to Main Branch ]
        │
        ▼
[ GitHub Actions CI/CD Pipeline ]
   ├── 1. Build & Tag Docker Image
   ├── 2. Push Image to GHCR (GitHub Container Registry)
   ├── 3. SSH / OIDC Deployment to AWS EC2 Instance
   └── 4. Apply Kubernetes Manifests (kubectl apply / Rolling Update)
        │
        ▼
[ AWS EC2 Instance (k3s Cluster) ]
   ├── Ingress Controller (Traefik) / ClusterIP Service
   └── Application Pods & Monitoring Workloads
```

---

## Key Highlights & Capacity Planning (Troubleshooting)

Deploying a modern Kubernetes stack on a single resource-constrained node (`t3.micro` with 1 GB RAM) presents unique engineering challenges. 

* **OOM Prevention**: Added a custom 3 GB swap file and strictly defined container resource requests/limits (`requests` / `limits`) to prevent the Linux kernel OOM killer from terminating cluster control plane components (`k3s`, `etcd`).
* **Observability Optimization**: Adjusted Prometheus scrap intervals and retention parameters to maintain cluster visibility without consuming critical system RAM.
* **Architecture Takeaway**: For production-grade observability (Prometheus/Grafana stack), a minimum node size of `t3.small` (2 GB RAM) or offloading metrics to external SaaS solutions (e.g., Grafana Cloud) is recommended.

For detailed diagnostic workflows and step-by-step incident resolution, see the [Troubleshooting Guide](docs/troubleshooting.md).

---

## Project Structure & Navigation

* [`terraform/`](./terraform/) — Infrastructure as Code definitions for AWS resources.
* [`k8s/`](./k8s/) — Kubernetes manifests (Deployments, Services, ConfigMaps, Ingress, Resource Limits).
* [`docs/`](./docs/) — Documentation, architecture diagrams, and the [Troubleshooting & Incident Guide](./docs/troubleshooting.md).

---

## Quick Start

### Prerequisites
* [Terraform](https://www.terraform.io/) >= 1.0
* [AWS CLI](https://aws.amazon.com/cli/) configured with proper credentials
* [kubectl](https://kubernetes.io/docs/tasks/tools/)

### Infrastructure Provisioning
```bash
cd terraform
terraform init
terraform plan
terraform apply
License
Distributed under the MIT License. See LICENSE for more information.

