# **Terraform Multi-Container Environment**
## **Overview**
## This project sets up a multi-container environment using Terraform and Docker. It includes the following:

## **Components**

### NGINX Container:
+ Acts as a reverse proxy and load balancer.
+ Handles HTTPS traffic with SSL certificates.
+ Forwards requests to an application container.

###Application Container:
+ Runs a simple HTTP server using the hashicorp/http-echo image.
+ Responds with "Hello, World!" when accessed.

## Features

### SSL Configuration:
+ Configured SSL for secure communication with NGINX.
+ Includes auto-generated self-signed certificates.

### Custom DNS Setup:
+ Maps a fake DNS name (myapp.local) to the NGINX container.
+ Output of NGINX IP Address:
+ Displays the IP address of the NGINX container after provisioning.

## Setup Instructions

### Prerequisites
**Install Terraform**
Follow the instructions at Terraform's official website.

**Install Docker**
+ Install Docker following the guide at Docker's official website.

+ Verify Installations:

**Ensure Terraform is installed**
> terraform --version

**Ensure Docker is installed**
> docker --version

## **Project Files:**
+ main.tf: The main Terraform configuration file to set up Docker containers, networks, and SSL.
+ nginx/nginx.conf: Custom NGINX configuration for handling HTTPS and reverse proxying.
+ ssl/: Directory containing SSL certificates (nginx.key and nginx.crt).
+ .gitignore: Defines files and directories to exclude from version control.

## How to Run the Project
### Step 1: Clone the Repository
**Clone this repository to your local machine:**
> git clone <repository_url>
> cd <repository_directory>

**Replace [CHANGE_PATH_TO] in __main.tf__ to full path to the folder**

### Step 2: Initialize Terraform
**Run the following command to initialize Terraform and download required providers:**
> terraform init

### Step 3: Generate SSL Certificates
**Generate a self-signed certificate for HTTPS:**

>openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/nginx.key -out ssl/nginx.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=myapp.local"

### Step 4: Apply the Terraform Configuration
**Deploy the infrastructure with Terraform:**

> terraform apply

When prompted, type yes to confirm.


### Step 5: Test the Setup
**Access the Application**
Test HTTPS:

>curl -k https://myapp.local

You should see the response:
- Hello, World!

Test the NGINX IP Output: After running terraform apply, the NGINX container's IP address will be printed in the output.

### Inspect Containers
**Check the running Docker containers:**
> docker ps

### Environment Setup
**Customizing Variables**

If needed, create a **terraform.tfvars** file to override default variables:

>app_port = 8080
>nginx_port = 443

### Cleaning Up
To destroy the environment and stop all containers, run:

>terraform destroy


## File Structure

>.
>├── main.tf               # Terraform configuration file
>├── nginx/
>│   ├── nginx.conf            # Custom NGINX configuration
>├── ssl/
>│   ├── nginx.crt         # Self-signed SSL certificate
>│   └── nginx.key         # SSL private key
>├── .gitignore            # Git ignore rules
>└── README.md             # Project documentation
