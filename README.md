# VIctory Series S para pouca RAM e NVIDIA

Build do [VIctory](https://github.com/Marvisak/VIctory) (camada que roda um título de Xbox Series no Windows) ajustado para PCs com 24 GB de RAM e placas NVIDIA. A base é o fork [avatarmanz/VIctory-7900XTX](https://github.com/avatarmanz/VIctory-7900XTX) no commit `85d5641`.

**Este repositório não contém arquivos do jogo.** Você precisa do seu próprio dump.

## Download

Clique em **Code → Download ZIP** nesta página. O zip traz o `victory.exe`, o lançador e o código-fonte completo (em `source/`).

## Como rodar

1. Instale o Microsoft Visual C++ Redistributable x64 (2015-2022).
2. Extraia o zip dentro da pasta do seu dump, ao lado do `game_scarlett_master.exe`.
3. Na primeira vez (e a cada versão nova), dê dois cliques em `Preparar-Shaders.cmd` e espere terminar. Leva alguns minutos e evita imagem errada (água cinza, borrões) e engasgos na primeira passagem por cada lugar.
4. Dê dois cliques em `Play-VIctory.cmd`, ou rode no PowerShell, dentro da pasta extraída:
   ```powershell
   .\Play-VIctory.cmd
   ```
   Se a pasta estiver em outro lugar, indique o jogo antes:
   ```powershell
   $env:VICTORY_GAME_DIR = 'D:\Jogos\MeuDump'
   .\Play-VIctory.cmd
   ```
5. Se a placa tiver 12-16 GB de VRAM, dá para subir a resolução:
   ```powershell
   $env:VICTORY_RENDER_SCALE = '0.75'; $env:VICTORY_CARD_BUFFERS_MB = '2048'
   ```
6. Se der bug, rode o diagnóstico. Ele grava o log completo e a memória, e gera um zip para enviar:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Diagnostico.ps1
   ```

Requisitos: Windows 10/11 x64, CPU com AVX2, placa Direct3D 12 com Shader Model 6.6 e mesh shaders.

## O que muda em relação ao avatarmanz 85d5641

| Mudança | Origem |
| --- | --- |
| Series S em NVIDIA: compõe o plano da interface (sem isso a tela fica preta), upscaler próprio, escala de render | `7997a20`, `a9632bc`, `afd84de` de [trustno1-coder/VIctory-NVIDIA](https://github.com/trustno1-coder/VIctory-NVIDIA) |
| Rostos em NVIDIA: valores de 16 bits lidos por views inteiras (cabeças sumindo) | port de `77e13a9` do VIctory-NVIDIA; a parte de cor de alvo ficou de fora |
| Modo de pouca RAM (`VICTORY_LOW_RAM`, liga sozinho com 24 GB ou menos; `VICTORY_LOW_RAM=0` desliga): caches ociosos por 15 s em vez de 5-10 min, janelas de 1 MiB, pool de snapshots e sobra de rascunho com 128 MiB | nosso |
| O log diz o estágio e o tamanho de cada shader recusado | nosso |
| Do [Belobug/VIctory-Belobug-AMD](https://github.com/Belobug/VIctory-Belobug-AMD): sombras em cascata certas na NVIDIA (wave32), interpolação por atributo, luz dos cômodos estabilizada pelo tempo, janelas limitadas quando a RAM aperta, busca rápida na submissão, uma barreira por buffer | `4fd34fd`, `0dc5d1b`, `b4ba4bb`, `ffc2cf6`, `306722b`, `773d902` e outros |
| Do Belobug, desligado por padrão (testar): Port 1, a memória gráfica do jogo usada direto, menos CPU | `86dc109`, `4b82f6c`, com `VICTORY_PORT_CONSTANTS=1` |

A lista completa de commits está em [`MUDANCAS.txt`](MUDANCAS.txt) e o código completo em [`source/`](source).

### Testes opcionais

Para testar o Port 1 (menos CPU; não confirmado em NVIDIA), antes de rodar:
```powershell
$env:VICTORY_PORT_CONSTANTS = '1'
```
Se aparecerem blocos ou texturas erradas, teste desligar a atualização sem espera:
```powershell
$env:VICTORY_TEXTURE_NO_WAIT = '0'
```

## Estado

Testado numa RTX 4060 Ti 8 GB com 24 GB de RAM: Series S, cerca de 5 fps. Numa RTX 5070 Ti: cerca de 8 fps. Problemas conhecidos: interiores escuros sem ray tracing, imagem um pouco borrada na escala 0,5 e luz estourada em alguns pontos.

## Licença e créditos

GPL-3.0-or-later, como o VIctory (ver [LICENSE](LICENSE) e [asset-policy.md](asset-policy.md)). Créditos a Marvisak/VIctory e colaboradores, fxceless, avatarmanz, trustno1-coder, myokex, Belobug, uiliannn e aos demais forks citados no histórico. Feito com ajuda de IA (Claude Code).

## Preset (`preset.cmd`)

O `Play-VIctory.cmd` e o `Preparar-Shaders.cmd` usam o mesmo `preset.cmd`, para o cache de shaders preparado valer na hora de jogar. Toda variável definida antes (`$env:...`) vence o valor do preset. Destaques:

- `VICTORY_NAN_SCRUB=1`: valores inválidos dos shaders de pele viram 0 (ruído colorido nos rostos em NVIDIA).
- `VICTORY_AMBIENT_AIR=0.5` e `VICTORY_AMBIENT_SETTLE=250,3`: menos névoa estourada e luz sem saltos.

Depois de atualizar, rode o `Preparar-Shaders.cmd` de novo.
