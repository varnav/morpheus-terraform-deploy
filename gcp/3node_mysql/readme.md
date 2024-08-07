# 3-Node HA Install

## Purpose

This project will create the infrastructure for a [3-Node Highly Available (HA) Install](https://docs.morpheusdata.com/en/latest/getting_started/installation/3_node_ha/3_node_ha.html) of Morpheus using GCP MYSQL for an external database and GCP Filestore for NFS.  Additionally, Morpheus dependant services are expected to be embedded on the application nodes.  Morpheus will setup these embedded services automatically when installing the application following the documentation.
The deployment will create all underlying networking and services automatically (this includes a router if set to true), meaning a brand new GCP account could be used and no pre-existing configuration is needed, with the exception of credentials for Terraform to connect.  
HTTPS is allowed from external if the load balancer. 

## Requirements

- GCP Account in a region that supports the below services   
  - Compute Engine
  - MYSQL
  - Load Balancing
- User created with permissions to create these resources in the GCP project
- GCP API's Enabled in the Project
  - Compute Engine API
  - Cloud Resource Manager API
  - Cloud SQL Admin API
  - Cloud filestore API
  - Service Networking API


## Example Deployment

1. Authentication using one of the preferred methods. If looking to use the GCP json file there is a commented out connection in provider and a commented out gcp_auth variable in the variable file that can be used. Read [Google Provider Configuration Reference](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference) for more information.
2. Download and install/extract [Terraform](https://www.terraform.io/downloads) to the local workstation or other location
   1. The directory Terraform is installed/extracted to can be added to environment variables to more easily call Terraform.  Otherwise, note the binary location to use when running `terraform <command>`
3. Clone the [morpheus-terraform-deploy](https://github.com/gomorpheus/morpheus-terraform-deploy) repository from the [gomorpheus GitHub](https://github.com/gomorpheus) page:  
`git clone https://github.com/gomorpheus/morpheus-terraform-deploy`
3. Change directory to the respository cloned and the Full HA directory:  
`cd ./morpheus-terraform-deploy/aws/3node_aurora`
1. The deployment comes with an `.tfvars` file, which has example values for the required variables.  No modifications are required but `example.tfvars` can be edited to modify the deployment, if needed.  During the deployment, you will be prompted for passwords for the various services
2. Run `terraform apply` from the current directory, with the argument for the `example.tfvars` file.  Review the planned changes and confirm to make the changes:  
`terraform apply -var-file "example.tfvars"`
6. The services can take some time to provision.  Once the deployment is complete, details will be provided via [outputs](https://www.terraform.io/language/values/outputs), to help configure Morpheus for these services
   1. **Note that the EC2 instance access key that is generated will show as `app_vm_key_pair: <sensitive>` in the output, to ensure the values are not exposed inadvertently.**  When needing to connect to the EC2 instance(s), use the following command to retrieve the private key and create a `.pem` file as needed:  
   `terraform output -raw app_vm_key_pair`
7. At this point, all infrastructure should be created to support the installation of Morpheus.  The services will need to be configured appropriately before starting the installation of the Morpheus application.  Please see the [3-Node Highly Available (HA) Install](https://docs.morpheusdata.com/en/latest/getting_started/installation/distributed/3node/3node.html) documentation for additional details
