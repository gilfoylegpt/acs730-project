variable "default_tags" {
  default = {
    "Owner" = "Haojie Fu"
    "App"   = "ACS730 Project"
  }

  type        = map(any)
  description = "Default Resource tags"
}

variable "prefix" {
  default     = "ACS730"
  type        = string
  description = "Course Name"
}
