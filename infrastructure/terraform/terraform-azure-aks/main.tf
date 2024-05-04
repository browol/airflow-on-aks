locals {
  client                    = "browol"
  stack                     = "infra"
  environment               = "dev"
  environment_short         = "d"
  location                  = "southeastasia"
  location_short            = "sa1"
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
  tags = {
    client      = local.client
    environment = local.environment
    stack       = local.stack
  }
  naming_suffix = split(
    "-",
    format("%s-%s-%s-%s", local.environment_short, local.location_short, local.client, local.stack)
  )
}

module "region" {
  source       = "claranet/regions/azurerm"
  version      = "7.0.0"
  azure_region = local.location
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  suffix  = local.naming_suffix
}

resource "azurerm_resource_group" "rg" {
  name     = module.naming.resource_group.name
  location = module.region.location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = module.naming.log_analytics_workspace.name_unique
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags

  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_container_registry" "acr" {
  name                = module.naming.container_registry.name_unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags
  sku                 = "Basic"
  admin_enabled       = false
}

# vnet
resource "azurerm_virtual_network" "vnet" {
  name                = module.naming.virtual_network.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [local.vnet_addr_prefix]
  tags                = azurerm_resource_group.rg.tags

  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_network_security_group" "default" {
  name                = module.naming.network_security_group.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# subnet
resource "azurerm_subnet" "nodepool" {
  name                 = format("%s-%s-%s", "privint", "0", "nodepool")
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.subnet_addr_prefix]

  depends_on = [
    azurerm_virtual_network.vnet,
  ]
}

resource "azurerm_subnet_network_security_group_association" "nodepool_default" {
  subnet_id                 = azurerm_subnet.nodepool.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = module.naming.kubernetes_cluster.name_unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags
  node_resource_group = format("%s-%s", module.naming.resource_group.name, "nodepool")
  sku_tier            = "Free"
  kubernetes_version  = "1.29"

  # Advanced Settings
  azure_policy_enabled   = true
  local_account_disabled = true

  # ERROR: Preview feature Microsoft.ContainerService/NodeOSUpgradeChannelPreview not registered.
  # node_os_channel_upgrade = "SecurityPatch"

  # Accessibility Cluster Settings
  private_cluster_enabled             = false
  private_cluster_public_fqdn_enabled = false
  dns_prefix                          = module.naming.kubernetes_cluster.name_unique

  # System Node Pool
  default_node_pool {
    name                        = "system"
    temporary_name_for_rotation = "tempsys"
    vm_size                     = local.system_nodepool.vm_size
    os_sku                      = "Ubuntu"
    os_disk_type                = local.system_nodepool.os_disk_type
    zones                       = ["1", "2", "3"]
    enable_auto_scaling         = true
    min_count                   = local.system_nodepool.min_count
    max_count                   = local.system_nodepool.max_count
    vnet_subnet_id              = azurerm_subnet.nodepool.id


    // Make sure you've enabled the EncryptionAtHost feature
    // Otherwise, run `az feature register --name EncryptionAtHost --namespace Microsoft.Compute`
    enable_host_encryption = true

    # ERROR: Enabling this will cause the command executor pod to enter a pending state.
    # only_critical_addons_enabled = true

    upgrade_settings {
      max_surge = "10%"
    }

    # ERROR: Preview feature Microsoft.ContainerService/KubeletDisk not registered.
    # kubelet_disk_type            = "Temporary"
  }

  network_profile {
    network_plugin    = "kubenet"
    network_policy    = "calico"
    outbound_type     = "loadBalancer"
    pod_cidr          = "172.16.0.0/16"
    service_cidr      = "172.17.0.0/16"
    dns_service_ip    = "172.17.0.4"
    load_balancer_sku = "standard"
    ip_versions = [
      "IPv4",
    ]

    load_balancer_profile {
      idle_timeout_in_minutes   = 30
      managed_outbound_ip_count = 1
    }
  }

  azure_active_directory_role_based_access_control {
    managed = true
    admin_group_object_ids = [
      local.aad_admin_group_object_id,
    ]
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }

  storage_profile {
    blob_driver_enabled         = true
    disk_driver_enabled         = true
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.kubelet.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.kubelet.id
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aks.id,
    ]
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "5m"
  }

  depends_on = [
    azurerm_role_assignment.aks_managed_kubelet,
    azurerm_log_analytics_workspace.law,
    azurerm_subnet.nodepool,
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "app" {
  count        = local.user_nodepool.enabled ? 1 : 0
  name         = "app"
  vm_size      = local.user_nodepool.vm_size
  os_type      = "Linux"
  os_sku       = "Ubuntu"
  os_disk_type = local.user_nodepool.os_disk_type

  zones                 = ["1", "2", "3"]
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = azurerm_subnet.nodepool.id
  tags                  = local.tags

  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]

  node_labels = {
    role = "worker"
  }

  # Auto Scaling
  enable_auto_scaling = true
  min_count           = local.user_nodepool.min_count
  max_count           = local.user_nodepool.max_count

  # Spot Discount
  priority        = "Spot"
  eviction_policy = "Deallocate"
  spot_max_price  = "-1"

  # ERROR: Spot pools can't set max surge
  # upgrade_settings {
  #   max_surge = "10%"
  # }

  // Make sure you've enabled the EncryptionAtHost feature
  // Otherwise, run `az feature register --name EncryptionAtHost --namespace Microsoft.Compute`
  enable_host_encryption = true

  depends_on = [
    azurerm_kubernetes_cluster.aks,
  ]
}

resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = module.naming.monitor_diagnostic_setting.name_unique
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "guard"
  }

  enabled_log {
    category = "kube-audit-admin"
  }

  enabled_log {
    category = "csi-azuredisk-controller"
  }

  enabled_log {
    category = "csi-azurefile-controller"
  }

  enabled_log {
    category = "cloud-controller-manager"
  }

  enabled_log {
    category = "kube-apiserver"
  }

  metric {
    category = "AllMetrics"
  }

  lifecycle {
    ignore_changes = [
      log,
      metric,
    ]
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    azurerm_log_analytics_workspace.law,
  ]
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = format("%s-%s", module.naming.user_assigned_identity.name, "aks")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_user_assigned_identity" "kubelet" {
  name                = format("%s-%s", module.naming.user_assigned_identity.name, "kubelet")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_role_assignment" "aks_managed_kubelet" {
  scope                = azurerm_user_assigned_identity.kubelet.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "kubelet_acr" {
  principal_id                     = azurerm_user_assigned_identity.kubelet.principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true

  depends_on = [
    azurerm_container_registry.acr,
    azurerm_user_assigned_identity.kubelet,
  ]
}

output "command" {
  value       = "az aks command invoke --resource-group ${azurerm_kubernetes_cluster.aks.resource_group_name} --name ${azurerm_kubernetes_cluster.aks.name} --command ..."
  description = "Example command for remote execution in private Kubernetes cluster"
}
