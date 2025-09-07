#  Project: Docker + CICD + Terraform + AWS  

This project demonstrates how to deploy a simple microservices application from local development to the cloud using modern DevOps tools and practices.  

The application is a lightweight Flask web app (Python) that uses Redis as an in-memory cache to track visitor counts. While the app itself is simple, the focus of this project is on showcasing **cloud deployment workflows, Infrastructure as Code (IaC), and CI/CD pipelines**.  

---

## 🌟 Key Features
- **Containerized Application**: Flask app with Redis cache for visitor counting
- **CI/CD Automation**: GitHub Actions builds and pushes Docker images to AWS ECR
- **Infrastructure as Code**: Terraform provisions AWS resources efficiently
- **AWS Deployment**: ECS Fargate orchestrates containers in a two-tier architecture (public/private subnets)
- **Local Development**: Docker Compose allows easy microservices testing

---

## 🛠 Technologies Used
- **Docker & Docker Compose** – Multi-stage builds, local testing
- **Python (Flask)** – Lightweight web application
- **Redis** – In-memory cache for visitor tracking
- **GitHub Actions** – CI/CD automation
- **AWS Services**:
  - ECS Fargate
  - ECR (Elastic Container Registry)
  - VPC with public & private subnets
  - Redis cache in private subnet
- **Terraform** – Infrastructure provisioning as code

---

## 🔄 Workflow Overview
1. **Develop**: Flask + Redis app tracks visitor counts  
2. **Containerize**: Optimize Docker images using multi-stage builds  
3. **Local Test**: Use Docker Compose to connect Flask and Redis locally  
4. **CI/CD**: GitHub Actions builds & pushes Docker images to AWS ECR  
5. **Provision**: Terraform creates VPC, ECS Fargate services, and Redis in private subnet  
6. **Deploy**: App runs on AWS with a secure two-tier architecture



## 🔹 CI/CD Pipeline

I created a **CI/CD pipeline** using **GitHub Actions** to automate building, tagging, and deploying Docker images to **AWS ECR**.

**Workflow steps:**

1. **AWS Setup**:  
   - Configured AWS using my credentials (`AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY`) stored securely in **GitHub Actions Secrets**.  
   - Set the AWS region for deployment.

2. **Docker Build & Push**:  
   - Defined the registry and obtained the current Git commit SHA:  
     ```bash
     sha=$(git rev-parse --short HEAD)
     primary_tag="${registry}:${sha}"
     ```  
   - Built and pushed the Docker image to ECR:  
     ```bash
     docker build -t $primary_tag .
     docker push $primary_tag
     ```

3. **Branch-Based Automation**:  
   - If the branch is `main`, create a temporary retention tag and push it:  
     ```bash
     retention_tag="latest"
     docker tag $primary_tag $retention_tag
     docker push $retention_tag
     ```

**Highlights:**  
- Automates end-to-end deployment from local development to AWS.  
- Uses SHA for unique image versioning.  
- Retention tags for the main branch ensure easy rollback and tracking.


---
## 📊 Architecture Diagram

<p align="center">
  <img src="assets/architecture.jpg" alt="Architecture Diagram" width="600">
</p>


## 🎥 Flask app

<p align="center">
  <img src="assets/flaskapp.gif" width="700" alt="Demo video as GIF">
</p>





---

