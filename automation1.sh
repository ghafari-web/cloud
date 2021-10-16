#!/bin/bash 

echo "Create VPC and Subnet"
echo "1- Create front-end network"
gcloud compute networks create frontend-net --subnet-mode=custom --bgp-routing-mode=regional
echo "1.1- Create front-end sub-networks
gcloud compute networks subnets create frontend-subnet --range=10.0.0.0/24 --network=frontend-net --region=europe-central2
echo "2- Create back-end network"
gcloud compute networks create backend-net --subnet-mode=custom --bgp-routing-mode=regional
echo "2.1- Create back-end sub-networks
gcloud compute networks subnets create backend-subnet --range=10.0.0.0/24 --network=backend-net --region=europe-central2

echo "Creating Kali instance for front-end"
gcloud compute instances create kali-1 --tags=vmfe \
  --metadata startup-script='
  #! /bin/bash
  sudo su -
  apt-get update
  # TO DO: Install KALI Tools
  EOF'

echo "Creating second Kali instance for back-end"
gcloud compute instances create kali-1 --tags=vmbe\
  --metadata startup-script='
  #! /bin/bash
  sudo su -
  apt-get update
  # TO DO: Install KALI Tools
  EOF'

echo "Adding firewall rules"
gcloud compute firewall-rules create allow-ingress-admin-backend-net --direction=INGRESS --priority=1000 --network=lab-net --action=ALLOW --rules=tcp:22,tcp:3389,tcp:443,icmp --source-ranges=0.0.0.0/0 --target-tags=vmbe
gcloud compute firewall-rules create allow-ingress-admin-frontend-net --direction=INGRESS --priority=1000 --network=lab-net --action=ALLOW --rules=all --source-ranges=0.0.0.0/0 --target-tags=vmfe
echo "Done"
