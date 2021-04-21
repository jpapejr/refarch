output vpc {
  value = ibm_is_vpc.vpc1.name
}

output instance-floating-ip {
  value = ibm_is_floating_ip.fip.address
}

output instance_id {
  value = ibm_is_instance.instance.id
}
