

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

data "ibm_is_ssh_key" "key" {
    name = "jtpape"
}

resource "ibm_is_vpc" "vpc1" {
  name = "vpc-${random_id.name1.hex}"
}

resource "ibm_is_public_gateway" "testacc_gateway1" {
    name = "public-gateway1"
    vpc = ibm_is_vpc.vpc1.id
    zone = local.ZONE1
}

resource "ibm_is_public_gateway" "testacc_gateway2" {
    name = "public-gateway2"
    vpc = ibm_is_vpc.vpc1.id
    zone = local.ZONE2
}

resource "ibm_is_public_gateway" "testacc_gateway3" {
    name = "public-gateway3"
    vpc = ibm_is_vpc.vpc1.id
    zone = local.ZONE3
}

resource "ibm_is_security_group_rule" "testacc_security_group_rule_ssh" {
    group = ibm_is_vpc.vpc1.default_security_group
    direction = "inbound"
    tcp {
        port_min = 22
        port_max = 22
    }
 }

resource "ibm_is_security_group_rule" "testacc_security_group_rule_tcp" {
    group = ibm_is_vpc.vpc1.default_security_group
    direction = "inbound"
    tcp {
        port_min = 30000
        port_max = 32767
    }
 }

 resource "ibm_is_security_group_rule" "testacc_security_group_rule_udp" {
    group = ibm_is_vpc.vpc1.default_security_group
    direction = "inbound"
    udp {
        port_min = 30000
        port_max = 32767
    }
 }

 resource "ibm_is_security_group_rule" "testacc_security_group_rule_https" {
    group = ibm_is_vpc.vpc1.default_security_group
    direction = "inbound"
    tcp {
        port_min = 443
        port_max = 443
    }
 }



resource "ibm_is_subnet" "subnet1" {
  name                     = "subnet-${random_id.name1.hex}"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = local.ZONE1
  total_ipv4_address_count = 256
  public_gateway = ibm_is_public_gateway.testacc_gateway1.id
}

resource "ibm_is_subnet" "subnet2" {
  name                     = "subnet-${random_id.name2.hex}"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = local.ZONE2
  total_ipv4_address_count = 256
  public_gateway = ibm_is_public_gateway.testacc_gateway2.id
}

resource "ibm_is_subnet" "subnet3" {
  name                     = "subnet-${random_id.name3.hex}"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = local.ZONE3
  total_ipv4_address_count = 256
  public_gateway = ibm_is_public_gateway.testacc_gateway3.id
}

resource "ibm_is_instance" "bastion_host" {
  name    = "bastion-host"
  image   = "r014-b7da49af-b46a-4099-99a4-c183d2d40ea8"  //ubuntu 20.04
  profile = "bx2-2x8"

  primary_network_interface {
    subnet = ibm_is_subnet.subnet1.id
  }


  vpc  = ibm_is_vpc.vpc1.id
  zone = local.ZONE1
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


resource "ibm_is_instance" "sat-host-cp-1" {
  name    = "sat-host-cp-1"
  image   = "r014-931515d2-fcc3-11e9-896d-3baa2797200f"  //rhel7
  profile = "bx2-4x16"
  
  primary_network_interface {
    subnet = ibm_is_subnet.subnet1.id
  }


  vpc  = ibm_is_vpc.vpc1.id
  zone = local.ZONE1
  keys = [data.ibm_is_ssh_key.key.id]

 //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  depends_on = [data.ibm_is_ssh_key.key, ibm_is_subnet.subnet1]
}

resource "ibm_is_instance" "sat-host-cp-2" {
  name    = "sat-host-cp-2"
  image   = "r014-931515d2-fcc3-11e9-896d-3baa2797200f"  //rhel7
  profile = "bx2-4x16"


  primary_network_interface {
    subnet = ibm_is_subnet.subnet2.id
  }

  vpc  = ibm_is_vpc.vpc1.id
  zone = local.ZONE2
  keys = [data.ibm_is_ssh_key.key.id]

 //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  depends_on = [data.ibm_is_ssh_key.key, ibm_is_subnet.subnet2]
}

resource "ibm_is_instance" "sat-host-cp-3" {
  name    = "sat-host-cp-3"
  image   = "r014-931515d2-fcc3-11e9-896d-3baa2797200f"  //rhel7
  profile = "bx2-4x16"

  primary_network_interface {
    subnet = ibm_is_subnet.subnet3.id
  }


  vpc  = ibm_is_vpc.vpc1.id
  zone = local.ZONE3
  keys = [data.ibm_is_ssh_key.key.id]

 //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  depends_on = [data.ibm_is_ssh_key.key, ibm_is_subnet.subnet3]
}

resource "ibm_is_instance" "sat-host-cl-1" {
  name    = "sat-host-cl-1"
  image   = "r014-931515d2-fcc3-11e9-896d-3baa2797200f"  //rhel7
  profile = "bx2-4x16"

  primary_network_interface {
    subnet = ibm_is_subnet.subnet1.id
  }


  vpc  = ibm_is_vpc.vpc1.id
  zone = local.ZONE1
  keys = [data.ibm_is_ssh_key.key.id]

 //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  depends_on = [data.ibm_is_ssh_key.key, ibm_is_subnet.subnet1]
}

resource "ibm_is_instance" "sat-host-cl-2" {
  name    = "sat-host-cl-2"
  image   = "r014-931515d2-fcc3-11e9-896d-3baa2797200f"  //rhel7
  profile = "bx2-4x16"

  primary_network_interface {
    subnet = ibm_is_subnet.subnet2.id
  }


  vpc  = ibm_is_vpc.vpc1.id
  zone = local.ZONE2
  keys = [data.ibm_is_ssh_key.key.id]

 //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  depends_on = [data.ibm_is_ssh_key.key, ibm_is_subnet.subnet2]
}

resource "ibm_is_instance" "sat-host-cl-3" {
  name    = "sat-host-cl-3"
  image   = "r014-931515d2-fcc3-11e9-896d-3baa2797200f"  //rhel7
  profile = "bx2-4x16"

  primary_network_interface {
    subnet = ibm_is_subnet.subnet3.id
  }


  vpc  = ibm_is_vpc.vpc1.id
  zone = local.ZONE3
  keys = [data.ibm_is_ssh_key.key.id]

 //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  depends_on = [data.ibm_is_ssh_key.key, ibm_is_subnet.subnet3]
}