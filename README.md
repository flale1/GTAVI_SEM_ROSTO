# VIctory Series S para pouca RAM e NVIDIA

Build do [VIctory](https://github.com/Marvisak/VIctory) (camada que roda um título de Xbox Series no Windows) ajustado para PCs com 24 GB de RAM e placas NVIDIA. Desde 27/11 a base é o **VIctory-8GB-v6** (fork do cool_fox, sobre o [avatarmanz/VIctory-7900XTX](https://github.com/avatarmanz/VIctory-7900XTX) `0a435665`), com as nossas correções por cima (lista em `MUDANCAS.txt`).

**Este repositório não contém arquivos do jogo.** Você precisa do seu próprio dump.

## Download

Clique em **Code → Download ZIP** nesta página. O zip traz o `victory.exe`, o lançador e o código-fonte completo (em `source/`). O código em Rust, com histórico, também está em [flale1/VIctory-7900XTX](https://github.com/flale1/VIctory-7900XTX) (branch `v6-ours`).

## Jeito fácil: Jogar-VIctory.exe

Extraia o zip dentro da pasta do seu dump (ao lado do `game_scarlett_master.exe`) e dê dois cliques em **`Jogar-VIctory.exe`**. Ele acha o jogo sozinho (ou pergunta a pasta uma vez) e tem um botão para cada passo: preparar shaders, jogar em Series S ou Series X, aquecer o driver, gerar o diagnóstico e abrir a pasta dos saves. Na primeira vez, clique em **1. Preparar shaders** e depois em **2. Jogar**. O código do lançador está em `launcher/`. Por ser um exe novo e sem assinatura, o Windows pode mostrar "O Windows protegeu o computador": clique em **Mais informações → Executar assim mesmo**.

## Como rodar pelos scripts

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
   - **12 GB de VRAM ou mais**: 4 GB de buffers na placa.
   - O padrão é o **modo liso** (testado num RTX 5070 Ti): Series S, pouca RAM (`VICTORY_LOW_RAM=1`), texturas sem espera, passos na placa desligados (`VICTORY_CARD_STEPS=0`). Para mais detalhe, use o `Play-SeriesX.cmd` (chega a 38 GB de RAM; com limite de memória abaixo de 48 GB, aumente a paginação).
   - Se o limite for menor do que o perfil precisa (Series S: 32 GB, Series X: 48 GB), o `Play-VIctory.cmd` avisa. Para aumentar o arquivo de paginação: Exibir configurações avançadas do sistema → Desempenho → Configurações → Avançado → Memória virtual → Alterar → desmarque "Gerenciar automaticamente" → C: → Tamanho personalizado, inicial `32768` e máximo `49152` → Definir → reinicie.
   - Imagem: saída 1920x1080 (`VICTORY_OUTPUT`) e escala de render 0,75 em placas de 8 GB ou 1,0 com 12 GB ou mais (`VICTORY_RENDER_SCALE`). No Series S, `VICTORY_AMBIENT_MAGENTA=1` tira a luz magenta errada (filtro do Belobug, usado no VIctory-8GB-v6). Se pesar, volte com `$env:VICTORY_RENDER_SCALE = '0.5'`.
6. Se der bug, rode o diagnóstico. Ele grava o log completo e a memória, e gera um zip para enviar:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Diagnostico.ps1
   ```

Requisitos: Windows 10/11 x64, CPU com AVX2, placa Direct3D 12 com Shader Model 6.6 e mesh shaders.

## Versão v6 (27/11)

- Base: VIctory-8GB-v6 (renderiza bem em placas de 8 GB; os shaders de cálculo de 64 lanes sem forma de 32 deixam de ser usados, em vez de travar a placa).
- Por cima: upscaler e escala de render, slots de descritor, rostos em NVIDIA, modo de pouca RAM, as correções de shader (água e lanes em waves de 32, descritores, permlane16, LDS aproximado), os diagnósticos e os shaders do avatarmanz novo. No dump, só 4 shaders de cálculo ficam de fora (eram 6 na v6 pura).
- Sombras em cascata exatas na NVIDIA (port do Belobug `4fd34fd`, nosso `c4870fce`): sem os blocos pretos perto da câmera no Series S.
- Memória: com `VICTORY_LOW_RAM=1` (já no preset) os blocos ociosos de textura caem de 4 GB para 512 MB. `VICTORY_MEM_LOG=1` grava no log, a cada 30 s, onde está a RAM.

## O que muda em relação ao avatarmanz 85d5641

| Mudança | Origem |
| --- | --- |
| Series S em NVIDIA: compõe o plano da interface (sem isso a tela fica preta), upscaler próprio, escala de render | `7997a20`, `a9632bc`, `afd84de` de [trustno1-coder/VIctory-NVIDIA](https://github.com/trustno1-coder/VIctory-NVIDIA) |
| Rostos em NVIDIA: valores de 16 bits lidos por views inteiras (cabeças sumindo) | port de `77e13a9` do VIctory-NVIDIA; a parte de cor de alvo ficou de fora |
| Modo de pouca RAM (`VICTORY_LOW_RAM`, liga sozinho com 24 GB ou menos; `VICTORY_LOW_RAM=0` desliga): caches ociosos por 15 s em vez de 5-10 min, janelas de 1 MiB, pool de snapshots e sobra de rascunho com 128 MiB | nosso |
| O log diz o estágio e o tamanho de cada shader recusado | nosso |
| Do [Belobug/VIctory-Belobug-AMD](https://github.com/Belobug/VIctory-Belobug-AMD): sombras em cascata certas na NVIDIA (wave32), interpolação por atributo, luz dos cômodos estabilizada pelo tempo, janelas limitadas quando a RAM aperta, busca rápida na submissão, uma barreira por buffer | `4fd34fd`, `0dc5d1b`, `b4ba4bb`, `ffc2cf6`, `306722b`, `773d902` e outros |
| Shaders: leitura de primeira lane em lanes auxiliares (upstream `0601955`), buffers e imagens lidos só como dado (port parcial do corgi `53e7682`), pares wave32 e diagnóstico das duas recusas de água (VIctory-NVIDIA `f110b577`, fxceless `9613092b`) | `7886b8c9`, `bb2aaaa2`, `1511ab06`, `7df8e2cf`, `8a1932a6` |
| Do avatarmanz novo: operação de máscara sobre número lido como dado, e endereço de view escolhida por índice calculado. 5 shaders que não traduziam passam a traduzir (213 sem tradução, eram 218) | `9445a5cb` (`d1f883ec`), `5485384e` (`027e367a`) |
| Diagnóstico: o `Preparar-Shaders.cmd` mostra no fim a chave do cache ("host key: waves of 32, view limit ..."), o jogo mostra a dele no início do log ("translation cache key"), sem placa o Preparar não grava cache errado, e `VICTORY_WAVE_WHY=1` lista cada shader traduzido | `4ab31514`, `d36e6158`, `f9dff7e2`, `918577af` |
| Sincronização 64→32 na NVIDIA: `v_permlane16` (upstream VItoriaBr `448416c`) e as leituras de lanes/LDS do avatarmanz (`431cab5d`, `ad0f9dda`, `25025d2f`). No dump, 208 sem tradução (eram 211), os 4 shaders de lane traduzem, e a água (`5dc3b259`, `6f225b64`) e o `2cc4c197` passam a sair em waves de 32, que a NVIDIA aceita. Restam 7 shaders de cálculo em 64 | `dcb0b30e`, `9253660e`, `f3aeee5a`, `3d045a33` |
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
- `VICTORY_PIPELINE_WAIT_MS=24` (era 10000): a abertura não congela e o jogo fica mais liso enquanto a placa cria pipelines novos. Algum objeto pode aparecer um instante depois.
- Do VIctory-8GB-v5 (fork do cool_fox, RTX 3070 Ti 8 GB): `VICTORY_CARD_BUFFERS_MB=2048` com `VICTORY_CARD_ROOM_FOR_TARGETS_MB=2304` (reserva de VRAM para os alvos de render) e, em CPU com 16 threads ou mais, `VICTORY_WIDE_SPIN=200`, `VICTORY_VIEW_THREADS=10` e `VICTORY_UNDER_THREADS=10`.

Depois de atualizar, rode o `Preparar-Shaders.cmd` de novo.

## Series X

O padrão é o perfil Series S (menos RAM e mais liso). Para jogar no perfil Series X em outro PC (mais detalhe, bem mais RAM e VRAM; recomendado só com 32 GB de RAM ou mais e placa com 12 GB de VRAM ou mais):

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
- `VICTORY_WAVE_WIDE=0` (no preset): desliga as formas com barreira de grupo dentro de ramo. Com `=1` a placa travou (TDR) num RTX 4060 Ti e num 5070 Ti. A divisão da água em waves de 32 não depende dela e continua.
- `Cacar-Shader.ps1`: acha por busca binária qual shader causa um bug visual.
  1. Jogue uma vez normalmente até o lugar do bug. Isso grava a lista de shaders usados.
  2. Rode `.\Cacar-Shader.ps1`. A cada rodada ele desliga metade dos shaders e abre o jogo. Vá até o bug, feche o jogo e responda `s` ou `n`.
  3. Em umas 10-15 rodadas ele mostra o hash culpado e gera `cacar-ultimo-log.zip` para enviar.
  4. Dá para parar e continuar depois com `.\Cacar-Shader.ps1 -Continuar`. Um save perto do bug deixa cada rodada mais rápida.
