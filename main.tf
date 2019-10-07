provider "google" {
  credentials = "${file("test-kafka-tf-201909-680fab95621e.json")}"
  project     = "test-kafka-tf-201909"
}

module "network" {
  source = "./modules/gcp-network"
  clusters_region = "${var.clusters_region}"
  management_region = "${var.management_region}"
}

module "zookeeper" {
  source = "./modules/zookeeper"
  servers = "3"
  subnet = "${module.network.kafka_subnet}"
  zones = "${var.clusters_zones}"
}

module "kafka" {
  source = "./modules/kafka"
  servers = 3
  subnet = "${module.network.kafka_subnet}"
  zones = "${var.clusters_zones}"
  zookeeper_up = "${module.zookeeper.cluster_up}"
}

module "management" {
  source = "./modules/management"
  subnet = "${module.network.management_subnet}"
  zone = "${var.management_zone}"
}