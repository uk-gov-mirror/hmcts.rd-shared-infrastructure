aks_infra_subscription_id  = "8cbc6f36-7c56-4963-9d36-739db5d00b27" # DCD-CFTAPPS-PROD

# Overwrite LD Location Storage Account for AAT & Prod. Other environments will use the defaults provided in variables.tf file
rd_location_storage_repl_type   = "ZRS"
rd_location_storage_access_tier = "Hot"