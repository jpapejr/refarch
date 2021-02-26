terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~> 1.19.0"
    }
  }
}

provider "ibm" {
  iaas_classic_username = var.sl_user
  iaas_classic_api_key = var.sl_api_key
  ibmcloud_api_key     = var.ibmcloud_api_key
}
