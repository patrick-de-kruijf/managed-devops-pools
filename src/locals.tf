locals {
  rgName               = "rg-${var.scaffold_company_short_name}-devpool-${var.scaffold_environment}-${var.scaffold_location_short_name}-001"
  vnetName             = "vnet-${var.scaffold_company_short_name}-devpool-${var.scaffold_environment}-${var.scaffold_location_short_name}-001"
  devCenterName        = "devc-${var.scaffold_company_short_name}-devpool-${var.scaffold_environment}-${var.scaffold_location_short_name}-001"
  devCenterProjectName = "devpr-${var.scaffold_company_short_name}-devpool-${var.scaffold_environment}-${var.scaffold_location_short_name}-001"
  snetName             = "snet-${var.scaffold_company_short_name}-devpool-${var.scaffold_environment}-${var.scaffold_location_short_name}-001"
  poolName             = "pool-${var.scaffold_company_short_name}-devpool-${var.scaffold_environment}-${var.scaffold_location_short_name}-001"
}
