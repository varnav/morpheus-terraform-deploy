# Single Node/All-In-One (AIO) Installation

## Purpose

This project will create the infrastructure for a [Single Node Install](https://docs.morpheusdata.com/en/latest/getting_started/installation/singleNode/singleNode.html) of Morpheus with the expectation all services will be embedded.  Morpheus will setup these embedded services automatically when installing the application following the documentation.
The deployment will create all underlying networking and services automatically, meaning a brand new AWS account could be used and no pre-existing
configuration is needed, with the exception of credentials for Terraform to connect.  All security groups are configured with the minimal needed inbound ports.  Additional ports, such as SSH, would need to be added manually to access the instances.

## Requirements

- AWS Account in a region that supports the below services ([AWS Regional Services](https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/)):  
  - Elastic Compute Cloud (EC2)
- IAM user created on the AWS account or an external user granted permission to assume a role into the target AWS account.  This user's credentials can be configured in the credentials file on the local workstation or using environment variables.  Read [Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) for more information

## Example Deployment

1. Ensure the AWS credentials for the IAM user are populated in the credentials file or environment variables.  Read [Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) for more information.
2. Download and install/extract [Terraform](https://www.terraform.io/downloads) to the local workstation or other location
   1. The directory Terraform is installed/extracted to can be added to environment variables to more easily call Terraform.  Otherwise, note the binary location to use when running `terraform <command>`
3. Clone the [morpheus-terraform-deploy](https://github.com/gomorpheus/morpheus-terraform-deploy) repository from the [gomorpheus GitHub](https://github.com/gomorpheus) page:  
`git clone https://github.com/gomorpheus/morpheus-terraform-deploy`
3. Change directory to the respository cloned and the Full HA directory:  
`cd ./morpheus-terraform-deploy/aws/aio`
4. The deployment comes with an `example.tfvars` file, which has example values for the required variables.  No modifications are required but `example.tfvars` can be edited to modify the deployment, if needed.  During the deployment, you will be prompted for passwords for the various services
5. Run `terraform apply` from the current directory, with the argument for the `example.tfvars` file.  Review the planned changes and confirm to make the changes:  
`terraform apply -var-file"example.tfvars"`
6. The services can take some time to provision.  Once the deployment is complete, details will be provided via [outputs](https://www.terraform.io/language/values/outputs), to help configure Morpheus for these services
   1. **Note that the EC2 instance access key that is generated will show as `app_vm_key_pair: <sensitive>` in the output, to ensure the values are not exposed inadvertently.**  When needing to connect to the EC2 instance(s), use the following command to retrieve the private key and create a `.pem` file as needed:  
   `terraform output -raw app_vm_key_pair`
7. At this point, all infrastructure should be created to support the installation of Morpheus.  Installation for Morpheus can now be completed.  Please see the [Single Node Install](https://docs.morpheusdata.com/en/latest/getting_started/installation/singleNode/singleNode.html) documentation for additional details