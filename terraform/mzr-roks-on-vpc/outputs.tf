
output "cos_instance_crn" {
  value = ibm_resource_instance.cos_instance.id
}

output "cluster_id" {
  value = ibm_container_vpc_cluster.cluster.id
}