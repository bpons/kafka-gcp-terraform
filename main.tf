provider "google" {
  credentials = "${file("test-kafka-tf-201909-680fab95621e.json")}"
  project     = "test-kafka-tf-201909"
}
