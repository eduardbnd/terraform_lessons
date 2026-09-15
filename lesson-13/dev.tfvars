# Auto fill parameters for DEV

# File can be named as
# terraform.tfvars
# prod.auto.tfvars
# dev.auto.tfvars

region                     = "us-east-1"
instance_type              = "t2.micro"
enable_detailed_monitoring = false

allow_ports = ["80", "22", "8080"]

common_tags = {
  Name        = "Eduard"
  Owner       = "Eduard Bondarenko"
  Project     = "Phoenix"
  CostCenter  = "12345"
  Environment = "development"

}
