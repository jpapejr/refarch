resource "random_id" "name1" {
  byte_length = 2
}

resource "random_id" "name2" {
  byte_length = 2
}

resource "random_id" "name3" {
  byte_length = 2
}


resource "ibm_network_vlan" "public_vlan" {
   name = "public-vlan-${random_id.name1.hex}"
   datacenter = var.zone
   type = "PUBLIC"
   router_hostname = "fcr01a.${var.zone}"
}

resource "ibm_network_vlan" "private_vlan" {
   name = "private-vlan-${random_id.name1.hex}"
   datacenter = var.zone
   type = "PRIVATE"
   router_hostname = "bcr01a.${var.zone}"
}

data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

resource "ibm_container_cluster" "cluster" {
  name                 = "${var.cluster_name}-${random_id.name1.hex}"
  datacenter           = var.zone
  default_pool_size    = var.worker_count
  machine_type         = var.cluster_node_flavor
  hardware             = "shared"
  kube_version         = var.cluster_kube_version
  public_vlan_id       = ibm_network_vlan.public_vlan.id
  private_vlan_id      = ibm_network_vlan.private_vlan.id
  force_delete_storage = true
  wait_till            = "OneWorkerNodeReady"

}
