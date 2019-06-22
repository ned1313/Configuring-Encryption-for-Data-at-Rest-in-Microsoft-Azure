#Prefix for resources
$prefix = "ced"

#Log into Azure
Add-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "SUB_NAME" | Select-AzSubscription

#Let's create a SQL DB that we will encrypt
$Location = "eastus"
$ResourceGroupName = "$prefix-sql"
$id = Get-Random -Minimum 1000 -Maximum 9999
$SQLServerName = "$prefix-sql-$id"
$SQLDatabaseName = "$prefix-sql-db"
$SQLAdmin = "sqladmin"
$SQLAdminPassword = ConvertTo-SecureString -String 'n6Uz^)N.d!j+uE' -AsPlainText -Force
$SQLAdminCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SQLAdmin,$SQLAdminPassword

$MyIPAddress = Invoke-RestMethod http://ipinfo.io/json | Select -ExpandProperty ip

#Now Create a resource group
$sqlRG = New-AzResourceGroup -Name $ResourceGroupName -Location $Location

$sqlServerParameters = @{
    ResourceGroupName = $sqlRG.ResourceGroupName
    Location = $Location
    ServerName = $SQLServerName
    SqlAdministratorCredentials = $SQLAdminCredentials
}

$sqlServer = New-AzSqlServer @sqlServerParameters

$sqlFirewallParameters = @{
    ResourceGroupName = $sqlRG.ResourceGroupName
    ServerName = $sqlServer.ServerName
    FirewallRuleName = "MyIPAddress"
    StartIpAddress = $MyIPAddress
    EndIpAddress = $MyIPAddress
}

$sqlFirewall = New-AzSqlServerFirewallRule @sqlFirewallParameters

$databaseParameters = @{
    ResourceGroupName = $sqlRG.ResourceGroupName
    ServerName = $sqlServer.ServerName
    DatabaseName = $SQLDatabaseName
    RequestedServiceObjectiveName = "S0" 
    SampleName = "AdventureWorksLT"
}

$database = New-AzSqlDatabase @databaseParameters

$tdeParameters = @{
    ResourceGroupName = $sqlRG.ResourceGroupName
    ServerName = $sqlServer.ServerName
    DatabaseName = $database.DatabaseName
}

Get-AzSqlDatabaseTransparentDataEncryption @tdeParameters

Set-AzSqlDatabaseTransparentDataEncryption @tdeParameters -State Disabled
