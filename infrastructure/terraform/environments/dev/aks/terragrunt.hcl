# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform and OpenTofu that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

include {
  // searches up the directory tree from the current terragrunt.hcl file
  // and returns the absolute path to the first terragrunt.hcl
  path = find_in_parent_folders()
}

# Configure the version of the module to use in this environment. This allows you to promote new versions one
# environment at a time (e.g., qa -> stage -> prod).
terraform {
  source = "${dirname(find_in_parent_folders())}//modules/terraform-azure-aks"
}

# ---------------------------------------------------------------------------------------------------------------------
# We don't need to override any of the common parameters for this environment, so we don't specify any inputs.
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
  stack                     = "infra"
  vnet_addr_prefix          = "10.16.0.0/24"
  subnet_addr_prefix        = "10.16.0.0/26"
  aad_admin_group_object_id = "96c4ca86-584a-4584-9923-ac463c8b88af"
  system_nodepool = {
    vm_size      = "Standard_B2ms"
    os_disk_type = "Managed"
    min_count    = 1
    max_count    = 1
  }
  user_nodepool = {
    enabled      = true
    vm_size      = "Standard_D4s_v3"
    os_disk_type = "Managed"
    min_count    = 1
    max_count    = 1
  }
}
