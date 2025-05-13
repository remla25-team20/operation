# 🛠️ REMLA Project – Operation Repository

This repository contains the **Docker Compose setup and operational instructions** for running the full Restaurant Sentiment Analysis system.

---

## 📦 System Overview

This system is structured according to the REMLA reference architecture and consists of two core services:

- `app`: The frontend/backend web application that interacts with users and forwards requests to the model service.
- `model-service`: A REST API wrapper around the trained machine learning model.

Both services are containerized and deployed via `docker-compose` using pre-built images hosted on GitHub Container Registry (GHCR).

## 🧭 Istio Service Mesh

This project includes a lightweight installation of Istio 1.25.2 as a service mesh for Kubernetes. It was provisioned automatically via Ansible, using istioctl and a custom IstioOperator configuration to expose the Istio Ingress Gateway on a fixed IP (192.168.56.91) through MetalLB.

---

## 🐳 Running the Application Locally

### ✅ Prerequisites

- Docker & Docker Compose installed
- Access to GitHub Container Registry (login if images are private)

### 🔐 Login to GHCR (if needed)

```bash
echo <YOUR_GH_TOKEN> | docker login ghcr.io -u <YOUR_GITHUB_USERNAME> --password-stdin
```

### ▶️ Start the system

```bash
docker-compose up
```

Once started, the application is accessible at:

```
http://localhost:3000
```

The model-service runs internally on port `5000` and is not exposed to the host.

---

## 🧭 Repository Overview

| Component         | Description                                             |
|------------------|---------------------------------------------------------|
| `docker-compose.yml` | Defines the services and how they run locally.       |
| `README.md`       | This file – instructions to operate the system.        |

---

## 🔗 Project Repositories

This organization is structured into multiple public repositories:

- [model-training](https://github.com/remla25-team20/model-training)
- [model-service](https://github.com/remla25-team20/model-service)
- [lib-ml](https://github.com/remla25-team20/lib-ml)
- [lib-version](https://github.com/remla25-team20/lib-version)
- [app](https://github.com/remla25-team20/app)
- [operation](https://github.com/remla25-team20/operation) ← you are here

---

## 📈 Assignment Progress Log

### ✅ Assignment 1 – Versions, Releases, and Containerization

- 🧱 Set up system architecture and organization repos.
- 🐍 Released `lib-ml` and `lib-version` as Python packages.
- 🐳 Built and pushed Docker images for `model-service` and `app` to GHCR.
- 🧩 Created `docker-compose.yml` to deploy both services.
- 📄 Added description metadata to container images.
- 🎯 Verified multi-architecture support (amd64 + arm64) for images.