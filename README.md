# Aws-CI-CD-tf-Monitoring
Full-stack DevOps project demonstrating Infrastructure as Code (Terraform), continuous delivery (GitHub Actions), container deployment (Docker on EC2), and observability (Prometheus &amp; Grafana).


# AWS CI/CD Pipeline with Terraform, GitHub Actions, and Monitoring

**Repository:** `aws-ci-cd-tf-monitoring`

A complete DevOps project demonstrating automated deployment of a containerized application to AWS EC2 using Infrastructure as Code (Terraform), Continuous Integration/Continuous Delivery (GitHub Actions), and integrated Observability with Prometheus and Grafana.


## 🚀 Architecture and Flow

The project follows a modern DevOps workflow:

1.  **Infrastructure Provisioning:** **Terraform** provisions all necessary resources on AWS (VPC, Security Group, and the EC2 Instance with Docker/Docker Compose installed).
2.  **Code Commit:** Pushing code to the `main` branch triggers the **GitHub Actions** pipeline.
3.  **Build & Push:** GitHub Actions builds the **Docker image** and pushes it to **Docker Hub** (or ECR).
4.  **Deployment:** GitHub Actions uses **SSH** to connect to the EC2 instance and runs `docker-compose up` to pull the latest image and start the application, **Prometheus**, and **Grafana** containers.
5.  **Monitoring:** Prometheus scrapes metrics from the system and application, which are visualized via **Grafana**.


## ✅ Prerequisites

To successfully deploy this project, you will need:

* **AWS Account** with configured IAM credentials (Access Key ID and Secret Access Key).
* **AWS Key Pair (.pem file)** created in the target region (e.g., `mykey`).
* **GitHub Account** and a fresh repository.
* **Docker Hub Account** (or AWS ECR) for storing container images.
* **Software Installed Locally:**
    * [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
    * [AWS CLI](https://aws.amazon.com/cli/)
    * [Docker](https://docs.docker.com/get-docker/)


    ### 1. Infrastructure Setup (Terraform)

1.  **Configure Variables:** Edit the `terraform/variables.tf` file to set your `aws_region`, `instance_type`, and `key_name` (e.g., to `mykey`).
2.  **Initialize:** Navigate to the `terraform` directory and initialize:
    ```bash
    cd terraform
    terraform init
    ```
3.  **Review & Apply:**
    ```bash
    terraform plan
    terraform apply
    ```
    *Note: Save the `ec2_public_ip` output, you'll need it for GitHub Secrets.*


    ### 2. Configure GitHub Secrets

In your GitHub repository settings, add the following secrets (required for the CI/CD pipeline):

| Secret Name | Value |
| :--- | :--- |
| `AWS_ACCESS_KEY_ID` | Your AWS IAM Access Key ID. |
| `AWS_SECRET_ACCESS_KEY` | Your AWS IAM Secret Access Key. |
| `EC2_HOST` | The **Public IP** from the Terraform output. |
| `EC2_USERNAME` | The default user for your AMI (e.g., `ec2-user` for Amazon Linux, `ubuntu` for Ubuntu). |
| `SSH_PRIVATE_KEY` | The **full content** of your `mykey.pem` private key file. |
| `DOCKER_USERNAME` | Your Docker Hub username. |
| `DOCKER_TOKEN` | A personal access token from Docker Hub. |


### 3. Trigger Deployment

1.  Ensure your application code and `docker-compose.yml` file are finalized.
2.  Commit and push your code to the **`main`** branch:
    ```bash
    git push origin main
    ```
3.  Monitor the "Actions" tab in your GitHub repository to watch the pipeline execute the **Build** and **Deploy** jobs.


## 🌐 Accessing the Stack

Once the GitHub Actions workflow successfully completes, you can access your services using the EC2 Public IP address:

| Service | Access URL | Default Credentials |
| :--- | :--- | :--- |
| **Application** | `http://<EC2_PUBLIC_IP>:<APP_PORT>` | N/A |
| **Grafana Dashboard** | `http://<EC2_PUBLIC_IP>:3000` | `admin`/`admin` (change immediately) |
| **Prometheus UI** | `http://<EC2_PUBLIC_IP>:9090` | N/A |

### Grafana Setup

1.  Log in to Grafana (`admin`/`admin`).
2.  Add a **Data Source** and select **Prometheus**.
3.  Set the HTTP URL to `http://prometheus:9090` (using the container service name, as they are on the same Docker network).
4.  Save and Test.


## 🧹 Cleanup

To destroy all AWS resources created by Terraform (and avoid ongoing charges):

```bash
cd terraform
terraform destroy
