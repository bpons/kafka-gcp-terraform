output "cluster_up" {
  value = "${element(google_compute_instance.zookeeper.*.self_link, var.servers - 1)}"
}
