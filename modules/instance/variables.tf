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

variable "instance_image_id" {
  default     = ""
  type        = string
  description = "EC2 Instance Image ID"
}

variable "default_tags" {
  default     = null
  type        = map(any)
  description = "default tags"
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

variable "public_websg_id" {
  default     = ""
  type        = string
  description = "public websg id"
}

variable "private_websg_id" {
  default     = ""
  type        = string
  description = "private websg id"
}

variable "private_onlysshsg_id" {
  default     = ""
  type        = string
  description = "private onlysshsg id"
}

variable "ssh_key_pair_name" {
  default     = ""
  type        = string
  description = "ssh key pair name"
}
