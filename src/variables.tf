variable "scaffold_location" {
  description = "The Azure Region where the solution should exist."
  type        = string
}

variable "scaffold_environment" {
  description = "The environment name for the solution, used for naming purposes."
  type        = string
}

variable "scaffold_environment_short_name" {
  description = "The environment name for the solution, used for naming purposes."
  type        = string
}

variable "scaffold_location_short_name" {
  description = "The abbreviation of the Azure Region where the solution should exist"
  type        = string

  validation {
    condition     = length(var.scaffold_location_short_name) <= 3
    error_message = "The location short name must be 3 characters or less."
  }
}

variable "scaffold_company_short_name" {
  description = "Abbreviation of the company name to make all Azure resources unique within the Azure Tenant."
  type        = string

  validation {
    condition     = length(var.scaffold_company_short_name) <= 6
    error_message = "The company short name must be 6 characters or less."
  }
}

variable "virtual_hub_id" {
  description = "The ID of the Virtual Hub to connect the Virtual Network to."
  type        = string
  default     = null
}

variable "vnet_devpool_ip_range" {
  description = "The IP range for the Virtual Network to be used, which is also used for the single subnet provisioned."
  type        = string
}

variable "devops_organization_url" {
  description = "The URL of the Azure DevOps organization to add the Managed DevOps Pool to."
  type        = string
}

variable "devops_projects" {
  description = "The list of Azure DevOps projects to be allowed to use the agent pool, defaults to every project in the supplied organization."
  type        = list(string)
  default     = ["*"]
}

variable "agent_maximumConcurrency" {
  description = "The maximum number of agents that can run concurrently."
  type        = number
}

variable "vnet_dns_servers" {
  description = "The DNS servers for the Virtual Network."
  type        = list(string)
}
