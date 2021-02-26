
output "public_vlan" {
  value = ibm_network_vlan.public_vlan.id
}

output "private_vlan" {
  value = ibm_network_vlan.private_vlan.id
}

output "cluster_id" {
  value = ibm_container_cluster.cluster.id
}