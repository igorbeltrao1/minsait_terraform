terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.70.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Criar resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-igorminsait"
  location = "eastus2"
}

# Criação da VNet
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Deploy da Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Deploy da NSG
resource "azurerm_network_security_group" "nsgTeste" {
  name                = "nsg-teste1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsgTeste.name
}

# Associar a NSG à subnet
resource "azurerm_subnet_network_security_group_association" "nsg01" {
  subnet_id                   = azurerm_subnet.subnet.id
  network_security_group_id   = azurerm_network_security_group.nsgTeste.id
}

# Deploy do IP público
resource "azurerm_public_ip" "pip" {
  name                = "pip-vmwin01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

# Deploy da placa de rede
resource "azurerm_network_interface" "vnic" {
  name                = "nic-vm-lnx1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# Deploy da máquina virtual Linux
resource "azurerm_linux_virtual_machine" "vm1" {
  name                  = "vm-lnx1"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_F2"
  network_interface_ids = [azurerm_network_interface.vnic.id]

  admin_username                   = "igorbeltrao"
  disable_password_authentication  = false # Permitir autenticação por senha

  admin_password = "Igor123." # Defina a senha do administrador

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  custom_data = filebase64("install_docker.sh")

  tags = {
    environment = "Terraform"
  }
}

variable "ssh_public_key" {
  description = "The SSH public key for the VM"
  type        = string
}