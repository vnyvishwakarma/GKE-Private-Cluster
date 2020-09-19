
#Fetching gke version from available 
data "google_container_engine_versions" "gkeversion" {   
  location           = var.region_name   
	project            = var.project_name
 }

#Customize Node-pool
resource "google_container_node_pool" "this" {
  name       = "${var.env}-${var.project_name}-k8s-node-pool"
  location   = var.zone_name
  cluster    = google_container_cluster.primary.name
  project    = var.project_name
  node_count = var.node_count
  # version    = data.google_container_engine_versions.gkeversion.latest_node_version
  autoscaling {
    min_node_count = var.min_node
    max_node_count = var.max_node
  }
  node_config {
    # machine_type = var.node_machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
  depends_on = [google_container_cluster.primary]
}

#Customer Master Node
resource "google_container_cluster" "primary" {
  name                     = "${var.env}-${var.project_name}-k8s-gke"
  location                 = var.zone_name
  project                  = var.project_name
  network                  = google_compute_network.k8-vpc.name
  subnetwork               = google_compute_subnetwork.k8-private-ip-range.name
  monitoring_service      = "monitoring.googleapis.com/kubernetes" 
  logging_service         = "logging.googleapis.com/kubernetes"
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name = "pod-range"
    services_secondary_range_name = "service-range"
  }

  maintenance_policy {     
    daily_maintenance_window {       
      start_time = "03:00"     
    }   
  }

  private_cluster_config {     
  enable_private_endpoint = true     
  enable_private_nodes = true     
  master_ipv4_cidr_block = var.master_cidr   
  }

  master_auth {
    username = ""
    password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  master_authorized_networks_config {}

  
  
}

#NOTE: Calling subnet and network names via datasource as cluster and network are in different modules.