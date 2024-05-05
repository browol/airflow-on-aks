variable "client" {
  type    = string
}

variable "stack" {
  type    = string
}

variable "environment" {
  type    = string
}

variable "environment_short" {
  type    = string
}

variable "location" {
  type    = string
}

variable "location_short" {
  type    = string
}

variable "vnet_addr_prefix" {
  type    = string
}

variable "subnet_addr_prefix" {
  type    = string
}

variable "aad_admin_group_object_id" {
  type    = string
}

variable "system_nodepool" {
  type = map(string)
  default = {
    vm_size      = "Standard_B2ms"
    os_disk_type = "Managed"
    min_count    = 1
    max_count    = 1
  }
}

variable "user_nodepool" {
  type = map(string)
  default = {
    enabled      = true
    vm_size      = "Standard_D4s_v3"
    os_disk_type = "Managed"
    min_count    = 1
    max_count    = 1
  }
}
