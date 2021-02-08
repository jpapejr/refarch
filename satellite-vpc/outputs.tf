output "vpc" {
  value = ibm_is_vpc.vpc1.name
}

output "cp-1" {
  value = ibm_is_instance.sat-host-cp-1.primary_network_interface.primary_ipv4_address[0]
}

output "cp-2" {
  value = ibm_is_instance.sat-host-cp-2.primary_network_interface.primary_ipv4_address[0]
}

output "cp-3" {
  value = ibm_is_instance.sat-host-cp-3.primary_network_interface.primary_ipv4_address[0]
}

output "cl-1" {
  value = ibm_is_instance.sat-host-cl-1.primary_network_interface.primary_ipv4_address[0]
}

output "cl-2" {
  value = ibm_is_instance.sat-host-cl-2.primary_network_interface.primary_ipv4_address[0]
}

output "cl-3" {
  value = ibm_is_instance.sat-host-cl-3.primary_network_interface.primary_ipv4_address[0]
}