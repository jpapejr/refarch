output "vpc" {
  value = ibm_is_vpc.vpc1.name
}

output "bastion_fip" {
  value = ibm_is_floating_ip.fip.address
}

output "cp-1" {
  value = ibm_is_instance.sat-host-cp-1.primary_network_interface[0].primary_ipv4_address
}

output "cp-2" {
  value = ibm_is_instance.sat-host-cp-2.primary_network_interface[0].primary_ipv4_address
}

output "cp-3" {
  value = ibm_is_instance.sat-host-cp-3.primary_network_interface[0].primary_ipv4_address
}

output "cl-1" {
  value = ibm_is_instance.sat-host-cl-1.primary_network_interface[0].primary_ipv4_address
}

output "cl-2" {
  value = ibm_is_instance.sat-host-cl-2.primary_network_interface[0].primary_ipv4_address
}

output "cl-3" {
  value = ibm_is_instance.sat-host-cl-3.primary_network_interface[0].primary_ipv4_address
}