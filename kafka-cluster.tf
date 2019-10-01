variable "brokers_count" {
  default = 3
}

resource "google_compute_disk" "kafka-data-disk" {
  count                     = "${var.brokers_count}"
  name                      = "kafka-data-disk-${count.index + 1}"
  type                      = "pd-ssd"
  size                      = "10"
  zone                      = "${var.zones[count.index]}"
  physical_block_size_bytes = 4096
}

data "template_file" "kafka_startup" {
  count    = "${var.brokers_count}"
  template = "${file("${path.module}/scripts/kafka-startup.sh")}"
  vars = {
    broker_id = "${count.index + 1}"
  }
}

resource "google_compute_instance" "kafka-broker" {
  count        = "${var.brokers_count}"
  name         = "kafka${count.index + 1}"
  machine_type = "n1-standard-1"
  zone         = "${var.zones[count.index]}"
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "packer-kafka"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kafka-subnet.self_link}"
    network_ip = "10.1.1.${count.index + 21}"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = "${element(data.template_file.kafka_startup.*.rendered, count.index)}"

  depends_on = ["google_compute_instance.zookeeper"]
}

resource "google_compute_attached_disk" "default" {
  count    = "${var.brokers_count}"
  disk     = "${element(google_compute_disk.kafka-data-disk.*.self_link, count.index)}"
  instance = "${element(google_compute_instance.kafka-broker.*.self_link, count.index)}"
}
