# Configure the Azure Provider
provider "azurerm" {
}

# Create a resource group
resource "azurerm_resource_group" "test" {
  name     = "RT-Terraform-test"
  location = "westeurope"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "test" {
  name                = "net"
  resource_group_name = "${azurerm_resource_group.test.name}"
  location            = "${azurerm_resource_group.test.location}"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "test" {
  name                 = "subnet"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "test" {
  name                    = "PubIP"
  location                = "${azurerm_resource_group.test.location}"
  resource_group_name     = "${azurerm_resource_group.test.name}"
  allocation_method       = "Dynamic"
}

resource "azurerm_network_security_group" "test" {
    name                = "myNetworkSecurityGroup"
    location            = "${azurerm_resource_group.test.location}"
    resource_group_name = "${azurerm_resource_group.test.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}


resource "azurerm_network_interface" "test" {
    name                      = "myNIC"
    location                  = "${azurerm_resource_group.test.location}"
    resource_group_name       = "${azurerm_resource_group.test.name}"
    network_security_group_id = "${azurerm_network_security_group.test.id}"

    ip_configuration {
        name                          = "monip"
        subnet_id                     = "${azurerm_subnet.test.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.test.id}"
    }
}

resource "azurerm_virtual_machine" "test" {
  name                  = "test-vm"
  location              = "${azurerm_resource_group.test.location}"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  network_interface_ids = ["${azurerm_network_interface.test.id}"]
  vm_size               = "Standard_A0"

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.1"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

data "azurerm_public_ip" "test" {
  name                = "${azurerm_public_ip.test.name}"
  resource_group_name = "${azurerm_virtual_machine.test.resource_group_name}"
}

output "public_ip_address" {
  value = "${data.azurerm_public_ip.test.ip_address}"
}
