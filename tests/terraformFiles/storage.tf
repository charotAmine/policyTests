resource "random_id" "id" {
	  byte_length = 8
}
resource "azurerm_resource_group" "testStorageRG" {
  name     = "${random_id.id.hex}-policy"
  location = "West Europe"
}

resource "azurerm_storage_account" "testStorage" {
  name                     = "001storagepolicytest"
  resource_group_name      = azurerm_resource_group.testStorageRG.name
  location                 = azurerm_resource_group.testStorageRG.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}