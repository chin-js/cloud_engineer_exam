gsutil cp -r gs://tfstate-gcs/ansible-elk .


ssh-keygen -t rsa

gcloud compute instances add-metadata es01 --zone asia-southeast1-a \
    --metadata ssh-keys="root:$(cat ~/.ssh/id_rsa.pub)"
gcloud compute instances add-metadata es02 --zone asia-southeast1-b \
    --metadata ssh-keys="root:$(cat ~/.ssh/id_rsa.pub)"
gcloud compute instances add-metadata es03 --zone asia-southeast1-c \
    --metadata ssh-keys="root:$(cat ~/.ssh/id_rsa.pub)"

ansible all -m ping -i inventory.ini -u root

ansible-playbook -i inventory.ini playbook.yml -u root


curl -k -u elastic:passw0rd "https://10.0.1.2:9200/_cluster/health?pretty"
curl -k -u elastic:passw0rd "https://10.0.1.2:9200/_cat/nodes?v"

curl -k -u elastic:passw0rd "https://10.0.1.2:9200/_xpack/watcher/_start"

curl -X POST -k -u elastic:passw0rd "https://10.0.1.2:9200/_monitoring/migrate/alerts"

gcloud compute ssh es01 --project=cloud-engineer-exam-452814 --zone=asia-southeast1-a --tunnel-through-iap -- -L 5601:localhost:5601

