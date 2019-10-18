variable "clusters_region" {
    type    = string
    default = "europe-west1"
}

variable "clusters_zones" {
    type    = list
    default = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
}

variable "management_region" {
    type    = string
    default = "europe-west3"
}

variable "management_zone" {
    type    = string
    default = "europe-west3-a"
}

variable "monitoring_region" {
    type    = string
    default = "europe-west3"
}

variable "monitoring_zone" {
    type    = string
    default = "europe-west3-b"
}