resource "google_compute_instance" "influxdb" {
  name         = "influxdb"
  machine_type = "n1-standard-2"
  zone         = "${var.zone}"
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "packer-influxdb"
    }
  }

  network_interface {
    subnetwork = "${var.subnet}"
  }

  metadata = {
    VmDnsSetting = "GlobalOnly"
  }

  metadata_startup_script = "${file("${path.module}/scripts/influxdb-startup.sh")}"
  
}

resource "google_compute_instance" "grafana" {
  name         = "grafana"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  tags         = ["ssh", "http-server"]

  boot_disk {
    initialize_params {
      image = "packer-grafana"
    }
  }

  network_interface {
    subnetwork = "${var.subnet}"
    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    VmDnsSetting = "GlobalOnly"
  }

  metadata_startup_script = "${file("${path.module}/scripts/grafana-startup.sh")}"
  
}

output "grafana_instance" {
  value = "${google_compute_instance.grafana}"
}
provider "grafana" {
  url  = "http://${google_compute_instance.grafana.network_interface.0.access_config.0.nat_ip}:3000/"
  auth = "admin:password"
}

resource "grafana_data_source" "influxdb" {
  type          = "influxdb"
  name          = "influxdb"
  url           = "http://influxdb:8086/"
  username      = "telegraf_user"
  password      = "password"
  database_name = "telegraf_db"
  depends_on    = ["google_compute_instance.grafana"]
}

resource "grafana_dashboard" "telegraf" {
  config_json = "${file("${path.module}/files/telegraf.json")}"
  depends_on = ["grafana_data_source.influxdb"]
}

resource "grafana_dashboard" "jvm" {
  config_json = "${file("${path.module}/files/jvm.json")}"
  depends_on = ["grafana_data_source.influxdb"]
}
