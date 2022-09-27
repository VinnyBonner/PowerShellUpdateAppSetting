# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

$Subscription = "<SubscriptionId>"
$ResourceGroup = "<ResourceGroupName>"
$FunctionAppName = "<FunctionAppName>"

# Enable system assigned identity on the function app and ensure it has permissions to the specific resource
Connect-AzAccount -Identity

# if you need to use a different subscription then the main one.
Set-AzContext -Subscription $Subscription

$webapp = Get-AzWebApp -ResourceGroupName $ResourceGroup -Name $FunctionAppName

# create new app setting KeyPairValue
$newAppSetting = @{name = "mysettingname"; value="myvalue"}

# Get current app settings
$appSettings = $webapp.SiteConfig.AppSettings

# Add new app setting to the current app settings
$appSettings.add($newAppSetting)

#Convert App Settings into a HashTable
$h = @{}
$appSettings | ForEach-Object {
    $h[$_.Name] = $_.Value
}

# Set App Settings 
Set-AzWebApp -ResourceGroupName $ResourceGroup -Name $FunctionAppName -AppSettings $h

Write-Host "Completed"

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
