scaffold_location               = "westeurope"
scaffold_environment            = "production"
scaffold_environment_short_name = "prod"
scaffold_location_short_name    = "weu"
scaffold_company_short_name     = "{insert-your-company-short-name}"

virtual_hub_id           = "/subscriptions/{insert-your-hub-subscription-id}/resourceGroups/{insert-your-hub-resource-group-name}/providers/Microsoft.Network/virtualHubs/{insert-your-virtual-hub-name}"
vnet_devpool_ip_range    = "{insert-your-ip-range}"
vnet_dns_servers         = ["{insert-your-dns-server-ip}"]
agent_maximumConcurrency = 2 # This is the maximum number of agents that can run concurrently
devops_organization_url  = "https://dev.azure.com/{insert-your-organization-name}"
devops_projects          = ["{inset-your-project-name}", "{insert another project name}"]
