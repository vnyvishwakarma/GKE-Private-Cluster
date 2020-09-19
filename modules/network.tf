

#Creating VPC
resource "google_compute_network" "k8-vpc" {
  name                    = "${var.prefix}-${var.env}-k8s-vpc"
  auto_create_subnetworks = false
  project                 = var.project_name
}


#Incase you want to create subnets in all regions then use "auto_create_subnetworks" as true in "google_compute_network" resource and if not then 
#add below resources.....
resource "google_compute_subnetwork" "k8-private-ip-range" {
  name          = "${var.prefix}-${var.env}-k8s-vpc"
  ip_cidr_range = var.cidr_range
  region        = var.region_name
  network       = google_compute_network.k8-vpc.id
  project       = var.project_name
  # Adding Secondary IP range for pods and services.
  secondary_ip_range = [
    {
      range_name    = "pod-range"
      ip_cidr_range = var.cluster_secondary_range
    },
    {
      range_name    = "service-range"
      ip_cidr_range = var.cluster_service_range
    }
  ]

}


#Creating Router to attach to Cloud NAT-GW
resource "google_compute_router" "k8-router" {
  name    = "${var.prefix}-${var.env}-k8s-router"
  region  = var.region_name
  project = var.project_name
  network = google_compute_network.k8-vpc.id
}

# Cloud Nat-GW attach to subnet
resource "google_compute_router_nat" "k8-nat" {
  name                               = "${var.prefix}-${var.env}-k8s-router-nat"
  router                             = google_compute_router.k8-router.name
  region                             = var.region_name
  project                            = var.project_name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

}
