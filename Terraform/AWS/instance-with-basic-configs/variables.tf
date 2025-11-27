variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "AWS Availability Zone"
  type        = string
  default     = "us-east-1a"
}

variable "prefix" {
  type        = string
  description = "Prefix for the resource names and Name tags"
  default     = "demo"
}

variable "key_pair_name" {
  description = "SSH key pair name"
  type        = string
  default     = "keyos-demo-key"
}

variable "private_key_path" {
  description = "Path to the private key file"
  default     = "keys/keyos_demo_private_key.pem"
}

variable "public_key_path" {
  description = "Path to the private key file"
  default     = "keys/keyos_demo_public_key.pem"
}

variable "vpc_name" {
  description = "Name for VPC"
  default     = "test-vpc"
}

variable "public_subnet_name" {
  description = "The name of the public subnet"
  type        = string
  default     = "pub-subnet"
}

variable "private_subnet_name" {
  description = "The name of the private subnet 01"
  type        = string
  default     = "priv-subnet"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  default     = "172.16.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "172.16.11.0/24"
}

variable "keyos_pub_nic_ip_address" {
  description = "KeyOS Instance Public address"
  type        = string
  default     = "172.16.1.11"
}

variable "keyos_priv_nic_address" {
  description = "KeyOS Instance Private NIC address"
  type        = string
  default     = "172.16.11.11"
}

variable "keyos_instance_type" {
  description = "The type of the KeyOS Instance"
  type        = string
  default     = "c5n.xlarge"
}

variable "keyos_instance_name" {
  type    = string
  default = "KeyOS"
}

variable "igw_name" {
  type    = string
  default = "igw"
}

variable "keyos_eip_name" {
  type    = string
  default = "keyos"
}

variable "public_rtb_name" {
  type    = string
  default = "public-rtb"

}

variable "public_sg_name" {
  type    = string
  default = "public-sg"
}

variable "private_sg_name" {
  type    = string
  default = "private-sg"
}
