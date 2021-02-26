
output "cluster_id" {
  value = ibm_container_vpc_cluster.cluster.id
}

output "vpc_id" { 
  value = ibm_is_vpc.vpc1.id
}

