terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
    backend "azurerm" {
        resource_group_name  = "devops_terra_gr"
        storage_account_name = "terraformkc29"
        container_name       = "tfstatedowd"
        key                  = "terraform.tfstate"
    }

}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

# Create our Resource Group - Jonnychipz-RG
resource "azurerm_resource_group" "rg" {
  name     = "kchp2990-app01"
  location = "UK South"
}
# Create our Virtual Network - Jonnychipz-VNET
resource "azurerm_virtual_network" "vnet" {
  name                = "kchp29vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
# Create our Subnet to hold our VM - Virtual Machines
resource "azurerm_subnet" "sn" {
  name                 = "VM"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Create our Azure Storage Account - jonnychipzsa
resource "azurerm_storage_account" "kchp29090sa" {
  name                     = "kchp29090sa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = "kchpenv1"
  }
}
# Create our vNIC for our VM and assign it to our Virtual Machines Subnet
resource "azurerm_network_interface" "vmnic" {
  name                = "kchp29vm01nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sn.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Create our Virtual Machine - Jonnychipz-VM01
resource "azurerm_virtual_machine" "kchp2998vm01" {
  name                  = "kchp2998vm01"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vmnic.id]
  vm_size               = "Standard_B2s"
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core-smalldisk"
    version   = "latest"
  }
  storage_os_disk {
    name              = "kchp2998vm01os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "kchp2998vm01"
    admin_username = "kchp"
    admin_password = "Mynps123@"
  }
  os_profile_windows_config {
  }
}
