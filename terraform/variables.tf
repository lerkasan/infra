variable "aws_region" {
  description   = "AWS region"
  type          = string
  default       = "us-east-1"
}

variable "az_letters" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = ["a", "b"]
}

variable "project_name" {
  description   = "Java Junior Test"
  type          = string
  default       = "demo"
}

variable "environment" {
  description   = "Environment: dev/stage/prod"
  type          = string
  default       = "stage"
}

variable "state_s3_bucket_name" {
  description   = "Terraform state S3 bucket"
  type          = string
  default       = "keycloak--terraform--state"
}

variable "state_s3_filepath" {
  description   = "Terraform state S3 bucket"
  type          = string
  default       = "keycloak/terraform.tfstate"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = [ "10.0.10.0/24", "10.0.20.0/24"]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = [ "10.0.240.0/24", "10.0.250.0/24" ]
}

locals {
  availability_zones     = [ for az_letter in var.az_letters : format("%s%s", var.aws_region, az_letter) ]
  admin_public_ip        = data.external.admin_public_ip.result["admin_public_ip"]
  ami_architecture       = var.ami_architectures[var.os_architecture]
  ami_owner_id           = var.ami_owner_ids[var.os]
  ami_name               = local.ubuntu_ami_name_filter
  ubuntu_ami_name_filter = format("%s/images/%s-ssd/%s-%s-%s-%s-%s-*", var.os, var.ami_virtualization, var.os,
  var.os_releases[var.os_version], var.os_version, var.os_architecture, var.os_product)
}

# ---------------- EC2 parameters -----------

variable "keycloak_server_private_ssh_key_name" {
  description = "Name of the SSH keypair to use with appserver"
  type        = string
  default     = "keycloak_server_ssh_key"
  sensitive   = true
}

variable "bastion_private_ssh_key_name" {
  description = "Name of the SSH keypair to use with bastion"
  type        = string
  default     = "bastion_ssh_key"
  sensitive   = true
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "bastion_instance_type" {
  description = "AWS EC2 instance type for bastion"
  type        = string
  default     = "t2.micro"
}

# ---------------- OS parameters --------------------

variable "os" {
  description = "AMI OS"
  type        = string
  default     = "ubuntu"
}

variable "os_product" {
  description = "AMI OS product. Values: server or server-minimal"
  type        = string
  default     = "server"
}

variable "os_architecture" {
  description = "OS architecture"
  type        = string
  default     = "amd64"
}

variable "os_version" {
  description = "OS version"
  type        = string
  default     = "22.04"
}

variable "os_releases" {
  description = "OS release"
  type        = map(string)
  default     = {
    "22.04"   = "jammy"
  }
}

# ---------------- AMI filters ----------------------

variable "ami_virtualization" {
  description = "AMI virtualization type"
  type        = string
  default     = "hvm"
}

variable "ami_architectures" {
  description = "AMI architecture filters"
  type        = map(string)
  default     = {
    "amd64"   = "x86_64"
  }
}

variable "ami_owner_ids" {
  description = "AMI owner id"
  type        = map(string)
  default     = {
    "ubuntu"  = "099720109477" #Canonical
  }
}

# ---------------- Default ports ---------------------

variable "http_port" {
  description = "http port"
  type        = number
  default     = 80
}

variable "https_port" {
  description = "https port"
  type        = number
  default     = 443
}

variable "ssh_port" {
  description = "ssh port"
  type        = number
  default     = 22
}

variable "mysql_port" {
  description = "mysql port"
  type        = number
  default     = 3306
}

# -------------- Database access parameters ---------------

variable "rds_name" {
  description = "The name of the RDS instance"
  type        = string
  default     = "keycloak-db"
}

variable "database_engine" {
  description = "database engine"
  type        = string
  default     = "mariadb"
}

variable "database_engine_version" {
  description = "database engine version"
  type        = string
  default     = "10.6"
}

variable "database_instance_class" {
  description = "database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "keycloak_database_name" {
  description = "Keycloak database name variable passed through a file secret.tfvars or an environment variable TF_keycloak_database_name"
  type        = string
  sensitive   = true
}

variable "keycloak_database_username" {
  description = "Keycloak database username variable passed through a file secret.tfvars or environment variable TF_keycloak_database_username"
  type        = string
  sensitive   = true
}

variable "keycloak_database_password" {
  description = "Keycloak database password variable passed through a file secret.tfvars or environment variable TF_keycloak_database_password"
  type        = string
  sensitive   = true
}

variable "keycloak_admin_password" {
  description = "Keycloak admin password variable passed through a file secret.tfvars or environment variable TF_keycloak_admin_password"
  type        = string
  sensitive   = true
}

//variable "alb_logs_s3_bucket_name" {
//  description = "Database password variable passed through a file secret.tfvars or environment variable TF_database_password"
//  type        = string
//  default     = "boanerges-demo-alb-logs"
//}

variable "admin_public_ssh_keys" {
  description = "List of names of the SSM parameters with admin public ssh keys"
  type        = list(string)
  default     = [ "lerkasan_ssh_public_key_keycloak" ]
}

variable "ansible_inventory_dir" {
  description = "Location of ansible inventory directory"
  type        = string
  default     = "../ansible/inventory"
}

variable "dynamic_inventory_file" {
  description = "Name for a hosts inventory file that will be generated by terraform for ansible"
  type        = string
  default     = "01_hosts"
}
