variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environmene"
}

variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "cidr of the vpc"
}

variable "public_subnet_cidrs" {
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
  type        = list(string)
  description = "cidrs of the public subnets"
}

variable "private_subnet_cidrs" {
  default     = ["10.1.5.0/24", "10.1.6.0/24"]
  type        = list(string)
  description = "cidrs of the private subnets"
}

