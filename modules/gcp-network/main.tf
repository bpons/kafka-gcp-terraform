resource "google_compute_network" "kafka_vpc" {
  name                    = "kafka-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kafka_subnet" {
  name          = "kafka-subnet"
  ip_cidr_range = "10.1.1.0/24"
  region        = "${var.clusters_region}"
  network       = "${google_compute_network.kafka_vpc.self_link}"
}

resource "google_compute_subnetwork" "management_subnet" {
  name          = "management-subnet"
  ip_cidr_range = "10.1.2.0/24"
  region        = "${var.management_region}"
  network       = "${google_compute_network.kafka_vpc.self_link}"
}

resource "google_compute_subnetwork" "monitoring_subnet" {
  name          = "monitoring-subnet"
  ip_cidr_range = "10.1.3.0/24"
  region        = "${var.monitoring_region}"
  network       = "${google_compute_network.kafka_vpc.self_link}"
}

resource "google_compute_firewall" "allow-internal" {
  name    = "${google_compute_network.kafka_vpc.name}-allow-internal"
  network = "${google_compute_network.kafka_vpc.name}"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = [
    "${google_compute_subnetwork.kafka_subnet.ip_cidr_range}",
    "${google_compute_subnetwork.management_subnet.ip_cidr_range}",
    "${google_compute_subnetwork.monitoring_subnet.ip_cidr_range}"
   ]
}
resource "google_compute_firewall" "allow-ssh" {
  name    = "${google_compute_network.kafka_vpc.name}-allow-ssh"
  network = "${google_compute_network.kafka_vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}

resource "google_compute_firewall" "allow-http" {
  name    = "${google_compute_network.kafka_vpc.name}-allow-http"
  network = "${google_compute_network.kafka_vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["80", "3000"]
  }
  target_tags = ["http-server"]
}