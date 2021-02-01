resource "ibm_resource_instance" "cos_instance" {
  name     = var.cos_service_name
  service  = "cloud-object-storage"
  plan     = var.cos_service_plan
  location = "global"
}

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

resource "ibm_is_vpc" "vpc1" {
  name = "vpc-${random_id.name1.hex}"
}

resource "ibm_is_security_group_rule" "testacc_security_group_rule_tcp" {
    group = ibm_is_vpc.vpc1.default_security_group
    direction = "inbound"
    tcp {
        port_min = 30000
        port_max = 32767
    }
 }

resource "ibm_is_security_group_rule" "testacc_security_group_rule_ssh" {
    group = ibm_is_vpc.vpc1.default_security_group
    direction = "inbound"
    tcp {
        port_min = 22
        port_max = 22
    }
 }

resource "ibm_is_security_group_rule" "testacc_security_group_rule_squid" {
    group = ibm_is_vpc.vpc1.default_security_group
    direction = "inbound"
    tcp {
        port_min = 3128
        port_max = 3128
    }
 }

resource "ibm_is_subnet" "subnet1" {
  name                     = "subnet-${random_id.name1.hex}"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = local.ZONE1
  total_ipv4_address_count = 256
  
}

resource "ibm_is_subnet" "subnet2" {
  name                     = "subnet-${random_id.name2.hex}"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = local.ZONE2
  total_ipv4_address_count = 256
  
}

resource "ibm_is_subnet" "subnet3" {
  name                     = "subnet-${random_id.name3.hex}"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = local.ZONE3
  total_ipv4_address_count = 256
  
}

data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

resource "ibm_container_vpc_cluster" "cluster" {
  name                            = "${var.cluster_name}-${random_id.name1.hex}"
  vpc_id                          = ibm_is_vpc.vpc1.id
  kube_version                    = var.cluster_kube_version
  flavor                          = var.cluster_node_flavor
  worker_count                    = var.worker_count
  resource_group_id               = data.ibm_resource_group.resource_group.id
  entitlement                     = var.entitlement
  cos_instance_crn                = ibm_resource_instance.cos_instance.id
  force_delete_storage            = true
  disable_public_service_endpoint = true
  wait_till                       = "OneWorkerNodeReady"

  zones {
    subnet_id = ibm_is_subnet.subnet1.id
    name      = local.ZONE1
  }


}

data "ibm_is_ssh_key" "key" {
    name = "jtpape"
}

resource "ibm_is_instance" "bastion_host" {
  name    = "bastion-host"
  image   = "r014-b7da49af-b46a-4099-99a4-c183d2d40ea8"  //ubuntu 20.04
  profile = "bx2-2x8"

  primary_network_interface {
    subnet = ibm_is_subnet.subnet1.id
  }


  vpc  = ibm_is_vpc.vpc1.id
  zone = "us-east-1"
  keys = [data.ibm_is_ssh_key.key.id]

 //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  depends_on = [data.ibm_is_ssh_key.key, ibm_is_subnet.subnet1]
}

resource "ibm_is_instance" "bastion_host2" {
  name    = "bastion-host-2"
  image   = "r014-b7da49af-b46a-4099-99a4-c183d2d40ea8"  //ubuntu 20.04
  profile = "bx2-2x8"

  primary_network_interface {
    subnet = ibm_is_subnet.subnet1.id
  }


  vpc  = ibm_is_vpc.vpc1.id
  zone = "us-east-1"
  keys = [data.ibm_is_ssh_key.key.id]

 //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  depends_on = [data.ibm_is_ssh_key.key, ibm_is_subnet.subnet1]
}

resource "ibm_is_floating_ip" "fip" {
  name       = "bastion-fip"
  target     = ibm_is_instance.bastion_host.primary_network_interface.0.id
  depends_on = [ibm_is_instance.bastion_host]
}


