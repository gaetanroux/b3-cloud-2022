terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-b3-node" {
  name     = "b3-node"
  location = "eastus"
}

resource "azurerm_virtual_network" "vn-b3-node" {
  name                = "b3-node"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-b3-node.location
  resource_group_name = azurerm_resource_group.rg-b3-node.name
}

resource "azurerm_subnet" "s-b3-vm1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg-b3-node.name
  virtual_network_name = azurerm_virtual_network.vn-b3-node.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "node1_public_ip" {
  name                = "node1-public-ip"
  resource_group_name = azurerm_resource_group.rg-b3-node.name
  location            = azurerm_resource_group.rg-b3-node.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic-node1" {
  name                = "node1"
  location            = azurerm_resource_group.rg-b3-node.location
  resource_group_name = azurerm_resource_group.rg-b3-node.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.s-b3-vm1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.node1_public_ip.id
  }
}

resource "azurerm_network_interface" "nic-node2" {
  name                = "node2"
  location            = azurerm_resource_group.rg-b3-node.location
  resource_group_name = azurerm_resource_group.rg-b3-node.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.s-b3-vm1.id
    private_ip_address_allocation = "Dynamic"
  }
}



resource "azurerm_linux_virtual_machine" "vm-node1" {
  name                = "node1"
  resource_group_name = azurerm_resource_group.rg-b3-node.name
  location            = azurerm_resource_group.rg-b3-node.location
  size                = "Standard_B1s"
  admin_username      = "node1"
  network_interface_ids = [
    azurerm_network_interface.nic-node1.id,
  ]

  admin_ssh_key {
    username   = "node1"
    public_key = file("C:/Users/gaeta/.ssh/id_rsa.pub")
  }


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "vm-node2" {
  name                = "node2"
  resource_group_name = azurerm_resource_group.rg-b3-node.name
  location            = azurerm_resource_group.rg-b3-node.location
  size                = "Standard_B1s"
  admin_username      = "node2"
  network_interface_ids = [
    azurerm_network_interface.nic-node2.id,
  ]

  admin_ssh_key {
    username   = "node2"
    public_key = file("C:/Users/gaeta/.ssh/id_rsa.pub")
  }


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "procomputers"
    offer     = "rocky-linux-9-1"
    sku       = "rocky-linux-9-1"
    version   = "latest"
  }
}
