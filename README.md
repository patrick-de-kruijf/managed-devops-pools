# Managed DevOps Pools

This repository contains a simple configuration for deploying usable Managed DevOps Pools for Azure DevOps.

In order to run this code, you will need to update the following files:

1. /vars/test.tfvars
   - Replace all occurences of `{insert*}`
2. /src/terraform.tf
   - Set the correct subscription ID for the `AzureRM` provider

After the changes have been made you can run the following commands to start a deployment:

`az login`
`cd src`
`terraform init`
`terraform validate`
`terraform plan --var-file=../vars/test.tfvars`
`terraform apply --var-file=../vars/test.tfvars`

When you want to destroy all resources, please run the following commands:

`az login`
`cd src`
`terraform destroy --var-file=../vars/test.tfvars`
