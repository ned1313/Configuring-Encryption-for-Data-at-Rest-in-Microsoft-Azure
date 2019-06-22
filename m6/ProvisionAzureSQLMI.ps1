#Prefix for resources
$prefix = "ced"

#Log into Azure
Add-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "SUB_NAME" | Select-AzSubscription

#Let's create a SQL DB that we will encrypt
$Location = "eastus"
$ResourceGroupName = "$prefix-smi"
$id = Get-Random -Minimum 1000 -Maximum 9999
$SQLServerName = "$prefix-smi-$id"
$SQLDatabaseName = "$prefix-sql-db"
$SQLAdmin = "smiadmin"
$SQLAdminPassword = ConvertTo-SecureString -String 'n6Uz^)N.d!j+uE' -AsPlainText -Force

$smiRG = New-AzResourceGroup -Name $ResourceGroupName -Location $Location

#Template to use for deploying managed instance
$templateUri = "https://raw.githubusercontent.com/ned1313/Configuring-Encryption-for-Data-at-Rest-in-Microsoft-Azure/master/m6/smi-deply.json"

$templateParameters = @{
    vnetResourceName = "$prefix-vnet"
    sqlManagedInstanceName = $SQLServerName
    sqlManagedInstanceAdminLogin = $SQLAdmin
    sqlManagedInstancePassword = 'n6Uz^)N.d!j+uE'
}

New-AzResourceGroupDeployment -Name "smi-vnet" -ResourceGroupName $smiRG.ResourceGroupName -TemplateUri $templateUri -TemplateParameterObject $templateParameters -Mode Incremental

