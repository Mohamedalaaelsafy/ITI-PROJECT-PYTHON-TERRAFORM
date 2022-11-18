# TERRAFORM_GCP

Bulding GCP infrastructure using Terraform.

## Description

This code consists of network modules which have one vpc with two main private subnets one for the instance connected through IAP bastion servers and the other for GKE cluster which configured with two node pools where service accounts are attached.

## Getting Started

### Dependencies

* Terraform v1.2+ installed locally.
* GCP Credentials configured for use with Terraform.

### Installation resources

* https://www.terraform.io/
* https://askubuntu.com/questions/983351/how-to-install-terraform-in-ubuntu

### Executing program

* Change your project ID according to yours
```
terraform init
terraform plan
terraform apply
```

## Authors

name: Mohamed Alaa  
email: mohamedalaaelsafy@gmail.com
