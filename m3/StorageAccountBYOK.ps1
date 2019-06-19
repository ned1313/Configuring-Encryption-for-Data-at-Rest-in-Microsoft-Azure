#Prefix for resources
$prefix = "ced"

#Location for resources
$location = "eastus"

#Random ID for Key Vault
$id = Get-Random -Minimum 1000 -Maximum 9999

#Log into Azure
Add-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "SUB_NAME" | Select-AzSubscription

#Create a resource group for Key Vault
$keyVaultGroup = New-AzResourceGroup -Name "$prefix-key-vault" -Location $location

#Create a new Key Vault
$keyVaultParameters = @{
    Name = "$prefix-key-vault-$id"
    ResourceGroupName = $keyVaultGroup.ResourceGroupName
    Location = $location
    EnableSoftDelete= $true
    EnablePurgeProtection = $true
    Sku = "Standard"
}
$keyVault = New-AzKeyVault @keyVaultParameters

#Create a new key for storage account SSE
$sseKey = Add-AzKeyVaultKey -VaultName $keyVault.VaultName -Name "sseKey" -Destination Software

#Create a resource group for the storage account
$saGroup = New-AzResourceGroup -Name "$prefix-storage-account" -Location $location

#Create the storage account
$saName = "sa$prefix$id".ToLower()
$saParameters = @{
    ResourceGroupName = $saGroup.ResourceGroupName
    Name = $saName
    SkuName = "Standard_LRS"
    Location = $location
    Kind = "StorageV2"
}
$sa = New-AzStorageAccount @saParameters

#View the current encryption properties of the storage account
$sa.Encryption

#Create an identity for the Storage Account
$sa = Set-AzStorageAccount -ResourceGroupName $sa.ResourceGroupName -Name $sa.StorageAccountName -AssignIdentity

#Grant the Storage Account identity access to the Key Vault key
$accessPolicy = @{
    VaultName = $keyVault.VaultName
    ObjectId = $sa.Identity.PrincipalId
    PermissionsToKeys = @("wrapKey","unwrapKey","get","recover")
}
Set-AzKeyVaultAccessPolicy @accessPolicy

#Update the storage account with the Key Vault key
$saParameters = @{
    ResourceGroupName = $sa.ResourceGroupName
    AccountName = $sa.StorageAccountName
    KeyVaultEncryption = $true
    KeyName = $sseKey.Name
    KeyVersion = $sseKey.Version
    KeyVaultUri = $keyVault.VaultUri
}
$sa = Set-AzStorageAccount @saParameters

#View the properties of the storage account again
$sa.Encryption
$sa.Encryption.KeyVaultProperties
