variable "env" {
  default     = ""
  type        = string
  description = "Deployment Environmene"
}

variable "default_tags" {
  default     = null
  type        = map(any)
  description = "default tags"
}

variable "prefix" {
  default     = ""
  type        = string
  description = "prefix of the project"
}

variable "vpc_cidr" {
  default     = ""
  type        = string
  description = "cidr of the vpc"
}

variable "azones" {
  default     = null
  type        = any
  description = "availability zones"
}

variable "public_subnet_cidrs" {
  default     = []
  type        = list(string)
  description = "cidrs of the public subnets"
}

variable "private_subnet_cidrs" {
  default     = []
  type        = list(string)
  description = "cidrs of the private subnets"
}

