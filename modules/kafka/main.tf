resource "google_compute_disk" "kafka-data-disk" {
  count                     = "${var.servers}"
  name                      = "kafka-data-disk-${count.index + 1}"
  type                      = "pd-ssd"
  size                      = "10"
  zone                      = "${var.zones[count.index]}"
  physical_block_size_bytes = 4096
}

data "template_file" "kafka_startup" {
  count    = "${var.servers}"
  template = "${file("${path.module}/scripts/kafka-startup.sh")}"
  vars = {
    broker_id = "${count.index + 1}"
  }
}

resource "google_compute_instance" "kafka-broker" {
  count        = "${var.servers}"
  name         = "kafka${count.index + 1}"
  machine_type = "n1-standard-2"
  zone         = "${var.zones[count.index]}"
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "packer-kafka"
    }
  }

  network_interface {
    subnetwork = "${var.subnet}"
  }

  metadata = {
    VmDnsSetting = "GlobalOnly"
  }

  metadata_startup_script = "${element(data.template_file.kafka_startup.*.rendered, count.index)}"
  
  lifecycle {
    ignore_changes = ["attached_disk"]
  }

  depends_on = ["var.zookeeper_up"]
  
}

resource "google_compute_attached_disk" "default" {
  count    = "${var.servers}"
  disk     = "${element(google_compute_disk.kafka-data-disk.*.self_link, count.index)}"
  instance = "${element(google_compute_instance.kafka-broker.*.self_link, count.index)}"
}
