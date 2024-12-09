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
