Trace-VstsEnteringInvocation $MyInvocation

# Initialize Azure.
Import-Module $PSScriptRoot\ps_modules\VstsAzureHelpers_
Initialize-Azure
$path = $MyInvocation.MyCommand.Path -replace "deleteresourcegroup.ps1",""
$rgName = Get-VstsInput -Name resourceGroupName -Require

$rg = Get-AzureRmResourceGroup -Name $rgName -ErrorAction SilentlyContinue

if ($rg)
{    
    $count = @(Get-AzureRmResource | Where-Object { $_.ResourceGroupName -ceq $rgName }).Count;

    if ($count -eq 0)
    { 
        Write-Output "The Resource Group has no resources. Deleting it..."; 
        Remove-AzureRmResourceGroup -Name $rgName -Force; 
    } 
    else
    { 
        Write-Output "The Resource Group $rgName has $count resources, it will NOT be deleted"; 
    }
}
else 
{
        Write-Host "The Resource Group $rgName was not found" 
}

Write-Host "End of Task Delete Resource Group if it is empty" 

#thanks to Pascal Naber for his support!