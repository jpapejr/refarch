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
   datacenter = "wdc04"
   type = "PUBLIC"
   router_hostname = "fcr01a.wdc04"
}

resource "ibm_network_vlan" "private_vlan" {
   name = "private-vlan-${random_id.name1.hex}"
   datacenter = "wdc04"
   type = "PRIVATE"
   router_hostname = "bcr01a.wdc04"
}

resource "ibm_network_vlan" "public_vlan2" {
   name = "public-vlan-${random_id.name1.hex}"
   datacenter = "wdc06"
   type = "PUBLIC"
   router_hostname = "fcr01a.wdc06"
}

resource "ibm_network_vlan" "private_vlan2" {
   name = "private-vlan-${random_id.name1.hex}"
   datacenter = "wdc06"
   type = "PRIVATE"
   router_hostname = "bcr01a.wdc06"
}

resource "ibm_network_vlan" "public_vlan3" {
   name = "public-vlan-${random_id.name1.hex}"
   datacenter = "wdc07"
   type = "PUBLIC"
   router_hostname = "fcr01a.wdc07"
}

resource "ibm_network_vlan" "private_vlan3" {
   name = "private-vlan-${random_id.name1.hex}"
   datacenter = "wdc07"
   type = "PRIVATE"
   router_hostname = "bcr01a.wdc07"
}


data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

resource "ibm_container_cluster" "cluster" {
  name                 = "${var.cluster_name}-${random_id.name1.hex}"
  datacenter           = "wdc04"
  default_pool_size    = var.worker_count
  machine_type         = var.cluster_node_flavor
  hardware             = "shared"
  kube_version         = var.cluster_kube_version
  public_vlan_id       = ibm_network_vlan.public_vlan.id
  private_vlan_id      = ibm_network_vlan.private_vlan.id
  force_delete_storage = true

}

resource "ibm_container_worker_pool" "pool2" {
  worker_pool_name = "default2"
  machine_type     = var.cluster_node_flavor
  cluster          = "${var.cluster_name}-${random_id.name1.hex}"
  size_per_zone    = var.worker_count
  hardware         = "shared"
  disk_encryption  = "true"
  
}
resource "ibm_container_worker_pool_zone_attachment" "pool2_za" {
  cluster         = "${var.cluster_name}-${random_id.name1.hex}"
  worker_pool     = element(split("/",ibm_container_worker_pool.pool2.id),1)
  zone            = "wdc06"
  private_vlan_id = ibm_network_vlan.private_vlan2.id
  public_vlan_id  = ibm_network_vlan.public_vlan2.id

  //User can increase timeouts
  timeouts {
      create = "90m"
      update = "3h"
      delete = "30m"
    }
}

resource "ibm_container_worker_pool" "pool3" {
  worker_pool_name = "default3"
  machine_type     = var.cluster_node_flavor
  cluster          = "${var.cluster_name}-${random_id.name1.hex}"
  size_per_zone    = var.worker_count
  hardware         = "shared"
  disk_encryption  = "true"
  
}
resource "ibm_container_worker_pool_zone_attachment" "pool3_za" {
  cluster         = "${var.cluster_name}-${random_id.name1.hex}"
  worker_pool     = element(split("/",ibm_container_worker_pool.pool3.id),1)
  zone            = "wdc07"
  private_vlan_id = ibm_network_vlan.private_vlan3.id
  public_vlan_id  = ibm_network_vlan.public_vlan3.id

  //User can increase timeouts
  timeouts {
      create = "90m"
      update = "3h"
      delete = "30m"
    }
}
