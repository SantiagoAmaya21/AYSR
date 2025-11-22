Clear-Host

function Show-Header {
    Write-Host "==============================================" 
    Write-Host "         Network Information Utility"
    Write-Host "=============================================="
}

function Show-Interfaces {
    Write-Host "---- Network Interfaces ----"
    Get-NetAdapter | Format-Table Name, Status, LinkSpeed, MacAddress
}

function Show-IPInfo {
    Write-Host "---- IP Configuration ----"
    Get-NetIPConfiguration | Format-List
}

function Show-Routes {
    Write-Host "---- Routing Table ----"
    Get-NetRoute | Format-Table -AutoSize
}

function Show-Connections {
    Write-Host "---- Active TCP/UDP Connections ----"
    Get-NetTCPConnection | Format-Table -AutoSize
    Get-NetUDPEndpoint   | Format-Table -AutoSize
}

function Show-InterfaceDetail {
    $iface = Read-Host "Enter interface name"
    Write-Host "---- Details for $iface ----"
    Get-NetAdapter -Name $iface | Format-List
    Get-NetIPAddress -InterfaceAlias $iface | Format-List
}

while ($true) {
    Show-Header
    Write-Host "1) Show network interfaces"
    Write-Host "2) Show IP configuration"
    Write-Host "3) Show routing table"
    Write-Host "4) Show active connections"
    Write-Host "5) Show details of a specific interface"
    Write-Host "0) Exit"
    $opt = Read-Host "Select an option"

    switch ($opt) {
        1 { Show-Interfaces }
        2 { Show-IPInfo }
        3 { Show-Routes }
        4 { Show-Connections }
        5 { Show-InterfaceDetail }
        0 { Write-Host "Exiting..."; exit }
        default { Write-Host "Invalid option." }
    }

    Write-Host ""
    Read-Host "Press Enter to continue..."
    Clear-Host
}
