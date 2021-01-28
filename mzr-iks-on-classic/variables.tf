variable "sl_api_key" {
    default = "" 
}

variable "ibmcloud_api_key" {
    default = ""
}

variable "sl_user" {
    default = ""
}


variable "cluster_node_flavor" {
    default = "b3c.4x16"
}

variable "cluster_kube_version" {
    default = "1.19"
}

variable "worker_count"{
    default = "3"
}

variable "resource_group" {
  default = "default"
}

variable "cluster_name" {
  default = "mzr-cluster-iks-on-classic"
}




//Variable required for content catalog to select terraform version
variable "TF_VERSION" {
  type = string
  description = "The version of terraform that should be used"
  default = "0.12"
}
