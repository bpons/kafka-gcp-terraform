variable "zk_instances_count" {
  default = 3
}
data "template_file" "zk_startup" {
  count    = "${var.zk_instances_count}"
  template = "${file("${path.module}/scripts/zk-startup.sh")}"
  vars = {
    id = "${count.index + 1}"
  }
}
resource "google_compute_instance" "zookeeper" {
  count        = "${var.zk_instances_count}"
  name         = "zoo${count.index + 1}"
  machine_type = "n1-standard-1"
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

  metadata = {
    VmDnsSetting = "GlobalOnly"
  }
  
  metadata_startup_script = "${element(data.template_file.zk_startup.*.rendered, count.index)}"

}