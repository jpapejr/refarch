variable "sl_api_key" {
    default = "" 
}

variable "sl_user" {
    default = ""
}


variable "cluster_node_flavor" {
    default = "b3c.16x64"
}

variable "cluster_kube_version" {
    default = "4.5_openshift"
}

variable "worker_count"{
    default = "3"
}

variable "zone" {
  default = ""
}

variable "resource_group" {
  default = "default"
}

variable "cluster_name" {
  default = "cluster-roks-on-classic"
}


variable "entitlement"{
  default = ""
}

//Variable required for content catalog to select terraform version
variable "TF_VERSION" {
  type = string
  description = "The version of terraform that should be used"
  default = "0.12"
}