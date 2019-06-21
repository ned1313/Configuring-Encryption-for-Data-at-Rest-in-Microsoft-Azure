#Prefix for resources
$prefix = "ced"

#Log into Azure
Add-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "SUB_NAME" | Select-AzSubscription

#Let's create an existing Windows VM that we will encrypt
$Location = "eastus"
$ResourceGroupName = "$prefix-windows-vm"
$VMName = "$prefix-win-vm"
$id = Get-Random -Minimum 1000 -Maximum 9999

$WinVMParameters = @{
    adminUsername = "winadmin"
    adminPassword = 'n6Uz^)N.d!j+uE'
    dnsName = "$prefix$id"
    vmName = $VMName
}

$vmRG = New-AzResourceGroup -Name $ResourceGroupName -Location $Location

New-AzResourceGroupDeployment -Name "winVM" -ResourceGroupName $ResourceGroupName -TemplateParameterObject $WinVMParameters -TemplateFile .\m4\WindowsVM\windows-vm-data-disk.json -Mode Incremental

#Log into the VM and initialize/format the data disk

#Now provision a Key Vault if you don't already have one

#Create a new Key Vault
$keyVaultParameters = @{
    Name = "$prefix-key-vault-$id"
    ResourceGroupName = $vmRG.ResourceGroupName
    Location = $location
    EnabledForDiskEncryption = $true
    EnabledForDeployment = $true
    Sku = "Standard"
}
$keyVault = New-AzKeyVault @keyVaultParameters

$DiskEncryptionParameters = @{
    ResourceGroupName = $vmRG.ResourceGroupName
    VMname = $VMName
    DiskEncryptionKeyVaultUrl = $keyVault.VaultUri
    DiskEncryptionKeyVaultId = $keyVault.ResourceId
    VolumeType = "All"
}

 Set-AzVMDiskEncryptionExtension @DiskEncryptionParameters

 Get-AzVmDiskEncryptionStatus -ResourceGroupName $vmRG.ResourceGroupName -VMName $VMName


