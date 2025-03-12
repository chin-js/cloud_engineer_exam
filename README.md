## Terraform Execution

### 1. Initialize Terraform
Navigate to the environment directory and initialize Terraform:
```sh
cd environments/dev
terraform init
```

### 2. Preview the Changes
Run a plan to see what Terraform will modify:
```sh
terraform plan
```

### 3. Apply the Configuration
If everything looks good, apply the configuration:
```sh
terraform apply -auto-approve
```

## Infrastructure Components

### 1. **Enable GCP APIs**
The following APIs will be enabled for the project:
- Compute Engine (`compute.googleapis.com`)
- Service Usage (`serviceusage.googleapis.com`)
- Cloud Resource Manager (`cloudresourcemanager.googleapis.com`)
- Cloud DNS (`dns.googleapis.com`)
- Identity-Aware Proxy (IAP) (`iap.googleapis.com`)
- Network Management (`networkmanagement.googleapis.com`)
- Redis (`redis.googleapis.com`)
- Service Consumer Management (`serviceconsumermanagement.googleapis.com`)
- Network Connectivity (`networkconnectivity.googleapis.com`)
- Service Networking (`servicenetworking.googleapis.com`)
- Cloud SQL Admin (`sqladmin.googleapis.com`)
- Kubernetes Engine (`container.googleapis.com`)

### 2. **VPC and Subnet Configuration**
- **VPC Name:** `exam-vpc`

#### Subnet Summary
| Subnet Name           | CIDR Block       | Region    | Private Access | Description                 | Flow Logs |
|----------------------|----------------|----------|---------------|-----------------------------|-----------|
| public-subnet        | 10.0.0.0/24     | asia-southeast1 | Yes           | Public subnet               | Yes       |
| private-subnet-comp  | 10.0.1.0/24     | asia-southeast1 | Yes           | Private subnet for compute  | Yes       |
| private-subnet-gke   | 10.0.2.0/24     | asia-southeast1 | Yes           | Private subnet for GKE      | Yes       |
| private-subnet-db    | 10.0.3.0/24     | asia-southeast1 | Yes           | Private subnet for database | Yes       |

#### Secondary IP Ranges for GKE
| Subnet Name         | Range Name                    | CIDR Block       |
|--------------------|-----------------------------|----------------|
| private-subnet-gke | private-subnet-gke-pods     | 10.100.0.0/16  |
| private-subnet-gke | private-subnet-gke-svc      | 10.101.0.0/20  |

### 3. **Firewall Rules**
- Allow SSH (`tcp:22`) only from IAP (`35.235.240.0/20`)
- Allow Port (`tcp:5601`) only from IAP (`35.235.240.0/20`) for access Kibana
- Secure access between `ansible` and `elasticsearch`

### 4. **Compute Instances**
- **Elasticsearch Nodes:** 3 instances with internal networking
- **Ansible VM:** 1 instance with a startup script to install Ansible

### 5. **Private Cloud Services**
- **Cloud NAT**: Enables outbound internet access for private VMs
- **Private Access to Google Services**
- **Private PostgreSQL and Redis** with **private networking**

### 6. **PostgreSQL**
| Instance Name     | Region     | Tier         | Availability | Public IP | Private Network |
|------------------|-----------|-------------|--------------|-----------|----------------|
| exam-postgres   | asia-southeast1 | db-g1-small | REGIONAL     | No        | Enabled        |

### 7. **Redis**
| Instance Name  | Region     | Version    | Tier        | Auth Enabled | Memory Size | connect_mode |
|--------------|-----------|------------|------------|--------------|-------------|-------------|
| exam-redis   | asia-southeast1 | REDIS_7_0  | STANDARD_HA | Yes          | 5GB         |PRIVATE_SERVICE_ACCESS


### 9. **Google Kubernetes Engine (GKE)**
#### **GKE Cluster Summary**
| Cluster Name         | Region     | Network    | Subnetwork           | Master CIDR Block |
|---------------------|-----------|-----------|----------------------|------------------|
| private-gke-cluster | asia-southeast1 | exam-vpc  | private-subnet-gke  | 172.16.0.0/28   |

#### **GKE Node Pool Details**
| Pool Name | Machine Type | Node Count | Min Count | Max Count |
|----------|-------------|------------|-----------|-----------|
| pool-1   | e2-medium   | 1          | 1         | 2         |


# Deploying Ansible for ELK on Google Cloud

## 1. Copy Ansible Playbook from GCS
```sh
git clone https://github.com/chin-js/cloud_engineer_exam.git
```

## 2. Generate SSH Key Pair
```sh
ssh-keygen -t rsa
```

## 3. Add SSH Keys to Compute Instances
```sh
gcloud compute instances add-metadata es01 --zone asia-southeast1-a \
    --metadata ssh-keys="root:$(cat ~/.ssh/id_rsa.pub)"

gcloud compute instances add-metadata es02 --zone asia-southeast1-b \
    --metadata ssh-keys="root:$(cat ~/.ssh/id_rsa.pub)"

gcloud compute instances add-metadata es03 --zone asia-southeast1-c \
    --metadata ssh-keys="root:$(cat ~/.ssh/id_rsa.pub)"
```

## 4. Test Ansible Connection
```sh
ansible all -m ping -i inventory.ini -u root
```

## 5. Run Ansible Playbook
```sh
ansible-playbook -i inventory.ini playbook.yml -u root
```

## 6. Verify ELK Cluster Health
```sh
curl -k -u elastic:<password> "https://10.0.1.2:9200/_cluster/health?pretty"
```

## 7. Check Node Status
```sh
curl -k -u elastic:<password> "https://10.0.1.2:9200/_cat/nodes?v"
```

## 8. Access to Kibana with Port Forwarding
```sh
gcloud compute ssh es01 --project=cloud-engineer-exam-452814 --zone=asia-southeast1-a --tunnel-through-iap -- -L 5601:localhost:5601
```

### Notes:
- Replace `<password>` with your actual credentials.
- Ensure that your `inventory.ini` is properly configured.
