param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$VWanName
)

# Set error action preference
$ErrorActionPreference = "Stop"

try {
    # Get the Virtual WAN
    Write-Host "Getting Virtual WAN '$VWanName' in resource group '$ResourceGroupName'..." -ForegroundColor Cyan
    $vwan = Get-AzVirtualWan -ResourceGroupName $ResourceGroupName -Name $VWanName

    if (-not $vwan) {
        Write-Host "Virtual WAN '$VWanName' not found in resource group '$ResourceGroupName'" -ForegroundColor Red
        exit 1
    }

    Write-Host "Found Virtual WAN: $($vwan.Name)" -ForegroundColor Green

    # Get all Virtual Hubs in the Virtual WAN
    Write-Host "`nGetting Virtual Hubs..." -ForegroundColor Cyan
    $hubs = Get-AzVirtualHub -ResourceGroupName $ResourceGroupName | Where-Object { $_.VirtualWanId -eq $vwan.Id }

    if ($hubs) {
        Write-Host "Found $($hubs.Count) Virtual Hub(s)" -ForegroundColor Green

        foreach ($hub in $hubs) {
            Write-Host "`n--- Processing Hub: $($hub.Name) ---" -ForegroundColor Yellow

            # Get all VNET connections in the hub
            Write-Host "Getting VNET connections in hub '$($hub.Name)'..." -ForegroundColor Cyan
            $vnetConnections = Get-AzVirtualHubVnetConnection -ResourceGroupName $ResourceGroupName -VirtualHubName $hub.Name

            if ($vnetConnections) {
                Write-Host "Found $($vnetConnections.Count) VNET connection(s)" -ForegroundColor Green

                foreach ($connection in $vnetConnections) {
                    Write-Host "Deleting VNET connection: $($connection.Name)..." -ForegroundColor Cyan
                    Remove-AzVirtualHubVnetConnection -ResourceGroupName $ResourceGroupName `
                        -VirtualHubName $hub.Name `
                        -Name $connection.Name `
                        -Force
                    Write-Host "Successfully deleted VNET connection: $($connection.Name)" -ForegroundColor Green
                }
            }
            else {
                Write-Host "No VNET connections found in hub '$($hub.Name)'" -ForegroundColor Gray
            }

            # Delete the Virtual Hub
            Write-Host "Deleting Virtual Hub: $($hub.Name)..." -ForegroundColor Cyan
            Remove-AzVirtualHub -ResourceGroupName $ResourceGroupName -Name $hub.Name -Force
            Write-Host "Successfully deleted Virtual Hub: $($hub.Name)" -ForegroundColor Green
        }
    }
    else {
        Write-Host "No Virtual Hubs found in Virtual WAN '$VWanName'" -ForegroundColor Gray
    }

    # Delete the Virtual WAN
    Write-Host "`nDeleting Virtual WAN: $($vwan.Name)..." -ForegroundColor Cyan
    Remove-AzVirtualWan -ResourceGroupName $ResourceGroupName -Name $VWanName -Force
    Write-Host "Successfully deleted Virtual WAN: $VWanName" -ForegroundColor Green

    Write-Host "`n✓ Cleanup completed successfully!" -ForegroundColor Green
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
