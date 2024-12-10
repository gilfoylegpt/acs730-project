variable "env" {
  default     = ""
  type        = string
  description = "Deployment Environment"
}

variable "instance_type" {
  default     = ""
  type        = string
  description = "EC2 Instance Type"
}

variable "default_tags" {
  default     = null
  type        = map(any)
  description = "Default Tags"
}

variable "prefix" {
  default     = ""
  type        = string
  description = "prefix string"
}

variable "network_datablock" {
  default     = null
  type        = any
  description = "network datablock"
}

variable "target_group_arn" {
  default     = ""
  type        = string
  description = "target group arn"
}

variable "key_name" {
  default     = ""
  type        = string
  description = "key name"
}

variable "public_websg_id" {
  default     = ""
  type        = string
  description = "public websg id"
}

variable "ami_id" {
  default     = ""
  type        = string
  description = "ami id"
}