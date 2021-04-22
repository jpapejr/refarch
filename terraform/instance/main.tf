data ibm_resource_group resource_group {
  name = var.resource_group
}

data ibm_is_ssh_key key {
    name = "jtpape"
}

data ibm_is_vpc vpc1 {
  name = var.vpc
}

resource ibm_is_instance instance {
  name           = var.instance_name
  image          = "r014-b7da49af-b46a-4099-99a4-c183d2d40ea8"
  profile        = var.profile
  resource_group = data.ibm_resource_group.resource_group

  primary_network_interface {
    subnet = var.subnet_id
  }

  vpc  = data.ibm_is_vpc.vpc1.id
  zone = var.zone
  keys = [data.ibm_is_ssh_key.key.id]

 //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

}

resource ibm_is_floating_ip fip {
  name           = "${var.instance_name}-fip"
  target         = ibm_is_instance.instance.primary_network_interface.0.id
  resource_group = data.ibm_resource_group.resource_group
  depends_on     = [ibm_is_instance.instance]
}
