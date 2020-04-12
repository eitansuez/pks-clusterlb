terraform {
  required_version = ">= 0.12.0"
}

variable "project" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "service_account_key" {
  type = string
}

variable "hosted_zone" {
  description = "Hosted zone name (e.g. foo is the zone name and foo.example.com is the DNS name)."
}

variable "network_name" {
  type = string
}

provider "google" {
  project     = var.project
  region      = var.region
  credentials = var.service_account_key
}

resource "google_compute_address" "pks-cluster-lb-ip" {
  name = "${var.cluster_name}-lb-ip"
}

resource "google_compute_forwarding_rule" "pks-cluster-lb-8443" {
  name        = "${var.cluster_name}-lb-8443"
  ip_address  = google_compute_address.pks-cluster-lb-ip.address
  target      = google_compute_target_pool.pks-cluster-lb.self_link
  port_range  = "8443"
  ip_protocol = "TCP"
}

resource "google_compute_target_pool" "pks-cluster-lb" {
  name = "${var.cluster_name}-lb"
}

data "google_dns_managed_zone" "hosted-zone" {
  name = var.hosted_zone
}

data "google_compute_network" "network" {
  name = var.network_name
}

resource "google_dns_record_set" "pks-cluster" {
    name = "${var.cluster_name}.${data.google_dns_managed_zone.hosted-zone.dns_name}"
    type = "A"
    ttl = 300

    managed_zone = var.hosted_zone
    
    rrdatas = [google_compute_address.pks-cluster-lb-ip.address]
}

resource "google_compute_firewall" "pks-cluster-lb" {
  name    = "${var.cluster_name}-lb-firewall"
  network = data.google_compute_network.network.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }

  target_tags = ["${var.cluster_name}-lb"]
}

locals {
  stable_config = {
    cluster_name        = var.cluster_name
    pks_cluster_target_pool_name = google_compute_target_pool.pks-cluster-lb.name
    pks_cluster_dns_domain       = replace(replace(google_dns_record_set.pks-cluster.name, "/\\.$/", ""), "*.", "")
    pks_cluster_target_tag       = "${var.cluster_name}-lb"
  }
}

output "stable_config" {
  value     = jsonencode(local.stable_config)
  sensitive = true
}
