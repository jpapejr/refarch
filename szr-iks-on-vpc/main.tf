resource "random_id" "name1" {
  byte_length = 2
}

resource "random_id" "name2" {
  byte_length = 2
}

resource "random_id" "name3" {
  byte_length = 2
}

locals {
  ZONE1 = "${var.region}-1"
  ZONE2 = "${var.region}-2"
  ZONE3 = "${var.region}-3"
}

data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

resource "ibm_is_vpc" "vpc1" {
  name           = "${var.token}-vpc-${random_id.name1.hex}"
  resource_group = data.ibm_resource_group.resource_group.id
  classic_access = var.classic_access
}

resource "ibm_is_public_gateway" "testacc_gateway1" {
    name = "${var.token}-public-gateway1"
    vpc = ibm_is_vpc.vpc1.id
    zone = local.ZONE1
}

resource "ibm_is_public_gateway" "testacc_gateway2" {
    name = "${var.token}-public-gateway2"
    vpc = ibm_is_vpc.vpc1.id
    zone = local.ZONE2
}

resource "ibm_is_public_gateway" "testacc_gateway3" {
    name = "${var.token}-public-gateway3"
    vpc = ibm_is_vpc.vpc1.id
    zone = local.ZONE3
}

resource "ibm_is_subnet" "subnet1" {
  name                     = "${var.token}-subnet-${random_id.name1.hex}"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = local.ZONE1
  total_ipv4_address_count = 256
  public_gateway = ibm_is_public_gateway.testacc_gateway1.id
}

resource "ibm_is_subnet" "subnet2" {
  name                     = "${var.token}-subnet-${random_id.name2.hex}"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = local.ZONE2
  total_ipv4_address_count = 256
  public_gateway = ibm_is_public_gateway.testacc_gateway2.id
}

resource "ibm_is_subnet" "subnet3" {
  name                     = "${var.token}-subnet-${random_id.name3.hex}"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = local.ZONE3
  total_ipv4_address_count = 256
  public_gateway = ibm_is_public_gateway.testacc_gateway3.id
}

resource "ibm_container_vpc_cluster" "cluster" {
  name                            = "${var.token}-${var.cluster_name}-${random_id.name1.hex}"
  vpc_id                          = ibm_is_vpc.vpc1.id
  kube_version                    = var.cluster_kube_version
  flavor                          = var.cluster_node_flavor
  worker_count                    = var.worker_count
  resource_group_id               = data.ibm_resource_group.resource_group.id
  disable_public_service_endpoint = var.disable_public_se
  pod_subnet                      = var.pod_subnet
  service_subnet                  = var.service_subnet
  force_delete_storage            = true
  wait_till                       = "OneWorkerNodeReady"

  zones {
    subnet_id = ibm_is_subnet.subnet1.id
    name      = local.ZONE1
  }


}

