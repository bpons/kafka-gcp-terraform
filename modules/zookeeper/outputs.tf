output "cluster_up" {
  value = "${length(google_compute_instance.zookeeper.*.self_link) == var.servers}"
}
