# Troubleshooting & Incident Resolution Guide

This document records real-world issues encountered during the setup and deployment of the `k3s` cluster on resource-constrained AWS hardware (`t3.micro`), along with the diagnostic workflows and engineering solutions applied.

---

## Issue 001: Kubernetes API Unavailability and OOMKilled Monitoring Pods

### Problem Statement
During the deployment of observability components (Prometheus and Grafana stack), the cluster experienced critical instability:
* Monitoring Pods were continuously terminated with the `OOMKilled` status.
* The Kubernetes API server became intermittently unreachable, returning `context deadline exceeded` and `connection refused` errors on port `6443`.
* `kubectl` commands frequently timed out or failed to communicate with the control plane.

---

### Investigation & Root Cause Analysis

To diagnose the issue, a step-by-step investigation was conducted:

1. **System Memory & Swap Inspection**:
   Executing `free -h` on the EC2 host revealed that system memory utilization was at 98–100%, with 0 KB of swap space available.

2. **Kubernetes Workload Diagnostics**:
   Running `kubectl describe pod <prometheus-pod-name>` confirmed that the Linux kernel OOM killer had terminated the containers due to memory limit breaches.

3. **Kernel Logs Analysis**:
   Inspecting system logs via `dmesg -T | grep -i oom` showed that the host operating system, `k3s` control plane processes, and embedded `etcd` datastore were actively competing with Prometheus for memory on the single 1 GB RAM node (`t3.micro`).

**Root Cause**: 1 GB RAM is insufficient to concurrently run system OS services, `k3s` control plane, `etcd`, ingress controllers, application workloads, and a standard Prometheus/Grafana observability stack without virtual memory backup.

---

### Resolution & Mitigation Strategies

To achieve cluster stability while staying within the AWS Free Tier budget, a multi-layered resolution plan was executed:

1. **Configured a 3 GB Host Swap File**:
   Created and enabled a dedicated swap file on the EC2 instance to extend available virtual memory and absorb sudden memory spikes:
   ```bash
   sudo fallocate -l 3G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab
