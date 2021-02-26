terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~> 1.19.0"
    }
  }
}

provider "ibm" {
  generation = 2
  region = var.region
  ibmcloud_api_key = var.ibmcloud_api_key
}
