# Cacar-Shader.ps1

# Busca binaria do shader (pipeline) que causa um bug visual, no PC do jogador.

#

# Como funciona:

#   1. Le known-pipelines.bin e known-shaders.bin da pasta de cache do VIctory

#      (gravados com VICTORY_PIPELINE_BOOK=1) e lista os shaders de pixel e de compute

#      (vertex e mesh nunca entram na lista, para nao quebrar a cena inteira).

#   2. A cada rodada, pula a metade da lista (VICTORY_SKIP_PIPELINES), abre o jogo

#      pelo Play-VIctory.cmd e espera voce fechar.

#   3. Pergunta "o bug ainda aparece?" e corta a lista ao meio pelo resultado.

#   4. Salva o estado em cacar-estado.json, para continuar depois com -Continuar.

#   5. No fim, mostra o hash culpado e gera cacar-ultimo-log.zip com o log da rodada.

#

# Requisitos: PowerShell 5.1. Precisa de um victory.exe de diagnostico (o que vem neste pacote tem).

# Ninguem roda victory.exe por este script sem voce abrir o jogo: ele so inicia o Play-VIctory.cmd.



[CmdletBinding()]

param(

    [string]$Pasta = '',

    [string]$PastaCache = (Join-Path $env:LOCALAPPDATA 'victory\cache\pipelines'),

    [string]$Estado = '',

    [switch]$Continuar,

    [switch]$SoListar

)



$ErrorActionPreference = 'Stop'
# Pasta do pacote: a do proprio arquivo (funciona tambem com dot-source).
$raiz = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $Pasta) { $Pasta = $raiz }
if (-not $Estado) { $Estado = Join-Path $Pasta 'cacar-estado.json' }



# Ordem dos estagios no arquivo (igual a STAGES em pipeline/known.rs).

$Estagios = @('vertex', 'pixel', 'domain', 'hull', 'geometry', 'compute', 'amplification', 'mesh')

$EstagioPixel = 1

$EstagioCompute = 5



function Converter-Hex([byte[]]$bytes) {

    return ([BitConverter]::ToString($bytes) -replace '-', '').ToLowerInvariant()

}



function Ler-Shaders([string]$pasta) {

    # known-shaders.bin: [estagio 1][hash 32][tamanho 4][container]. Devolve hash16 -> estagio.

    $mapa = @{}

    $arq = Join-Path $pasta 'known-shaders.bin'

    if (-not (Test-Path $arq)) { return $mapa }

    $bytes = [System.IO.File]::ReadAllBytes($arq)

    $at = 0

    while ($at + 37 -le $bytes.Length) {

        $estagio = $bytes[$at]

        $hash = New-Object byte[] 32

        [Array]::Copy($bytes, $at + 1, $hash, 0, 32)

        $tam = [BitConverter]::ToUInt32($bytes, $at + 33)

        if ($at + 37 + $tam -gt $bytes.Length) { break }

        $hash16 = (Converter-Hex $hash).Substring(0, 16)

        $mapa[$hash16] = [int]$estagio

        $at += 37 + [int]$tam

    }

    return $mapa

}



function Ler-Pipelines([string]$pasta) {
    # known-pipelines.bin: [tamanho 4][entrada]. Entrada: chave 16, n 1, n x (estagio 1 + hash 32), grafico 1, ...
    # Devolve uma lista de objetos: Chave (32 hex, a mesma do early-pipelines.txt) e Shaders.
    $saida = New-Object System.Collections.ArrayList
    $arq = Join-Path $pasta 'known-pipelines.bin'
    if (-not (Test-Path $arq)) { return ,$saida }
    $bytes = [System.IO.File]::ReadAllBytes($arq)
    $at = 0
    while ($at + 4 -le $bytes.Length) {
        $tam = [int][BitConverter]::ToUInt32($bytes, $at)
        if ($at + 4 + $tam -gt $bytes.Length) { break }
        $ini = $at + 4
        $fim = $ini + $tam
        if ($tam -ge 17) {
            $chave = (Converter-Hex ($bytes[$ini..($ini + 15)])).ToLowerInvariant()
            $p = $ini + 16
            $n = [int]$bytes[$p]
            $p++
            $shaders = New-Object System.Collections.ArrayList
            for ($i = 0; $i -lt $n; $i++) {
                if ($p + 33 -gt $fim) { break }
                $estagio = [int]$bytes[$p]
                $hash = New-Object byte[] 32
                [Array]::Copy($bytes, $p + 1, $hash, 0, 32)
                [void]$shaders.Add(@{ Estagio = $estagio; Hash16 = (Converter-Hex $hash).Substring(0, 16) })
                $p += 33
            }
            [void]$saida.Add([pscustomobject]@{ Chave = $chave; Shaders = $shaders })
        }
        $at = $fim
    }
    return ,$saida
}

function Ler-Usados([string]$pasta) {
    # early-pipelines.txt: as chaves (32 hex) dos pipelines que o jogo desenhou (o conjunto de `victory warm --used`).
    $arq = Join-Path $pasta 'early-pipelines.txt'
    $conj = @{}
    if (-not (Test-Path $arq)) { return $conj }
    foreach ($linha in (Get-Content -Path $arq)) {
        $k = $linha.Trim().ToLowerInvariant()
        if ($k.Length -gt 0) { $conj[$k] = $true }
    }
    return $conj
}

function Gerar-Candidatos([string]$pasta) {
    # Hashes de pixel e compute, sem repeticao. Com early-pipelines.txt, so os pipelines desenhados
    # (o conjunto de `victory warm --used`). Sem ele, ou se nenhum bater, todos os criados, com aviso.
    # Vertex e mesh ficam de fora.
    $usados = Ler-Usados $pasta
    $pipelines = Ler-Pipelines $pasta
    $montar = {
        param([bool]$filtrar)
        $vistos = @{}
        $lista = New-Object System.Collections.ArrayList
        $n = 0
        foreach ($pl in $pipelines) {
            if ($filtrar -and -not $usados.ContainsKey($pl.Chave)) { continue }
            $n++
            foreach ($s in $pl.Shaders) {
                if ($s.Estagio -ne $EstagioPixel -and $s.Estagio -ne $EstagioCompute) { continue }
                if (-not $vistos.ContainsKey($s.Hash16)) {
                    $vistos[$s.Hash16] = $true
                    [void]$lista.Add([pscustomobject]@{ Hash = $s.Hash16; Estagio = $Estagios[$s.Estagio] })
                }
            }
        }
        return @{ Lista = $lista; Pipelines = $n }
    }
    $usarUsados = $usados.Count -gt 0
    $r = & $montar $usarUsados
    if ($usarUsados -and $r.Lista.Count -eq 0) {
        Write-Host 'AVISO: nenhum pipeline do early-pipelines.txt existe em known-pipelines.bin. Usando todos os criados.' -ForegroundColor Yellow
        $usarUsados = $false
        $r = & $montar $false
    }
    if ($usarUsados) {
        Write-Host ("Usando os pipelines desenhados (early-pipelines.txt): {0} de {1} pipeline(s) criados." -f $r.Pipelines, $pipelines.Count) -ForegroundColor Cyan
    }
    elseif ($usados.Count -eq 0) {
        Write-Host 'AVISO: early-pipelines.txt nao encontrado. A lista tem TODOS os pipelines criados (muito maior); rode o jogo uma vez para gerar o conjunto dos usados.' -ForegroundColor Yellow
    }
    return ,$r.Lista
}

function Salvar-Estado($objeto) {

    $json = $objeto | ConvertTo-Json -Depth 6
    $enc = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText([string]$Estado, [string]($json -join "`n"), $enc)

}



function Ler-Estado {

    if (-not (Test-Path $Estado)) { return $null }

    $texto = [System.IO.File]::ReadAllText($Estado, [System.Text.Encoding]::UTF8)
    return ($texto | ConvertFrom-Json)

}



function Rodar-Rodada([string[]]$pular, [int]$numero) {
    # Abre o jogo com a lista de hashes a pular (em arquivo: a linha de comando nao aguenta milhares) e espera voce fechar.
    $logs = Join-Path $Pasta 'logs'
    if (-not (Test-Path $logs)) { New-Item -ItemType Directory -Path $logs | Out-Null }
    $log = Join-Path $logs ('rodada-{0:D2}.log' -f $numero)
    $arqPular = Join-Path $Pasta 'cacar-pular.txt'
    [System.IO.File]::WriteAllText($arqPular, (($pular -join "`n") + "`n"), (New-Object System.Text.UTF8Encoding $false))
    $env:VICTORY_SKIP_PIPELINES = '@' + $arqPular
    $play = Join-Path $Pasta 'Play-VIctory.cmd'
    Write-Host ''
    Write-Host ("Rodada {0}: pulando {1} shader(s) (lista em {2}). Feche o jogo quando o bug aparecer ou sumir." -f $numero, $pular.Count, $arqPular) -ForegroundColor Cyan
    Start-Process -FilePath 'cmd.exe' -ArgumentList @('/c', ('"{0}" > "{1}" 2>&1' -f $play, $log)) -WorkingDirectory $Pasta -Wait
    Remove-Item Env:VICTORY_SKIP_PIPELINES -ErrorAction SilentlyContinue
    return $log
}

function Perguntar-Bug {

    while ($true) {

        $r = Read-Host 'O bug ainda aparece nessa rodada? (s/n)'

        if ($r -match '^[sSnN]$') { return ($r -match '^[sS]$') }

        Write-Host 'Responda s ou n.' -ForegroundColor Yellow

    }

}



function Compactar-Ultimo-Log([string]$log) {

    if (-not $log -or -not (Test-Path $log)) { return }

    $zip = Join-Path $Pasta 'cacar-ultimo-log.zip'

    if (Test-Path $zip) { Remove-Item $zip -Force }

    Compress-Archive -Path $log -DestinationPath $zip

    Write-Host ("Log da ultima rodada salvo em: {0}" -f $zip) -ForegroundColor Green

}



function Invoke-Principal {

    if ($SoListar) {

        $c = Gerar-Candidatos $PastaCache

        Write-Host ("{0} candidato(s) de pixel e compute em {1}" -f $c.Count, $PastaCache)

        $c | Format-Table -AutoSize

        return

    }



    $sessao = $null

    if ($Continuar) { $sessao = Ler-Estado }

    if ($null -eq $sessao) {

        $c = Gerar-Candidatos $PastaCache

        if ($c.Count -eq 0) {

            Write-Host 'Nenhum shader de pixel ou compute encontrado. Rode o jogo com VICTORY_PIPELINE_BOOK=1 antes.' -ForegroundColor Red

            return

        }

        Write-Host ("{0} candidato(s) de pixel e compute." -f $c.Count) -ForegroundColor Cyan

        Write-Host 'Aviso: pular um shader de pixel ou compute pode quebrar a cena inteira. Isso e esperado nesta busca.' -ForegroundColor Yellow

        $sessao = [pscustomobject]@{

            Candidatos = @($c | ForEach-Object { $_.Hash })

            Atual = @($c | ForEach-Object { $_.Hash })

            Rodada = 0

            Historico = @()

            Ultimo_Log = ''

        }

        Salvar-Estado $sessao

    }

    else {

        Write-Host ("Continuando: {0} shader(s) na lista, rodada {1}." -f @($sessao.Atual).Count, $sessao.Rodada) -ForegroundColor Cyan

    }



    $lista = @($sessao.Atual)

    $ultimoLog = [string]$sessao.Ultimo_Log

    while ($lista.Count -gt 1) {

        $metade = [math]::Ceiling($lista.Count / 2)

        $A = @($lista[0..($metade - 1)])

        $B = @($lista[$metade..($lista.Count - 1)])

        $sessao.Rodada = [int]$sessao.Rodada + 1

        $sessao.Atual = $lista

        Salvar-Estado $sessao



        # Pulamos A. Se o bug sumir, a culpa esta em A. Se continuar, a culpa esta em B.

        $log = Rodar-Rodada $A $sessao.Rodada

        $ultimoLog = $log

        $sessao.Ultimo_Log = $log

        $bugAinda = Perguntar-Bug

        if ($bugAinda) { $lista = $B; $resultado = 'continua (culpado em B)' }

        else { $lista = $A; $resultado = 'sumiu (culpado em A)' }

        $sessao.Historico = @($sessao.Historico) + ("rodada {0}: pulados {1}, bug {2}" -f $sessao.Rodada, $A.Count, $resultado)

        $sessao.Atual = $lista

        Salvar-Estado $sessao

        Write-Host ("Resultado: {0}. Restam {1} shader(s)." -f $resultado, $lista.Count) -ForegroundColor Cyan

    }



    if ($lista.Count -eq 1) {

        $culpado = $lista[0]

        Write-Host ''

        Write-Host ("Shader culpado (provavel): {0}" -f $culpado) -ForegroundColor Green

        Write-Host 'Para confirmar, a proxima rodada pula so esse hash; o bug deve sumir.' -ForegroundColor Green

    }

    else {

        Write-Host 'Nenhum shader restou na lista. Algo nao bateu: veja o estado em cacar-estado.json.' -ForegroundColor Red

    }

    Compactar-Ultimo-Log $ultimoLog

}



# Executa so quando o arquivo e chamado diretamente; dot-source (testes) so carrega as funcoes.

if ($MyInvocation.InvocationName -ne '.') {

    Invoke-Principal

}

