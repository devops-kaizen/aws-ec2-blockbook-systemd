# BlockBook Deployment with Terraform and Ansible

This repository contains scripts to automate the deployment of FLO BlockBook on an AWS EC2 instance. The deployment process includes provisioning an EC2 instance using Terraform, installing Docker using Ansible, and deploying BlockBook using systemd services with Ansible.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Terraform Scripts](#terraform-scripts)
- [Ansible Playbooks](#ansible-playbooks)
- [Deployment Steps](#deployment-steps)
- [Checking Service Status and Logs](#checking-service-status-and-logs)
- [License](#license)

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed on your local machine.
- AWS account with IAM user credentials configured on your local machine. Th

## Setup

1. **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/blockbook-deployment.git
    cd blockbook-deployment
    ```

2. **Configure AWS credentials:**
    Ensure your AWS credentials are configured in `~/.aws/credentials` or use environment variables:
    ```bash
    export AWS_ACCESS_KEY_ID=your_access_key_id
    export AWS_SECRET_ACCESS_KEY=your_secret_access_key
    export AWS_DEFAULT_REGION=your_default_region
    ```

## Terraform Scripts

The Terraform scripts in the `terraform` directory provision an EC2 instance for the deployment.

### Usage

1. **Navigate to the Terraform directory:**
    ```bash
    cd terraform
    ```

2. **Initialize Terraform:**
    ```bash
    terraform init
    ```

3. **Apply the Terraform configuration:**
    ```bash
    terraform apply
    ```
    Confirm the action by typing `yes` when prompted.

4. **Output:**
    After the apply process, Terraform will output the public IP address of the EC2 instance. Note this IP address for later use.

## Ansible Playbooks

The Ansible playbooks in this repository perform the following tasks:

1. **Install and start Docker:**
    - `playbooks/install_docker.yml`

2. **Deploy BlockBook using systemd:**
    - `playbooks/deploy_blockbook.yml`

### Usage

1. **Navigate to the Ansible directory:**
    ```bash
    cd ../ansible
    ```

2. **Configure Ansible inventory:**
    Update the `inventory.ini` file with the EC2 instance IP address obtained from the Terraform output.

    ```ini
    [blockbook]
    your_ec2_instance_ip
    ```

3. **Run the playbook to install Docker:**
    ```bash
    ansible-playbook -i inventory.ini playbooks/install_docker.yml
    ```

4. **Run the playbook to deploy BlockBook:**
    ```bash
    ansible-playbook -i inventory.ini playbooks/deploy_blockbook.yml
    ```

## Deployment Steps

1. **Provision EC2 instance:**
    - Use Terraform to create an EC2 instance.

2. **Install Docker on the EC2 instance:**
    - Run the `install_docker.yml` Ansible playbook.

3. **Deploy BlockBook:**
    - Run the `deploy_blockbook.yml` Ansible playbook.

## Checking Service Status and Logs

### Check Service Status

- **FLO Backend:**
    ```bash
    sudo systemctl status backend-flo.service
    ```

- **BlockBook:**
    ```bash
    sudo systemctl status blockbook-flo.service
    ```

### View Logs

- **FLO Backend Logs:**
    ```bash
    sudo tail -f /opt/coins/data/flo/backend/debug.log
    ```

- **BlockBook Logs:**
    ```bash
    sudo tail -f /opt/coins/blockbook/flo/logs/blockbook.INFO
    ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
