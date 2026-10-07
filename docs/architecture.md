# Architecture Overview

This document describes the infrastructure and CI/CD pipeline for the pet project, designed to automate application deployment to Kubernetes using the lightweight `k3s` distribution hosted on AWS.

---

## 1. Infrastructure

The infrastructure is entirely defined as code using **Terraform** and provisioned in **Amazon Web Services (AWS)**. The Kubernetes cluster runs on an `EC2 t3.micro` instance.

**Infrastructure Diagram:**

+-----------------------------------------------------------------------+
| AWS Cloud (Region: eu-central-1)                                      |
|                                                                       |
|  +-----------------------------------------------------------------+  |
|  | VPC (Virtual Private Cloud)                                     |  |
|  |                                                                 |  |
|  |  +-----------------------------------------------------------+  |  |
|  |  | Public Subnet                                             |  |  |
|  |  |                                                           |  |  |
|  |  |  +-----------------------------------------------------+  |  |  |
|  |  |  | EC2 Instance (t3.micro)                             |  |  |  |
|  |  |  |                                                     |  |  |  |
|  |  |  |  +-----------------------------------------------+  |  |  |  |
|  |  |  |  | k3s Lightweight Kubernetes Cluster            |  |  |  |  |
|  |  |  |  |                                               |  |  |  |  |
|  |  |  |  |  [ Ingress Controller (Traefik) ]             |  |  |  |  |
|  |  |  |  |         |                                     |  |  |  |  |
|  |  |  |  |         v                                     |  |  |  |  |
|  |  |  |  |  [ Kubernetes Service ]                       |  |  |  |  |
|  |  |  |  |         |                                     |  |  |  |  |
|  |  |  |  |         v                                     |  |  |  |  |
|  |  |  |  |  [ Application Pods ]                         |  |  |  |  |
|  |  |  |  +-----------------------------------------------+  |  |  |  |
|  |  |  +-----------------------------------------------------+  |  |  |
|  |  +-----------------------------------------------------------+  |  |
|  +-----------------------------------------------------------------+  |
+-----------------------------------------------------------------------+

### Infrastructure Components:
* **Terraform**: Automates the provisioning of VPC, Subnets, Security Groups, and EC2 instances.
* **AWS EC2 (`t3.micro`)**: Virtual machine serving as the host node for the cluster.
* **k3s**: A certified Kubernetes distribution by Rancher, optimized for resource-constrained environments.
* **Traefik (Ingress)**: The default ingress controller built into k3s, routing external HTTP/HTTPS traffic to internal services.

---

## 2. CI/CD Pipeline

The application build and delivery pipeline is fully automated using **GitHub Actions**.

**Pipeline Diagram:**

Developer (Push) ➔ GitHub Repository ➔ GitHub Actions (Build & Test) ➔ GHCR (Docker Images) ➔ Kubernetes k3s (Pull & Deploy) ➔ Application (Running Pods)

### Pipeline Stages:
1. **Commit & Push**: Developer pushes code changes to the GitHub repository.
2. **GitHub Actions Workflow**: Triggers the automated build process upon every push to the `main` branch.
3. **Docker Build**: Builds an optimized Docker image of the application.
4. **GHCR (GitHub Container Registry)**: Registry storing the tagged container images.
5. **Deployment to k3s**: The cluster pulls the latest image from GHCR and performs a Rolling Update on the application pods.

---

## 3. Networking & Traffic Flow

Traffic routing inside the cluster follows standard Kubernetes architectural principles:

**Traffic Flow Diagram:**

Internet ➔ AWS Security Group (Ports 80/443) ➔ k3s Ingress Controller ➔ Kubernetes Service (ClusterIP) ➔ Application Pods

### Network Components:
* **Ingress**: Listens on public node ports and routes incoming requests to internal services based on host/path rules.
* **Service**: Provides a stable internal IP and load balancing across application pods.
* **Pods**: Isolated containers running the application workloads.
