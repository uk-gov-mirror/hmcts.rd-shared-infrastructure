locals {
  tags = merge(
    var.common_tags,
    tomap({
      "Team Contact" = "#referencedata"
      "Destroy Me"   = var.destroy_me
      "Team Name"    = var.team_name
      "managedBy"    = var.team_name
      "application"  = "referencedata"
      "builtFrom"    = "https://github.com/hmcts/rd-shared-infrastructure"
      "businessArea" = "CFT"
    })
    )
}