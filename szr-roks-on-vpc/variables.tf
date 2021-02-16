variable "ibmcloud_api_key" {
    default = "" 
}

variable "cos_service_name" {
    default = "myservice"
}

variable "cos_service_plan" {
    default = "standard"
}

variable "cluster_node_flavor" {
    default = "bx2.16x64"
}

variable "cluster_kube_version" {
    default = "4.5_openshift"
}

variable "worker_count"{
    default = "2"
}

variable "region" {
  default = "us-east"
}

variable "resource_group" {
  default = "Default"
}

variable "cluster_name" {
  default = "cluster-roks-on-vpc"
}

variable "entitlement"{
  default = ""
}

variable "token" {
  default = "jtp"
}

variable "pod_subnet" {
  default = "172.30.0.0/16"
}

variable "service_subnet" {
  default = "172.21.0.0/16"
}

variable "classic_access" {
    default = false
}

variable "disable_public_se" {
  default = false
}

//Variable required for content catalog to select terraform version
variable "TF_VERSION" {
  type = string
  description = "The version of terraform that should be used"
  default = "0.12"
}