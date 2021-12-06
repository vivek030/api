
$email = Read-Host 'enter email id'
$id = hostname
$api = Read-Host 'enter api key'
$json = @"
{\"Email\":\"$email\",\"Identifier\":\"$id\"}
"@
curl.exe  -f -k -X POST "http://167.71.237.148:8080/api/v1/provisioning/peers" -H "accept: text/plain" -H "authorization: Basic $api" -H "Content-Type: application/json" -d $json -o "C:\krpl.conf"
Start-Process msiexec.exe -ArgumentList '/q','DO_NOT_LAUNCH=True','/I', 'https://download.wireguard.com/windows-client/wireguard-amd64-0.4.9.msi' -Wait -NoNewWindow -PassThru | Out-Null
Start-Process 'C:\Program Files\WireGuard\wireguard.exe' -ArgumentList '/installtunnelservice', '"C:\krpl.conf"' -Wait -NoNewWindow -PassThru | Out-Null
Start-Process sc.exe -ArgumentList 'config', 'WireGuardTunnel$krpl', 'start= delayed-auto' -Wait -NoNewWindow -PassThru | Out-Null
Start-Service -Name WireGuardTunnel$krpl -ErrorAction SilentlyContinue