Clear-Host

$port = Read-Host "Enter the port number to check"

Write-Host "Checking port $port..."

# Buscar conexiones TCP activas
$connection = Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -eq $port }

if ($connection) {
    Write-Host "Port $port is OPEN."

    # Buscar servicio en la tabla de servicios
    $service = (Get-Content "$env:SystemRoot\System32\drivers\etc\services" `
        | Select-String -Pattern " $port/" | Select-Object -First 1)

    if ($service) {
        Write-Host "Service associated: $service"
    }
    else {
        Write-Host "No service entry found in services file."
    }
}
else {
    Write-Host "Port $port is CLOSED or not in LISTEN state."
}
