variable "region" {
  description = "Please Enter a AWS Region to deploy server"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Enter instance type"
  type        = string
  default     = "t3.small"
}

variable "allow_ports" {
  description = "List of ports to open for server"
  default     = ["80", "443", "22", "8080"]
}

variable "enable_detailed_monitoring" {
  default = "false"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(any)
  default = {
    Name        = "Eduard"
    Owner       = "Eduard Bondarenko"
    Project     = "Phoenix"
    CostCenter  = "12345"
    Environment = "development"
  }
}
