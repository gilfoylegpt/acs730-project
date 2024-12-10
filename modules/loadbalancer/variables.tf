variable "env" {
  default     = ""
  type        = string
  description = "Deployment Environment"
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

variable "public_websg_id" {
  default     = ""
  type        = string
  description = "public websg id"
}

variable "network_datablock" {
  default     = null
  type        = any
  description = "network datablock"
}

variable "instance_id_list" {
  default     = []
  type        = list(string)
  description = "instance id list"
}