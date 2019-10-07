output "kafka_vpc" {
  value       = "${google_compute_network.kafka_vpc.self_link}"
}
output "kafka_subnet" {
  value       = "${google_compute_subnetwork.kafka_subnet.self_link}"
}
output "management_subnet" {
  value       = "${google_compute_subnetwork.management_subnet.self_link}"
}