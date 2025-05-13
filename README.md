# 🛠️ REMLA Project – Operation Repository

This repository contains the setup and operational instructions for running the Restaurant Sentiment Analysis system, supporting both Docker Compose (Assignment 1) and Kubernetes cluster (Assignment 2) deployments.

## 📦 System Overview

This system is structured according to the REMLA reference architecture and consists of two core services:

- `app`: The frontend/backend web application that interacts with users and forwards requests to the model service.
- `model-service`: A REST API wrapper around the trained machine learning model.

Both services are containerized and can be deployed via Docker Compose (local) or Kubernetes (production-grade), using pre-built images hosted on GitHub Container Registry (GHCR).

## 🐳 Running the Application

### Assignment 1 – Docker Compose (Local)

Run the system locally using Docker Compose.

1. **Prerequisites**:
   - Docker and Docker Compose installed.
   - Access to GitHub Container Registry (GHCR).
2. **Login to GHCR** (if images are private):
   ```bash
   echo <YOUR_GH_TOKEN> | docker login ghcr.io -u <YOUR_GITHUB_USERNAME> --password-stdin
   ```
3. **Start the system**:
   ```bash
   docker-compose up
   ```
   - Access the application at: `http://localhost:3000`

### Assignment 2 – Kubernetes Cluster (Production)

Provision a Kubernetes cluster with Istio service mesh to deploy the system in a production-grade environment.

1. **Prerequisites**:
   - Vagrant and VirtualBox installed.
   - Ansible installed for provisioning.
2. **Provision virtual machines**:
   ```bash
   vagrant up
   ```
   - Creates controller (`ctrl`, 1 CPU, 4GB) and worker nodes (`node-<N>`, 2 CPUs, 6GB) using `bento/ubuntu-24.04`.
3. **Run final provisioning**:
   ```bash
   ansible-playbook -u vagrant -i 192.168.56.100, ansible/finalization.yml
   ```
   - Installs MetalLB, Nginx Ingress, Kubernetes Dashboard, and Istio 1.25.2.
4. **Istio Service Mesh**:
   - Lightweight Istio 1.25.2 installed via Ansible using `istioctl`.
   - Istio Ingress Gateway exposed on `192.168.56.91` via MetalLB.

**Operation Release**: [A2 Release](https://github.com/remla25-team20/operation/releases/tag/a2)

## 🧭 Repository Overview

| Component            | Description                                             |
|---------------------|---------------------------------------------------------|
| `docker-compose.yml` | Defines services for local Docker Compose deployment.   |
| `Vagrantfile`        | Configures Kubernetes cluster VMs for Assignment 2.     |
| `ansible/`           | Contains Ansible playbooks for cluster provisioning.    |
| `README.md`          | Instructions to operate the system (this file).         |

## 🔗 Project Repositories

This organization is structured into multiple public repositories:

- [model-training](https://github.com/remla25-team20/model-training)
- [model-service](https://github.com/remla25-team20/model-service)
- [lib-ml](https://github.com/remla25-team20/lib-ml)
- [lib-version](https://github.com/remla25-team20/lib-version)
- [app](https://github.com/remla25-team20/app)
- [operation](https://github.com/remla25-team20/operation) ← you are here

## 📈 Assignment Progress Log

### Assignment 1 – Versions, Releases, and Containerization

- ✅ **Set up system architecture**: Established organization repositories for REMLA components.
- ✅ **Released Python packages**: Published `lib-ml` and `lib-version` to PyPI.
- ✅ **Built Docker images**: Created and pushed `model-service` and `app` images to GHCR.
- ✅ **Configured Docker Compose**: Defined `docker-compose.yml` for local deployment.
- ✅ **Added image metadata**: Included description metadata in container images.
- ✅ **Verified multi-architecture support**: Ensured images support amd64 and arm64.

### Assignment 2 – Provisioning a Kubernetes Cluster

#### Targeted Rating
| Category                     | Rating  | Notes                                                                 |
|------------------------------|---------|----------------------------------------------------------------------|
| Setting up (Virtual) Infrastructure | **Excellent** | Fully automated VM setup with configurable worker nodes and inventory. |
| Setting up Software Environment    | **Good**      | Errors in first run of `finalization.yml`; works on second run.       |
| Setting up Kubernetes             | **Good**      | Missing HTTPS Ingress Controller with self-signed certificates.       |

- ✅ **Automated virtual infrastructure**: Set up configurable VMs (`ctrl`, `node-<N>`) with Vagrant and Ansible inventory.
- ✅ **Deployed Kubernetes cluster**: Initialized cluster with `kubeadm`, `kubectl`, Flannel, and Helm.
- ✅ **Installed production components**: Configured MetalLB, Nginx Ingress, and Kubernetes Dashboard.
- ✅ **Enabled Istio service mesh**: Deployed Istio 1.25.2 with Ingress Gateway on `192.168.56.91`.
