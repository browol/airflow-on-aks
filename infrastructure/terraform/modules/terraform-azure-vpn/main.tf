locals {
  client                    = "browol"
  stack                     = "vpn"
  environment               = "dev"
  environment_short         = "d"
  location                  = "southeastasia"
  location_short            = "sa1"
  aad_admin_group_object_id = "96c4ca86-584a-4584-9923-ac463c8b88af"
  vnet_addr_prefix          = "10.0.0.0/16"
  subnet_addr_prefix        = "10.0.1.0/24"
  vpn_client_cidrs          = ["10.2.0.0/24"]
  certificate_name          = "certs/stripped.crt"
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

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "rg" {
  name     = module.naming.resource_group.name
  location = module.region.location
  tags     = local.tags
}

resource "azurerm_key_vault" "kv" {
  name                = module.naming.key_vault.name_unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = local.aad_admin_group_object_id

    certificate_permissions = [
      "Backup",
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "Recover",
      "Restore",
      "SetIssuers",
      "Update"
    ]

    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
      "Release",
      "Rotate",
      "GetRotationPolicy",
      "SetRotationPolicy"
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]

    storage_permissions = [
      "Backup",
      "Delete",
      "DeleteSAS",
      "Get",
      "GetSAS",
      "List",
      "ListSAS",
      "Purge",
      "Recover",
      "RegenerateKey",
      "Restore",
      "Set",
      "SetSAS",
      "Update"
    ]
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

# Create a Secret for the VPN Root certificate
resource "azurerm_key_vault_secret" "vpn_root_certificate" {
  name         = "vpn-p2s-root-certificate"
  value        = file(local.certificate_name)
  key_vault_id = azurerm_key_vault.kv.id
  tags         = local.tags

  depends_on = [
    azurerm_key_vault.kv,
  ]

  provisioner "local-exec" {
    command = "/bin/sh generate-certificate.sh"
  }
}

# Create a Public IP for the Gateway
resource "azurerm_public_ip" "gateway_pip" {
  name                = module.naming.public_ip.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = local.tags
}

# Create VPN Gateway
resource "azurerm_virtual_network_gateway" "gateway" {
  name                = module.naming.virtual_network_gateway.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2"
  generation    = "Generation2"

  ip_configuration {
    name                          = module.naming.virtual_network.name
    public_ip_address_id          = azurerm_public_ip.gateway_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }

  vpn_client_configuration {
    address_space        = local.vpn_client_cidrs
    vpn_auth_types       = ["AAD", "Certificate"]
    vpn_client_protocols = ["OpenVPN"]
    aad_tenant           = format("https://login.microsoftonline.com/%s", data.azurerm_client_config.current.tenant_id)
    aad_issuer           = format("https://sts.windows.net/%s/", data.azurerm_client_config.current.tenant_id)
    aad_audience         = "41b23e61-6c1e-4545-b367-cd054e0ed4b4" # Azure Public

    root_certificate {
      name             = "vpn-p2s-root-certificate"
      public_cert_data = azurerm_key_vault_secret.vpn_root_certificate.value
    }
  }
}

# Create the VNET
resource "azurerm_virtual_network" "vnet" {
  name                = module.naming.virtual_network.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  address_space = [local.vnet_addr_prefix]
}

# Create a Gateway Subnet
resource "azurerm_subnet" "gateway" {
  name                = "GatewaySubnet" # do not change the name
  resource_group_name = azurerm_resource_group.rg.name

  address_prefixes     = [local.subnet_addr_prefix]
  virtual_network_name = azurerm_virtual_network.vnet.name
}
