# VIctory Series S para pouca RAM e NVIDIA

Build do [VIctory](https://github.com/Marvisak/VIctory) (camada que roda um título de Xbox Series no Windows) ajustado para PCs com 24 GB de RAM e placas NVIDIA. A base é o fork [avatarmanz/VIctory-7900XTX](https://github.com/avatarmanz/VIctory-7900XTX) no commit `85d5641`.

**Este repositório não contém arquivos do jogo.** Você precisa do seu próprio dump.

## Download

Clique em **Code → Download ZIP** nesta página. O zip traz o `victory.exe`, o lançador e o código-fonte completo (em `source/`). O código em Rust, com histórico, também está em [flale1/VIctory-7900XTX](https://github.com/flale1/VIctory-7900XTX) (branch `series-s-lowram`).

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
5. O pacote mede a RAM e a VRAM sozinho (`hw.ps1`) e ajusta o preset:
   - **12 GB de VRAM ou mais**: 4 GB de buffers na placa e texturas esperadas (`VICTORY_TEXTURE_NO_WAIT=0`), sem rastro claro nem cenário sumindo ao girar a câmera.
   - **12 GB de VRAM ou mais**: perfil **Series X**. O jogo guarda mais coisa na memória e não descarta o que fica para trás. Ele chega a 38 GB: com limite de memória (RAM + paginação) abaixo de 48 GB, aumente a paginação ou o jogo pode fechar.
   - Se o limite for menor do que o perfil precisa (Series S: 32 GB, Series X: 48 GB), o `Play-VIctory.cmd` avisa. Para aumentar o arquivo de paginação: Exibir configurações avançadas do sistema → Desempenho → Configurações → Avançado → Memória virtual → Alterar → desmarque "Gerenciar automaticamente" → C: → Tamanho personalizado, inicial `32768` e máximo `49152` → Definir → reinicie.
   - Para forçar o Series S num PC grande: `$env:VICTORY_CONSOLE = 'series-s'` antes de rodar.
   - Com 12-16 GB de VRAM também dá para subir a resolução: `$env:VICTORY_RENDER_SCALE = '0.75'`.
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
| Shaders: leitura de primeira lane em lanes auxiliares (upstream `0601955`), buffers e imagens lidos só como dado (port parcial do corgi `53e7682`), pares wave32 e diagnóstico das duas recusas de água (VIctory-NVIDIA `f110b577`, fxceless `9613092b`) | `7886b8c9`, `bb2aaaa2`, `1511ab06`, `7df8e2cf`, `8a1932a6` |
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
- `VICTORY_AMBIENT_AIR=0.5` e `VICTORY_AMBIENT_SETTLE=250,3`: menos névoa estourada e luz sem saltos. Se a névoa ainda estourar, teste `$env:VICTORY_AMBIENT_AIR = '0.25'`.
- `VICTORY_PIPELINE_WAIT_MS=500` (era 10000): a abertura não congela esperando a placa criar pipelines novos. Algum objeto pode aparecer um instante depois.

Depois de atualizar, rode o `Preparar-Shaders.cmd` de novo.

## Series X

O padrão é o perfil Series S (menos RAM), a não ser em placa com 12 GB de VRAM ou mais, que já abre em Series X. Para jogar no perfil Series X em outro PC (mais detalhe, bem mais RAM e VRAM; recomendado só com 32 GB de RAM ou mais e placa com 12 GB de VRAM ou mais):

```powershell
.\Play-SeriesX.cmd
```

Ou, com o diagnóstico:

```powershell
$env:VICTORY_CONSOLE = 'series-x'
powershell -ExecutionPolicy Bypass -File .\Diagnostico.ps1
```

## Menos engasgos: preparar os caches

São duas etapas, cada uma feita uma vez por versão:

1. **`Preparar-Shaders.cmd`**: traduz todos os shaders do jogo (alguns minutos). Rode antes de jogar.
2. **`Aquecer-Driver.cmd`**: o jogo registra os pipelines que usa (`VICTORY_PIPELINE_BOOK=1`, já ligado no preset). Depois de jogar pelo menos uma vez, rode este script e ele prepara esses pipelines no cache do driver da placa. Rode de novo ao atualizar o driver ou o pacote. Com `Aquecer-Driver.cmd tudo`, ele prepara todos os pipelines que o jogo criou, mas isso demora muito.

Nenhum dos dois aumenta o fps médio. Eles tiram os engasgos da primeira vez em que algo aparece.

## Shaders recusados e caça a bugs de shader

- `VICTORY_WAVE_LOOSE_LDS=1` (ligado no preset): LDS aproximado em grupos de 32 threads, port de [Corgansm/victory-corgi](https://github.com/Corgansm/victory-corgi) `53e7682`. Faz funcionar na NVIDIA 5 de 9 shaders de cálculo que a placa recusava. Muda a tradução: rode o `Preparar-Shaders.cmd` de novo. Se piorar algo, desligue com `$env:VICTORY_WAVE_LOOSE_LDS = '0'` e prepare os shaders de novo.
- `VICTORY_WAVE_WIDE=1` (ligado no preset): um grupo de 64 threads do console roda como duas waves de 32 da NVIDIA, com barreiras. Os shaders de cálculo que ficavam presos em 64 e eram recusados (água em blocos pretos que mudam ao virar a câmera) passam a rodar. Pode deixar manchas escuras na água e, em testes de outro fork, já reiniciou o driver de vídeo. Se a tela travar, desligue com `$env:VICTORY_WAVE_WIDE = '0'` e rode o `Preparar-Shaders.cmd` de novo.
- `Cacar-Shader.ps1`: acha por busca binária qual shader causa um bug visual.
  1. Jogue uma vez normalmente até o lugar do bug. Isso grava a lista de shaders usados.
  2. Rode `.\Cacar-Shader.ps1`. A cada rodada ele desliga metade dos shaders e abre o jogo. Vá até o bug, feche o jogo e responda `s` ou `n`.
  3. Em umas 10-15 rodadas ele mostra o hash culpado e gera `cacar-ultimo-log.zip` para enviar.
  4. Dá para parar e continuar depois com `.\Cacar-Shader.ps1 -Continuar`. Um save perto do bug deixa cada rodada mais rápida.
