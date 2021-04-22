variable instance_name {
  description = "Name for the instance"
  default = "new-instance"
}

variable vpc {
  description = "VPC to place the instance"
  default = ""
}

variable subnet_id {
  description = "Subnet ID to place the instance"
  default = ""
}

variable profile {
  description = "Profile to use for instance"
  default = "cx2-4x8"
}

variable ibmcloud_api_key {
  description = "API key to use to create instance, must have appropriate VPC IaaS IAM policies"
  default = "" 
}

variable image {
  description = "Image ID to use for instance. `ic is images"
  default = "r014-b7da49af-b46a-4099-99a4-c183d2d40ea8" // ubuntu 20.04
}

variable region {
  description = "Region for the instance"
  default = "us-east"
}

variable resource_group {
  description = "Resource group name"
  default = "default"
}

variable zone {
  description = "The availability zone for the instance (must derived from region variable)"
  default = "us-east-1"
}
