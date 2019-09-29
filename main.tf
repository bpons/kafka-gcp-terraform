provider "google" {
  credentials = "${file("test-kafka-tf-201909-680fab95621e.json")}"
  project     = "test-kafka-tf-201909"
}

variable "instances_count" {
  default = 3
}
data "template_file" "startup" {
  count = "${var.instances_count}"
  template = "${file("${path.module}/scripts/startup.sh")}"
  vars = {
    id = "${count.index + 1}"
  }
}
resource "google_compute_instance" "zookeeper" {
  count        = "${var.instances_count}"
  name         = "zoo${count.index + 1}"
  machine_type = "f1-micro"
  zone         = "${var.zones[count.index]}"
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "packer-zoo"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kafka-subnet.self_link}"
    network_ip = "10.1.1.${count.index + 11}"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = "${element(data.template_file.startup.*.rendered, count.index)}"

}

