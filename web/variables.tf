variable "env" {
  default     = ""
  type        = string
  description = "Deployment Environment"
}

variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "EC2 Instance Type"
}