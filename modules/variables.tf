variable "project_name" {
    type = string
    default = "ros-project-287920"
}

variable "prefix" {
    type = string
    default = "vny"
}


variable "env" {
    type = string
    default = "dev"
}

variable "region_name" {
    type = string
    default = "europe-west2"
}

variable "node_machine_type" {
    type = string
    default = "ec2-medium"
}

variable "master_machine_type" {
    type = string
    default = "ec2-medium"
}

variable "zone_name" {
    type = string
    default = "europe-west2-a"
}

variable "node_count" {
    type = number
    default = 1
}

variable "min_node" {
    type = number
    default = 1
}
variable "max_node" {
    type = number
    default = 3
}

variable "cidr_range" {
    type = string
    default = "10.0.0.0/16"
}

variable "cluster_secondary_range" {
    type = string
    default = "192.168.0.0/21"
}

variable "cluster_service_range" {
    type = string
    default = "192.168.8.0/21"
}

variable "master_cidr" {
    type = string
    default = "172.16.0.0/28"
}