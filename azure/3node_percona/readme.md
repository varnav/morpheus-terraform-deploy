# 3-Node HA Install

## Purpose

This project will create the infrastructure for a [3-Node Highly Available (HA) Install](https://docs.morpheusdata.com/en/latest/getting_started/installation/distributed/3node/3node.html) of Morpheus using Percona mySQL for an external database.  Additionally, Morpheus dependant services are expected to be embedded on the application nodes.  Morpheus will setup these embedded services automatically when installing the application following the documentation.
The deployment will create all underlying networking and services automatically, meaning a brand new Azure Subscription could be used and no pre-existing
configuration is needed, with the exception of credentials for Terraform to connect.  All security groups are configured with the minimal needed inbound ports
and only allowing communication directly between services.  Additional ports, such as SSH, would need to be added manually to access the instances.  HTTPS is allowed from all sources, which can be reduced to the networks that web clients and agents would reside.

## Requirements

- Azure Subscription in a region that supports the below services:  
  - Virtual Machines
  - Application Gateway (v2)
- Service Principal (SP) created on the Azure Subscription [How to Create a Service Principal](https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-windows-powershell?tabs=bash#create-a-service-principal)
  - The SP credentials can be configured [using environment variables](https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-windows-powershell?tabs=bash#specify-service-principal-credentials-in-environment-variables).
- This deployment will create Virtual Machies that have either 2 or 4 vCPUs.  The total number of vCPUs that will be created is 18, which may be above the default Quota for your subscription/region.  A Quota increase my be requested by navigating to the [Quota's section](https://portal.azure.com/#view/Microsoft_Azure_Capacity/QuotaMenuBlade/~/myQuotas) in Azure and requesting an increase to the `Total Regional vCPU` and `Standard DSv3 Family vCPUs` to at least 18.

## Example Deployment

1. Ensure the Azure credentials for the Service Principal are populated in the environment variables.  [More Info](https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-windows-powershell?tabs=bash#specify-service-principal-credentials-in-environment-variables)
2. Download and install/extract [Terraform](https://www.terraform.io/downloads) to the local workstation or other location
   1. The directory Terraform is installed/extracted to can be added to environment variables to more easily call Terraform.  Otherwise, note the binary location to use when running `terraform <command>`
3. Clone the [morpheus-terraform-deploy](https://github.com/gomorpheus/morpheus-terraform-deploy) repository from the [gomorpheus GitHub](https://github.com/gomorpheus) page:  
`git clone https://github.com/gomorpheus/morpheus-terraform-deploy`
1. Change directory to the respository cloned and the Full HA directory:  
`cd ./morpheus-terraform-deploy/azure/3node_percona`
1. The deployment comes with an `.tfvars` file, which has example values for the required variables.  No modifications are required but `example.tfvars` can be edited to modify the deployment, if needed
2. Run `terraform apply` from the current directory, with the argument for the `example.tfvars` file.  Review the planned changes and confirm to make the changes:  
`terraform apply -var-file="example.tfvars"`
1. The services can take some time to provision.  Once the deployment is complete, details will be provided via [outputs](https://www.terraform.io/language/values/outputs), to help configure Morpheus for these services
   1. **Note that the Virtual Machine access key that is generated will show as `vm_key_pair: <sensitive>` in the output, to ensure the values are not exposed inadvertently.**  When needing to connect to the Virtual Machine(s), use the following command to retrieve the private key and create a `.pem` file as needed:  
   `terraform output -raw vm_key_pair`
2. At this point, all infrastructure should be created to support the installation of Morpheus.  The services will need to be configured appropriately before starting the installation of the Morpheus application.  Please see the [3-Node Highly Available (HA) Install](https://docs.morpheusdata.com/en/latest/getting_started/installation/distributed/3node/3node.html) documentation for additional details

## Additional Links

- Creating self-signed CA backed "locally" signed certificates: \
https://learn.microsoft.com/en-us/azure/application-gateway/self-signed-certificates
- TLS Provider: \
https://registry.terraform.io/providers/hashicorp/tls/latest/docs
- pkcs12 Provider (conversion to PFX): \
https://registry.terraform.io/providers/chilicat/pkcs12/latest/docs/resources/from_pem