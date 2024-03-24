locals {
  client                    = "browol"
  stack                     = "infra"
  environment               = "dev"
  environment_short         = "d"
  location                  = "southeastasia"
  location_short            = "sa1"
  vnet_addr_prefix          = "10.16.0.0/24"
  subnet_addr_prefix        = "10.16.0.0/26"
  tags = {
    client      = local.client
    environment = local.environment
    stack       = local.stack
  }
}

#####################
## KeyVault - Main ##
#####################

# Create the Azure Key Vault - globally unique - 24 characters max
resource "azurerm_key_vault" "kopi-keyvault" {
  name                = "${var.region}-${var.environment}-${var.app_name}-kv"
  location            = azurerm_resource_group.kopi-rg.location
  resource_group_name = azurerm_resource_group.kopi-rg.name

  enabled_for_deployment          = var.kv-enabled-for-deployment
  enabled_for_disk_encryption     = var.kv-enabled-for-disk-encryption
  enabled_for_template_deployment = var.kv-enabled-for-template-deployment
  tenant_id                       = var.azure-tenant-id

  sku_name = var.kv-sku-name

  tags = {
    environment = var.environment
  }

  access_policy {
    tenant_id = var.azure-tenant-id
    object_id = var.kv-full-object-id

    certificate_permissions = var.kv-certificate-permissions-full
    key_permissions         = var.kv-key-permissions-full
    secret_permissions      = var.kv-secret-permissions-full
    storage_permissions     = var.kv-storage-permissions-full
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

############################
## KeyVault Secret - Main ##
############################

# Variable for Certificate Name
locals {
  certificate-name = "${var.company}-RootCert.crt"
}

# Create a Secret for the VPN Root certificate
resource "azurerm_key_vault_secret" "vpn-root-certificate" {
  depends_on=[azurerm_key_vault.kopi-keyvault]

  name         = "vpn-root-certificate"
  value        = filebase64(local.certificate-name)
  key_vault_id = azurerm_key_vault.kopi-keyvault.id

  tags = {
    environment = var.environment
  }
}

########################
## VPN Gateway - Main ##
########################

# Read Certificate
data "azurerm_key_vault_secret" "vpn-root-certificate" {
  depends_on=[
    azurerm_key_vault.kopi-keyvault,
    azurerm_key_vault_secret.vpn-root-certificate
  ]

  name         = "vpn-root-certificate"
  key_vault_id = azurerm_key_vault.kopi-keyvault.id
}

# Create a Public IP for the Gateway
resource "azurerm_public_ip" "kopi-gateway-ip" {
  name                = "${var.region}-${var.environment}-${var.app_name}-gw-ip"
  location            = azurerm_resource_group.kopi-rg.location
  resource_group_name = azurerm_resource_group.kopi-rg.name
  allocation_method   = "Dynamic"
}

# Create VPN Gateway
resource "azurerm_virtual_network_gateway" "kopi-vpn-gateway" {
  name                = "${var.region}-${var.environment}-${var.app_name}-gw"
  location            = azurerm_resource_group.kopi-rg.location
  resource_group_name = azurerm_resource_group.kopi-rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "${var.region}-${var.environment}-${var.app_name}-vnet"
    public_ip_address_id          = azurerm_public_ip.kopi-gateway-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.kopi-gateway-subnet.id
  }

  vpn_client_configuration {
    address_space = ["10.2.0.0/24"]

    root_certificate {
      name = "VPNROOT"

      public_cert_data = data.azurerm_key_vault_secret.vpn-root-certificate.value
    }

  }
}
####################
## Network - Main ##
####################

# Create a Resource Group
resource "azurerm_resource_group" "kopi-rg" {
  name     = "${var.region}-${var.environment}-${var.app_name}-rg"
  location = var.location
  tags = {
    environment = var.environment
  }
}

# Create the VNET
resource "azurerm_virtual_network" "kopi-vnet" {
  name                = "${var.region}-${var.environment}-${var.app_name}-vnet"
  address_space       = [var.kopi-vnet-cidr]
  location              = azurerm_resource_group.kopi-rg.location
  resource_group_name   = azurerm_resource_group.kopi-rg.name
  tags = {
    environment = var.environment
  }
}

# Create a Gateway Subnet
resource "azurerm_subnet" "kopi-gateway-subnet" {
  name                 = "GatewaySubnet" # do not rename
  address_prefixes     = [var.kopi-gateway-subnet-cidr]
  virtual_network_name = azurerm_virtual_network.kopi-vnet.name
  resource_group_name  = azurerm_resource_group.kopi-rg.name
}
