variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "environment_name" {
  description = "Environment name used in resource names and tags"
  type        = string
  default     = "dev-kalpesh"
}

variable "business_division" {
  description = "Business division used for standardized naming"
  type        = string
  default     = "eic-internal"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "kalpesh-demo"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = null
}

variable "cluster_service_ipv4_cidr" {
  description = "Service CIDR range for Kubernetes services"
  type        = string
  default     = null
}

variable "cluster_endpoint_private_access" {
  description = "Whether to enable private access to the EKS API"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Whether to enable public access to the EKS API"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks permitted to access the public EKS API"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_instance_types" {
  description = "List of EC2 instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_capacity_type" {
  description = "Capacity type for the EKS node group"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_disk_size" {
  description = "Root volume size for worker nodes"
  type        = number
  default     = 20
}

variable "istio_enabled" {
  description = "Enable Istio-related resources"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Global tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform = "true"
  }
}


