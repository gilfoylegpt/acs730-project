variable "env" {
  default     = ""
  type        = string
  description = "Deployment Environmene"
}

variable "vpc_cidr" {
  default = {
    "dev"     = "10.1.0.0/16"
    "staging" = "10.2.0.0/16"
    "prod"    = "10.3.0.0/16"
  }
  type        = map(any)
  description = "cidr map of the vpc"
}

variable "public_subnet_cidrs" {
  default = {
    "dev"     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
    "staging" = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24", "10.2.4.0/24"]
    "prod"    = ["10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24", "10.3.4.0/24"]
  }
  type        = map(any)
  description = "cidrs map of the public subnets"
}

variable "private_subnet_cidrs" {
  default = {
    "dev"     = ["10.1.5.0/24", "10.1.6.0/24"]
    "staging" = ["10.2.5.0/24", "10.2.6.0/24"]
    "prod"    = ["10.3.5.0/24", "10.3.6.0/24"]
  }
  type        = map(any)
  description = "cidrs map of the private subnets"
}

