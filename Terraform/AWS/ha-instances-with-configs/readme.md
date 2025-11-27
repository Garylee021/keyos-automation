# Terraform Project for deploying KeyOS HA on AWS with VPC Route Server and Transit Gateway

This Terraform project automates the deployment of **two KeyOS instances** in High Availability (HA) mode on AWS, integrated with a **VPC Route Server** and **Transit Gateway** for advanced network connectivity, routing and High Availability (HA) use cases.

In addition to the KeyOS HA setup, this project also deploys two VPCs: a **Transit VPC** and a **Data VPC**.  
- The **Transit VPC** is used for deploying KeyOS instances and the VPC Route Server.  
- The **Data VPC** simulates a VPC attachment and includes a test **Amazon Linux EC2 instance** to validate data path connectivity.

> If you already have an existing AWS infrastructure, you can **exclude** the Data VPC, its subnets, and the EC2 instance. To do so, update the following Terraform files accordingly: `main.tf`, `network.tf`, `transit_gateway.tf`, `variables.tf`, and `outputs.tf`.

This is the connection diagram:
![Infrastructure Diagram](diagram/KeyOS-HA-setup-on-AWS.png)

## Why This Topology?

This solution is designed for organizations that require **highly available** routing with dynamic connectivity to multiple AWS VPCs or hybrid environments.

### Key Benefits of the HA Topology:

- **Effective Failover with BGP Redundancy**  
  Two KeyOS EC2 instances are deployed as BGP peers, each connected to the AWS VPC Route Server. While technically both routers are active BGP participants, only one is typically preferred as the next-hop.

  If one KeyOS instance fails or is taken offline for maintenance, **Bidirectional Forwarding Detection (BFD)** detects the failure in milliseconds. The route server:
  - Withdraws routes for the failed peer from the RIB.
  - Recalculates the best path using the FIB.
  - Updates affected VPC route tables with the new next-hop (preferred KeyOS instance).
  
  This process enables **sub-second failover** (typically <1s), far faster than AWS native route table failover mechanisms using the API.

  This approach is particularly valuable for use cases requiring **business continuity**, **low RTO**, and **fast edge recovery** during:
  - Instance crashes
  - KeyOS OS upgrades or maintenance procedures
  - Network disruptions

This architecture is ideal for:
- Cloud edge routing with failover
- Multi-VPC and multi-region route control
- Enterprises requiring resilient and scalable cloud network infrastructure

## Prerequisites

Before applying this module, ensure you have:

### AWS Requirements

- An active AWS account.
- AWS CLI installed. [Installation link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Terraform installed. [Installation link](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Set AWS environment variables

- Run the following commands in your terminal to set the AWS environment variables:

```sh
export AWS_ACCESS_KEY_ID="<AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<AWS_SECRET_ACCESS_KEY>"
export AWS_SESSION_TOKEN="<AWS_SESSION_TOKEN>"
export AWS_DEFAULT_REGION="<AWS_REGION>" # e.g us-east-1
```

### Fetch AMI ID and Owner ID (Required for main.tf)
1. Subscribe to KeyOS in the AWS Marketplace.
2. Use the following AWS CLI command to find the correct AMI ID, Owner ID, and ensure you're querying the correct region (e.g., `us-east-1`):

```sh
aws ec2 describe-images \
  --owners aws-marketplace \
  --filters "Name=product-code,Values=8wqdkv3u2b9sa0y73xob2yl90" \
  --query 'Images[*].[ImageId,OwnerId,Name]' \
  --output table
```
Alternatively, you can hardcode the latest AMI ID for your region in `variables.tf` adding the `keyos_ami_id` variable.

### Generate SSH keypair

A demo key is included in the `keys/` folder. To generate your own:

```sh
ssh-keygen -b 2048 -t rsa -m PEM -f keys/keyos_custom_key.pem
```

## Project Structure

```
.
├── files/
│   ├── on-prem-keyos-config.txt
│   ├── keyos_01_user_data.tfpl
│   └── keyos_02_user_data.tfpl
├── keys/
│   ├── keyos_lab_private_key.pem
│   └── keyos_lab_public_key.pem
├── main.tf
├── network.tf
├── security_groups.tf
├── transit_gateway.tf
├── output.tf
├── provider.tf
├── variables.tf
└── README.md
```

## Usage

### Setup Variables

All variables are defined in `variables.tf`. Customize values like instance type, region, `keyos_ami_id`, etc.

## How to Run the Module

Follow these steps to initialize, plan, apply, and manage your infrastructure with Terraform:

1. **Initialize the Module**
   ```sh
   terraform init
   ```

2. **Format the Terraform Code**
   ```sh
   terraform fmt
   ```

3. **Validate Configuration**
   ```sh
   terraform validate
   ```

4. **Preview Infrastructure Changes Before Deployment**
   ```sh
   terraform plan
   ```

5. **Apply the Configuration**
   ```sh
   terraform apply
   ```
   Confirm the execution when prompted to provision the infrastructure.

6. **View Outputs**
   ```sh
   terraform output
   ```
   This will display the management IP and test results for the KeyOS instance.

## Management

To manage the KeyOS instance, use the `keyos_public_ip` from `terraform output`:
```sh
ssh keyos@<keyos_public_ip> -i keys/keyos_lab_private_key.pem
```
The on-premises KeyOS configuration can be found in `files/on-prem-keyos-config.txt`

## Destroying Resources

To clean up the deployed infrastructure:
```sh
terraform destroy
```
Confirm when prompted.
