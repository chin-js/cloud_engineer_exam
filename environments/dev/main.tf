  /******************************************
  CIS_Google_Cloud_Platform_Foundation_Benchmark_v3.0.0
  3 Networking
  [/] 3.1 Ensure That the Default Network Does Not Exist in a Project
  [/] 3.2 Ensure Legacy Networks Do Not Exist for Older Projects
  [/] 3.6 Ensure That SSH Access Is Restricted From the Internet
  [/] 3.7 Ensure That RDP Access Is Restricted From the Internet
  [/] 3.8 Ensure that VPC Flow Logs is Enabled for Every Subnet in a VPC Network
  [/] 3.10 Use Identity Aware Proxy (IAP) to Ensure Only Traffic From Google IP Addresses are 'Allowed' 

  4 Virtual Machines
  [/] 4.1 Ensure That Instances Are Not Configured To Use the Default Service Account
  [/] 4.2 Ensure That Instances Are Not Configured To Use the Default Service Account With Full Access to All Cloud APIs
  [/] 4.5 Ensure ‘Enable Connecting to Serial Ports’ Is Not Enabled for VM Instance
  [/] 4.6 Ensure That IP Forwarding Is Not Enabled on Instances
  [/] 4.8 Ensure Compute Instances Are Launched With Shielded VM Enabled (Automated)
  [/] 4.9 Ensure That Compute Instances Do Not Have Public IP Addresses (Automated)

  5 Storage
  [/] 5.1 Ensure That Cloud Storage Bucket Is Not Anonymously or Publicly Accessible
  [/] 5.2 Ensure That Cloud Storage Buckets Have Uniform BucketLevel Access Enabled
/******************************************

/******************************************
	Enable GCP APIs
 *****************************************/
module "enable_apis" {
  source     = "../../modules/project/project_services"
  project_id = var.project_id
  apis = [
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "dns.googleapis.com",
    "iap.googleapis.com",
    "networkmanagement.googleapis.com",
    "redis.googleapis.com",
    "serviceconsumermanagement.googleapis.com",
    "networkconnectivity.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "container.googleapis.com"
  ]
}

/******************************************
	VPC configuration
 *****************************************/
module "vpc" {
  source                                    = "../../modules/network/vpc"
  network_name                              = "exam-vpc"
  routing_mode                              = "REGIONAL"
  project_id                                = var.project_id
  delete_default_internet_gateway_routes    = "true"
  depends_on                                = [ module.enable_apis ]
}

/******************************************
	Subnets configuration
 *****************************************/
module "subnets" {
  source                                    = "../../modules/network/subnets"
  network_name                              = module.vpc.network_name
  project_id                                = var.project_id
  subnets = [
      {
          subnet_name           = "public-subnet"
          subnet_ip             = "10.0.0.0/24"
          subnet_region         = var.region
          subnet_private_access = "true"
          description           = "public subnet"
          subnet_flow_logs      = "true"

      },
      {
          subnet_name           = "private-subnet-comp"
          subnet_ip             = "10.0.1.0/24"
          subnet_region         = var.region
          subnet_private_access = "true"
          description           = "private subnet for compute"
          subnet_flow_logs      = "true"
      },
      {
          subnet_name           = "private-subnet-gke"
          subnet_ip             = "10.0.2.0/24"
          subnet_region         = var.region
          subnet_private_access = "true"
          description           = "private subnet for gke"
          subnet_flow_logs      = "true"
      },
      {
          subnet_name           = "private-subnet-db"
          subnet_ip             = "10.0.3.0/24"
          subnet_region         = var.region
          subnet_private_access = "true"
          description           = "private subnet for database"
          subnet_flow_logs      = "true"
      },
  ]

  secondary_ranges = {
      private-subnet-gke = [
          {
              range_name        = "private-subnet-gke-pods"
              ip_cidr_range     = "10.100.0.0/16"
          },
          {
              range_name        = "private-subnet-gke-svc"
              ip_cidr_range     = "10.101.0.0/20"
          }
      ]
  }

  depends_on = [ module.vpc ]
}

/******************************************
	routes configuration
 *****************************************/
module "routes" {
  source                        = "../../modules/network/routes"
  network_name                  = module.vpc.network_name
  project_id                    = var.project_id
  routes = [
    {
      name                      = "rt-internet-default"
      description               = "Tag based route through IGW to access internet"
      destination_range         = "0.0.0.0/0"
      next_hop_internet         = "true"
      priority                  = "1000"
    }
  ]
  depends_on = [ module.vpc ]
}


# /******************************************
# 	firewall_rules configuration
#  *****************************************/
module "firewall_rules" {
  source       = "../../modules/network/firewall_rules"
  project_id   = var.project_id
  network_name = module.vpc.network_name

  rules = [
      {
        name                    = "test-ssh-iap"
        description             = null
        direction               = "INGRESS"
        priority                = 1000
        ranges                  = ["35.235.240.0/20"]
        target_tags             = ["ssh-iap"]
        allow = [{
          protocol = "tcp"
          ports    = ["22","5601"]
        }]
      },
      {
        name                    = "ansible-to-elasticsearch"
        description             = null
        direction               = "INGRESS"
        priority                = 1000
        source_tags             = ["ansible"]
        target_tags             = ["elasticsearch"]
        allow = [
          { 
            protocol = "tcp"
            ports    = ["22","9200-9400","5601"]
          },
          {
            protocol = "icmp"
          }
        ]
      },
      {
        name                    = "elasticsearch-to-elasticsearch"
        description             = null
        direction               = "INGRESS"
        priority                = 1000
        source_tags             = ["ansible","elasticsearch"]
        target_tags             = ["elasticsearch"]
        allow = [{
          protocol = "tcp"
          ports    = ["22","9200-9400","5601"]
        }]
      }
  ]
}

# /******************************************
# 	nat configuration
#  *****************************************/
module "cloud_nat" {
  source                = "../../modules/network/nat"
  project_id            = var.project_id
  region                = var.region
  network               = module.vpc.network_name
  name                  = "exam"
}

# /******************************************
# 	google private access configuration
#  *****************************************/
module "private_access" {
  source                = "../../modules/network/private_access"
  project_id            = var.project_id
  network               = module.vpc.network_name
  googleapis_zone_name  = "private-googleapis"
  gcr_io_zone_name      = "private-gcr-io"
}


/******************************************
	GCS configuration
 *****************************************/
module "gcs_bucket" {
  source                      = "../../modules/storage/gcs"
  project_id                  = var.project_id
  bucket_name                 = "cloud-engineer-exam-bucket"
  location                    = var.region
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = true
}


module "service_account" {
  source                        = "../../modules/project/service_account"
  project_id                    = var.project_id
  service_account_name          = "elasticsearch-sa"
  service_account_display_name  = "Service Account for Elasticsearch vm"
  roles                         = ["roles/logging.logWriter", "roles/monitoring.metricWriter", "roles/storage.objectViewer"]
}
module "vm_instances_elasticsearch" {
  source                        = "../../modules/compute/compute_instance"
  count                         = 3

  project_id                    = var.project_id
  instance_name                 = "es0${count.index + 1}"
  zone                          = var.zones[count.index % length(var.zones)]
  machine_type                  = "e2-medium"
  image                         = "ubuntu-os-cloud/ubuntu-2204-lts"
  disk_size_os                  = 50
  network                       = module.vpc.network_name
  subnetwork                    = module.subnets.subnet_names[0]
  network_ip                    = cidrhost(module.subnets.subnet_cidr_ips[0], count.index + 2)
  tags                          = ["ssh-iap","elasticsearch"]
  allow_stopping_for_update     = true
  service_account_email         = module.service_account.service_account_email
}

module "vm_instances_ansible" {
  source                        = "../../modules/compute/compute_instance"
  count                         = 1
  project_id                    = var.project_id
  instance_name                 = "ansible"
  zone                          = var.zones[count.index % length(var.zones)]
  machine_type                  = "e2-medium"
  image                         = "ubuntu-os-cloud/ubuntu-2204-lts"
  disk_size_os                  = 50
  network                       = module.vpc.network_name
  subnetwork                    = module.subnets.subnet_names[0]
  network_ip                    = "10.0.1.100"
  tags                          = ["ssh-iap","ansible"]
  allow_stopping_for_update     = true
  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      sudo apt-get update
      sudo apt-get install -y ansible
    EOT
  }
  service_account_email = module.service_account.service_account_email
}

module "private_service_access_postgesql" {
  source              = "../../modules/network/private_service_access"
  project_id          = var.project_id
  vpc_network         = module.vpc.network_name
  address             = "10.200.0.0"
  deletion_policy     = "ABANDON"
  depends_on          = [ module.vpc ]
}

module "postgres" {
  source              = "../../modules/database/postgresql"
  instance_name       = "exam-postgres"
  region              = var.region
  tier                = "db-g1-small"
  availability_type   = "REGIONAL"
  public_ip_enabled   = false
  private_network     = module.vpc.network_self_link
  deletion_protection = false
  depends_on          = [ module.private_service_access_postgesql ]
}

module "redis" {
  source                  = "../../modules/database/redis"
  name                    = "exam-redis"
  project_id              = var.project_id
  region                  = var.region
  location_id             = var.zones[0]
  alternative_location_id = var.zones[1]
  redis_version           = "REDIS_7_0"
  tier                    = "STANDARD_HA"
  auth_enabled            = true
  connect_mode            = "PRIVATE_SERVICE_ACCESS"
  transit_encryption_mode = "SERVER_AUTHENTICATION"
  replica_count           = 1
  read_replicas_mode      = "READ_REPLICAS_ENABLED"
  authorized_network      = module.vpc.network_id
  memory_size_gb          = 5
  depends_on              = [ module.vpc ]

}

module "gke_private" {
  source                  = "../../modules/compute/gke"
  project_id              = var.project_id
  region                  = var.region
  network                 = module.vpc.network_name
  subnetwork              = module.subnets.subnet_names[2]
  cluster_name            = "private-gke-cluster"
  master_ipv4_cidr        = "172.16.0.0/28"
  pods_ipv4_cidr          = module.subnets.secondary_subnet_cidr_ips[2][0].range_name
  services_ipv4_cidr      = module.subnets.secondary_subnet_cidr_ips[2][1].range_name
  node_pools = [
    {
      name         = "pool-1"
      machine_type = "e2-medium"
      node_count   = 1
      min_count    = 1
      max_count    = 2
    }
  ]
}


# # /******************************************
# # 	Memorystore - Redis Cluster configuration
# #  *****************************************/
# module "redis_cluster" {
#   source  = "../../modules/database/redis-cluster"
#   name    = "exam-redis-cluster"
#   project_id = var.project_id
#   region  = var.region
#   network = [module.vpc.network_id]
#   node_type = "REDIS_SHARED_CORE_NANO"
#   zone_distribution_config_mode = "MULTI_ZONE"
#   deletion_protection_enabled = false
#   shard_count = 3
#   replica_count = 2
#   redis_configs = {
#     maxmemory-policy	= "volatile-ttl"
#   }
#   service_connection_policies = {
#     test-net-redis-cluster-scp = {
#       network_name    = module.vpc.network_name
#       network_project = var.project_id
#       subnet_names = [
#         module.subnets.subnet_names[1]
#       ]
#     }
#   }
# }

# module "private_service_access_alloydb" {
#   source  = "../../modules/network/private_service_access"

#   project_id      = var.project_id
#   vpc_network     = module.vpc.network_name
#   address         = "10.200.0.0"
#   deletion_policy = "ABANDON"
#   depends_on = [ module.vpc ]
# }

# module "alloydb" {
#   source  = "../../modules/database/alloydb"

#   cluster_id       = "exam-alloydb"
#   cluster_location = var.region
#   project_id       = var.project_id

#   network_self_link           = "projects/${var.project_id}/global/networks/${module.vpc.network_name}"


#   primary_instance = {
#     instance_id        = "exam-instance1",
#     require_connectors = false
#     ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
#   }

#   read_pool_instance = [
#     {
#       instance_id        = "exam-read1"
#       display_name       = "exam-read1"
#       availability_type  = "REGIONAL"
#       require_connectors = false
#       ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
#     }
#   ]

#   depends_on = [
#     module.vpc,
#     module.private_service_access_alloydb
#   ]
# }
