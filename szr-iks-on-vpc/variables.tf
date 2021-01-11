variable "ibmcloud_api_key" {
    default = "" 
}



variable "cluster_node_flavor" {
    default = "bx2.16x64"
}

variable "cluster_kube_version" {
    default = "1.19"
}

variable "worker_count"{
    default = "2"
}

variable "region" {
  default = "us-east"
}

variable "resource_group" {
  default = "default"
}

variable "cluster_name" {
  default = "cluster-iks-on-vpc"
}


//Variable required for content catalog to select terraform version
variable "TF_VERSION" {
  type = string
  description = "The version of terraform that should be used"
  default = "0.12"
}