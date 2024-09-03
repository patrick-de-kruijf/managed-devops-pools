resource "azurerm_resource_group" "rg" {
  name     = local.rgName
  location = var.scaffold_location

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_dev_center" "devcenter" {
  name                = substr(local.devCenterName, 0, 26)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dev_center_project" "devcenter_project" {
  name                = local.devCenterProjectName
  dev_center_id       = azurerm_dev_center.devcenter.id
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnetName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_devpool_ip_range]
  dns_servers         = var.vnet_dns_servers
}

resource "azurerm_virtual_hub_connection" "agents" {
  depends_on = [azurerm_virtual_network.vnet]
  count      = var.virtual_hub_id != null ? 1 : 0

  name                      = "conn-${local.vnetName}"
  internet_security_enabled = true
  virtual_hub_id            = var.virtual_hub_id
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}

resource "azapi_resource" "snet" {
  depends_on = [azurerm_virtual_network.vnet]

  name      = local.snetName
  type      = "Microsoft.Network/virtualNetworks/subnets@2023-11-01"
  parent_id = azurerm_virtual_network.vnet.id

  body = jsonencode({
    properties = {
      addressPrefix = var.vnet_devpool_ip_range
      delegations = [
        {
          name = "Microsoft.DevOpsInfrastructure/pools"
          properties = {
            serviceName = "Microsoft.DevOpsInfrastructure/pools"
          }
        }
      ]
    }
  })
}

resource "azapi_resource" "pool" {
  name      = local.poolName
  type      = "microsoft.devopsinfrastructure/pools@2024-04-04-preview"
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id

  body = jsonencode({
    properties = {
      organizationProfile = {
        organizations = [
          {
            projects    = var.devops_projects
            url         = var.devops_organization_url
            parallelism = var.agent_maximumConcurrency
          }
        ]
        kind = "AzureDevOps" # Currently only AzureDevOps is supported
        permissionProfile = {
          kind = "CreatorOnly" # Can also be set to "Inherit" or "SpecificAccounts"
          # If you want to use specific accounts, you can add them here using the users and groups properties
          # users = [
          #   "Patrick.deKruijf@xebia.com"
          # ]
          # groups = []
        }
      }

      devCenterProjectResourceId = azurerm_dev_center_project.devcenter_project.id

      maximumConcurrency = var.agent_maximumConcurrency

      agentProfile = {
        kind = "Stateless" # I would recommend setting this to "Stateless", since this ensures a fresh agent is used for each job.
        #   kind             = "Stateful"
        #   maxAgentLifetime = "7.00:00:00" # Property is required when set to "Stateful"

        # If you do not want to turn off scaling, remove the complete resourcePredictionsProfile block
        # There is also a "Manual" option, which allows you to set the minimum and maximum number of agents based on a schedule.
        resourcePredictionsProfile = {
          predictionPreference = "MostCostEffective" # There are 5 options, ranging from "MostCostEffective" to "MostPerformance"
          kind                 = "Automatic"         # Can also be set to Manual or 
        }

      }

      fabricProfile = {
        sku = {
          name = "Standard_D2ads_v5"
        }

        images = [
          {
            aliases            = ["ubuntu-22.04"]
            buffer             = "*"
            wellKnownImageName = "ubuntu-22.04/latest"
          },
          # You can add more images if needed, also referencing resource IDs for images
          # {
          #   resourceId = "/Subscriptions/5ab24a52-44e0-4bdf-a879-cc38371a4403/Providers/Microsoft.Compute/Locations/westeurope/Publishers/canonical/ArtifactTypes/VMImage/Offers/0001-com-ubuntu-server-focal/Skus/20_04-lts-gen2/versions/latest",
          #   buffer     = "*"
          # }
        ]

        osProfile = {
          # Not much to configure here just yet, but Microsoft is working on adding Key Vault support too
          secretsManagementSettings = {
            observedCertificates = [],
            keyExportable        = false
          },
          logonType = "Service" # Can also be set to "Interactive"
        },

        # If you want to use an isolated network, remove the complete networkProfile block
        networkProfile = {
          subnetId = azapi_resource.snet.id
        }

        storageProfile = {
          osDiskStorageAccountType = "Premium", # Standard, StandardSSD, Premium
          dataDisks = [
            # Create additional data disks if needed
            # {
            #   diskSizeGiB        = 100
            #   caching            = "ReadWrite"
            #   storageAccountType = "StandardSSD_LRS"
            #   driveLetter        = "Z"
            # }
          ]
        },

        kind = "Vmss" # Currently only "Vmss" is supported
      }
    }
  })
}
