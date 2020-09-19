provider "google" {

  credentials = file("config.json")
  project     = "ros-project-287920"
  region      = "europe-west2"
  
}