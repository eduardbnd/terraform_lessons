# Auto fill parameters for PROD

# File can be named as
# terraform.tfvars
# prod.auto.tfvars
# dev.auto.tfvars

region                     = "us-east-1"
instance_type              = "t2.small"
enable_detailed_monitoring = true

allow_ports = ["80", "443", "8080"]

common_tags = {
  Name        = "Eduard"
  Owner       = "Eduard Bondarenko"
  Project     = "Phoenix"
  CostCenter  = "1234577"
  Environment = "prod"

}
