resource "google_compute_instance" "zoonavigator" {
  name         = "zoonavigator"
  machine_type = "g1-small"
  zone         = "${var.zones[0]}"
  tags         = ["ssh", "http-server"]

  boot_disk {
    initialize_params {
      image = "gce-uefi-images/cos-stable"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kafka-subnet.self_link}"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<SCRIPT
echo '10.1.1.11 zoo1
10.1.1.12 zoo2
10.1.1.13 zoo3' | sudo tee --append /etc/hosts
docker run -d -p 80:9000 -e HTTP_PORT=9000 --name zoonavigator --restart unless-stopped elkozmon/zoonavigator:latest
SCRIPT
}
