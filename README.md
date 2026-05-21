# PE Bootcamp

A hands-on SRE bootcamp project that walks through building and deploying a simple REST API — from local development all the way to Kubernetes deployment with observability.This project follows the [one2n SRE Bootcamp](https://one2n.io/sre-bootcamp/sre-bootcamp-exercises) exercise series.


## Progress
 
| # | Milestone | Status | Tools used |
|---|-----------|--------|------------|
| 1 | Create a simple REST API | ✅ Done | Python Flask framework |
| 2 | Containerise REST API | ✅ Done | Docker |
| 3 | Setup one-click local development setup | ✅ Done | Docker Compose |
| 4 | Setup a CI pipeline | ✅ Done | Jenkins  |
| 5 | Deploy REST API & dependent services on bare metal | ✅ Done | Packer + Terraform |
| 6 | Setup Kubernetes cluster | 🔄 In progress | k3d |
| 7 | Deploy REST API & dependent services in K8s | ⬜ Pending | kubectl |
| 8 | Deploy REST API & dependent services using Helm Charts | ⬜ Pending | Helm |
| 9 | Setup one-click deployments using ArgoCD | ⬜ Pending | ArgoCD |
| 10 | Setup an observability stack | ⬜ Pending | Prometheus + Grafana |
| 11 | Configure dashboards & alerts | ⬜ Pending | Grafana |
 
## Prerequisites
 
Ensure the following are installed before running the project:
 
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
For infrastructure provisioning (milestone 5):
 
- [Packer](https://developer.hashicorp.com/packer/install)
- [Terraform](https://developer.hashicorp.com/terraform/install)
---

 ## Running Locally
 
```bash
# Build the backend Docker image
./build.sh
 
# Start all containers in the background
./build.sh up -d
 
# Stop and remove all containers
./build.sh down
```
 

## Infrastructure
 
The `infra/` repo contains the infrastructure-as-code for bare metal deployment
 
### Golden Image (Packer)
 
The Packer template builds a pre-configured machine image with all required dependencies baked in, producing a consistent base for deployments
 
```bash
cd infra/golden-images_pkr
packer build .
```
 
### Virtual Machine (Terraform)
 
The Terraform configuration provisions the VM using the golden image produced by Packer.
 
```bash
cd infra/
terraform init
terraform plan
terraform apply
```
 
---