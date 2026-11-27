# O que aprendemos (até 2026-11-27)

> **Objetivo do projeto: 30 fps estáveis (~33 ms por frame) com todas as
> texturas carregando.** Hoje: ~12 fps de média (~83 ms), p5 ~2 fps.

Este documento junta tudo o que foi investigado, medido, confirmado e
descartado neste fork, para quem continuar o trabalho não repetir caminhos.
As pesquisas detalhadas de cada repositório estão em [pesquisa/](pesquisa/).

Máquina de teste: Windows 11, Ryzen 7 9800X3D (8c/16t, um CCD), 32 GB RAM,
RTX 4070 Ti 12 GB, jogo no perfil Series X.

---

## 1. Linha do tempo do desempenho

| Etapa | fps no mundo |
|---|---|
| Árvore antiga (S:\VIctory-main, upstream Marvisak) | 0,1 → 0,4–4 (travava a GPU na transição para o mundo) |
| Fork fxceless (base) | ~1 |
| Linha ztrx | 2,6 |
| Ports do belobug | 3,5 |
| `novabase` (fxceless main dd3a14b + ports) | 7,0 |
| + fase1 (LTO, hashes, AVX2, reaper…) | 9,9 |
| `texturas` (copy-back da água, espaço de texturas) | 9,3 |
| `seriess` (fase45 + Series S) | 9,4 |
| `avatar` padrão | 9,9 |
| **`avatar` + card buffers** | **12,6 / 12,9** (nova rodada 2026-11-26: 11,0) |
| **`master` = avatar + av-belo** (água certa) | ~10 |

Coisas que PIORARAM e foram descartadas: victory-fork #255 e #71 (crash),
pacote de streaming de texturas do DexNom (5f4c3df / 921d8d3), ztrx #144/#137
(suspeitos), `VICTORY_JOIN_COPIES=1`, `VICTORY_WAIT_RESIDENT=0` (device
removido em 6 min; ligado custa tempo na thread de submit),
`VICTORY_VIEW_OWN_STRUCTURED=1` (9,6 → 5,3 fps), `VICTORY_ROOT_WINDOW_MB=32`
(dobrou as cópias por frame), `VICTORY_RELAY=2` + `VICTORY_PIPELINE_WAIT_MS=5`
(dentro do ruído, mais draws descartados).

## 2. Como medir (e como NÃO medir)

- **Teste automático**: `scripts/av-test.ps1`. `VICTORY_KEYS` aperta Enter
  (= botão A do controle) aos 35/60/75/90/110 s e chega ao mundo; o jogador
  fica parado no mesmo lugar; o script fecha o jogo e tira a média da segunda
  metade dos frames do mundo (filtro: draws/frame > 1000).
- `VICTORY_KEYS` só funcionava no build de diagnóstico; agora funciona também
  no release (commit "HLE: VICTORY_KEYS works in release builds too").
- **Fechar a janela do jogo encerra o teste** ("window closed: suspending the
  title" → "title did not finish suspending in time; ending the title").
- **Compilar (cargo) durante a medição tira fps** — medir com a máquina parada.
- **A primeira execução com um cache novo é mais lenta**: a lista de pipelines
  pré-iniciados (`started_early`) está vazia; compare sempre a partir da
  segunda execução.
- Métrica: linhas "X fps, Y ms/frame (P preparing: copies … textures …; G on
  the GPU; B copying back …), N draws/frame, dropped D". "on the GPU" = CPU
  esperando a fila da GPU.
- Nunca use `| Select-Object -First` em saída de cargo/victory (mata o processo).

## 3. Pré-compilação e cache

- `victory translate <jogo> --cache --pipelines` com **o mesmo ambiente** da
  execução: a chave do cache inclui todo `VICTORY_*` que o crate de shader lê
  (build.rs junta os literais em `VICTORY_SHADER_SWITCHES`).
- Switches só de GPU (card buffers, root window, etc.) NÃO entram na chave:
  dá para fazer A/B sem pré-compilar.
- Copiar a pasta `pipelines` de um cache anterior para o novo reduz a
  pré-compilação de ~6 min para ~1 min (só os pipelines novos são feitos).
- A pré-compilação junto com testes de shader pode esgotar a RAM (32 GB):
  rodar uma coisa de cada vez. O disco C: precisa de espaço livre (pagefile).

## 4. NVIDIA x console: wave64 em GPU de 32 lanes

- O console roda waves de 64 lanes; a NVIDIA só 32 (nenhum driver expõe 64).
  `WaveSize(64)` é recusado com E_INVALIDARG ("Parâmetro incorreto").
- Formas de tradução existentes (em ordem): original, sem early-outs, sem
  skips, sem skips com escalares seguidos, local waves (aproximada) e, como
  último recurso, **wave-wide** (DexNom #40, aproximada em alguns programas).
- Com o #40 os pipelines recusados caíram de 27 para 6, mas três programas
  (`926c46bab3b86bd6`, `6f225b641c5b0708`, `5dc3b25986622949`, grupos 8x8,
  centenas de barreiras, barreiras dentro de loops) causaram DEVICE_HUNG e
  artefatos → ficam fora por padrão (`VICTORY_WAVE_WIDE_SKIP`).
- **O shader da água é `5dc3b25986622949`.** Sem ele a água fica escura; na
  forma wave-wide a água fica verde mas os reflexos ganham artefatos.
  Testado um a um: só o 926c ou só o 6f22 → água escura; só o 5dc3 → verde.
- Por que o 5dc3 não tem forma exata: dentro de código divergente ele tem
  (a) leitura e escrita de LDS na mesma região, (b) `v_readfirstlane`,
  (c) reduções de wave. Todas exigem as duas metades se encontrando.
- **Console flow do Belobug (God489, PR #128)**, portado em `av-belo`:
  todo thread executa todo bloco com EXEC emulado, as metades se encontram nas
  barreiras e entre acessos de LDS. Os três programas acima e mais 18 traduzem
  de forma exata. Só cobre grupos de uma wave do console (64 threads);
  grupos de várias waves (contador compartilhado com desistência após
  `loop_limit`, Belobug 9d19eb96) ainda faltam.
- `ds_bpermute_b32`/`ds_permute_b32` em wave64 operam dentro de cada metade
  de 32 lanes (RDNA ISA 10.4.4) — corrigido (Belobug dc79d82e).
- Pesquisa anterior (2026-11-24): ninguém tinha o mundo do GTA VI rodando na
  NVIDIA; XCL usa duas metades + troca por LDS com espera limitada; shadPS4
  só cobre blocos uniformes; o D3D12 não garante progresso da outra metade
  (espera infinita = risco de travar).

## 5. Travamentos e quedas do device (o que sabemos)

- Histórico (árvore antiga): o heap de views do jogo tem 1.245.184 slots; a
  NVIDIA recusa heaps acima de 1.000.000 (o probe de 1.835.008 também falha).
  Tabelas além do limite são refeitas em slots dinâmicos. O jogo nunca usa
  índices de textura acima de ~382 mil; acima de 393 mil é um anel de tabelas
  por draw → **as texturas faltando NÃO vêm do limite do heap**.
- Tipo de descritor errado num slot (SRV nulo lido como CBV/buffer) trava a
  NVIDIA (a AMD lê 0). Por isso existem a tabela de tipos de slot e os nulos
  com a dimensão certa.
- Leituras de LDS fora do array em lanes inativas (forma "sem skips", índice
  vindo de `select` com lixo) dão page fault → `VICTORY_LDS_READ_BOUND`
  (fora do array lê 0, como o console).
- Raw views precisam começar em múltiplos de 16 bytes; views root sem limite
  podem ler além da janela de 4 MiB → limites pelo `GetDesc().Width`.
- Helper lanes em pixel shaders: `v_readfirstlane` precisa ler o próprio
  valor, senão loops waterfall giram até o limite (DEVICE_HUNG ~200 s).
- `VICTORY_SKIP_PIPELINES=mesh` não resolveu de forma consistente: os mesh
  shaders não eram a causa raiz dos travamentos antigos.
- TdrDelay maior não evita: era exceção de GPU (nvlddmkm evento 153), não
  timeout.

## 6. Ferramentas

- **Nsight Aftermath** (SDK em `C:\Program Files\NVIDIA Corporation\Nsight
  Graphics 2026.4.0\SDKs\NsightAftermathSDK\...\GFSDK_Aftermath_Lib.x64.dll`):
  `VICTORY_AFTERMATH=<dll>`, `VICTORY_AFTERMATH_DIR=<pasta>`, funciona no
  release (`av-dex`). DRED fica desligado junto.
  - **O relatório de erros de shader (`VICTORY_AFTERMATH_SHADER_ERRORS=1`)
    faz a GPU parar em erros que sem ele são inofensivos**: os dois primeiros
    dumps apontaram shaders que rodam bem normalmente (o downsample de mips
    `5b2ce592c3a5dd09` — que tinha a leitura de LDS fora do array — e o mesh
    `adb3ace598f95ee2`). Por isso fica desligado por padrão.
  - O hash do Aftermath não é o hash do console; para achar o programa,
    aquece os hashes do log num cache separado e compara o DXIL.
- DRED: `VICTORY_D3D12_DRED=1` (o número é o primeiro comando NÃO concluído).
- Debug layer + GBV: `VICTORY_D3D12_DEBUG=1 VICTORY_D3D12_GBV=1` (lento).
- `VICTORY_WAVE_WHY=1`: por que cada forma de tradução foi recusada.
- `victory translate --warm`, `--validate --list`, `victory replay` (rodar um
  dispatch capturado sozinho), `VICTORY_PROFILE=1` (diag).

## 7. Memória e VRAM em execução

- Card buffers (`VICTORY_CARD_BUFFERS_MIN_KB=64`, `_MB=1536`): +27 % de fps e
  menos texturas esperando VRAM (2.500 → 1.750) numa placa de 12 GB.
- Janela de root view: 4 MiB (32 MiB duplicava memória e dobrava as cópias).
- `VirtualQuery` uma vez por segundo e buscas de janela com lock de leitura.
- O preparo (CPU) ainda gasta ~38–45 ms/frame: ~93–100 MB copiados de memória
  do jogo por frame e refresh/detile de texturas; o copy-back ~14–18 ms.
- Texturas que ainda não carregam: residência (milhares de slots esperando
  memória, slots sem mapeamento anulados) e o método de device 0x218
  (pipelines compute pré-compilados do jogo, geração de mips de arrays).
- Ideias com maior retorno ainda abertas: copy-back preguiçoso (só quando o
  jogo lê, como Xenia/RPCS3/shadPS4), `VICTORY_PORT_CONSTANTS` do avatarmanz
  (heap de constantes de 174 MB aberto direto), fila de upload justa
  (ScarlettPort `FAIR_DUE`), detile na GPU (SwavyJayden), residência com LRU
  e `SetResidencyPriority` (D3DX12Residency).

### Campanha A/B de 2026-11-26/27 (15 rodadas de 7 min, cena parada)
Ruído entre repetições: ±0,2–0,8 fps; texturas esperando memória variam de 2 a 8x.
- `master`: 10,65 fps. `portes-mv` (ports do Marvisak): 10,2. Sem os 4 ports
  de textura: 10,9. Tudo dentro do ruído.
  - `VICTORY_SKIP_UNWRITTEN` pula ~22 MB por frame, mas o tempo de cópia não muda.
- **`VICTORY_TEXTURE_SWEEP=0`: 11,55 fps**, textura 7,9 → 4,4 ms, texturas
  esperando memória ~450 → ~10. É a única alavanca real encontrada.
  - Porém a placa enche (10,4 de 11 GB) e ~8.900 slots ficam retidos por falta
    de espaço. Por isso a varredura foi refeita para soltar só sob pressão,
    as mais frias primeiro (branch `sweep-pressao`).
- `ROOM_PERCENT` 90 e 97, `BUDGET_MB=12500` e `STAGE_MB=384`: sem ganho.

### Campanha 2 (2026-11-27, 11 rodadas)
- `master`: 10,9 fps; `master` com `SWEEP=0`: 11,8 (confirmado).
- `sweep-pressao` (`VICTORY_TEXTURE_SWEEP_PRESSURE=1`, margens 2/6, 3/10, 1/3):
  10,8–10,9 fps.
  - Usa +1,5 GB de VRAM e ainda solta ~22 GB por rodada.
  - "Changed after its upload": ~50 mil por frame (14 mil com `SWEEP=0`).
  - Não foi juntado.
- `watch-reserva` (kelvaroq 0045): 10,5 fps.
  - A consulta ao write-watch cai só 0,1 ms por frame.
  - Não foi juntado.
- Conclusão: o custo está no reenvio de texturas que a varredura solta e o jogo
  volta a usar. Falta conferir na imagem o que `SWEEP=0` deixa de fora (~8.500
  slots retidos).

### Campanha 3 (2026-11-27)
- **`mesh-launch` (kelvaroq 0041)**: draws de mesh indiretos lançados por um
  estágio de amplificação, sem o passe de clamp e sem as duas esperas por draw.
  - **10,7 → 11,5 fps; espera da GPU 37,1 → 28,9 ms** (3 rodadas cada).
  - Sem geometria faltando. Juntado na `master`, ligado por padrão.
- **`VICTORY_TEXTURE_SWEEP=0` é visivelmente pior**: rostos, mãos e objetos
  ficam pretos ou sem textura (~8.700 slots retidos por falta de VRAM). Não usar.
- Capturas: `target\sdd\runs\shots\c3-*`.

### Campanha 4 (2026-11-27): wave64 pareada
- **`wave-paired`** (desenho do kindomrno32 df6820623 + ideia do kelvaroq 0052,
  sem código do XCL): cada lane da NVIDIA roda as lanes l e l+32 do console,
  para grupos de várias waves que nenhuma forma exata aceita.
  - 7 programas resgatados: `02384a60fda6f2d0`, `6b82bc7d22016cb5`,
    `6832a9da15c2e584`, `22338086ea4c5364` e 3 do XboxBvhBuilder.dll.
  - Pipelines recusados: 6 → 2.
  - **10,6 → 12,0 / 12,3 fps; espera da GPU 30 → 21–25 ms.** Juntado na `master`.
- Com ela os 53 programas do BVH builder têm pipeline e `VICTORY_BVH_BUILDER=1`
  liga o builder. Mas o jogo quebra em ~15 s: a tabela de memória por endereço
  esgota (1023 cópias, `memory.rs` "no number left for another copy") e as
  páginas sem cópia leem zero. **Próximo passo para os reflexos: aumentar
  ou reciclar essa tabela.**
- **O disco C: cheio derruba o jogo** ("memory allocation ... failed"):
  o pagefile fica no C:. O cache de shaders do driver
  (`%LOCALAPPDATA%\NVIDIA\DXCache`) chegou a 35 GB depois das pré-compilações.
  Limpar de vez em quando.

### Mínimas de fps (análise de 2026-11-27)
- Fps por segundo na `master`: mediana ~11, p5 ~1,9, mínimo 0,5. ~20% dos
  segundos ficam abaixo da metade da mediana, em blocos de 3–16 s: logo ao
  entrar no mundo e de novo aos ~95–155 s. Isso derruba a média em 1,5–2 fps.
- A linha de fps sai a cada 5 s e só cobre o último ~1 s. A série por segundo
  sai da linha do relógio da placa: ms ≈ ocioso×100/(100−ocupado%).
- Causa: a passada de texturas bate no teto (3 × `VICTORY_TEXTURE_STAGE_MS` =
  750 ms no modo de recuperação, `draw.rs`). Ela fica cheia porque a varredura
  solta texturas que o jogo volta a usar (239 MB/s nos segundos lentos), e cada
  uma é recriada com `MakeResident` mais uma espera de fence por textura.
  - A VRAM oscila em cima do limiar de 75% de `vram_idle_ms`.
- Com `SWEEP=0` o p5 sobe para 6,8 fps, mas aparecem texturas pretas.
  Correção em andamento na branch `minimas`: tempo ocioso maior com histerese,
  `MakeResident` em lote, residência do staging e métricas de 1% low.

### Campanha 5 (2026-11-27, 13 rodadas)
- `minimas`: as esperas para a memória da placa ser mapeada caem ~5x
  (121k → 24k, ~6 s a menos por rodada), por causa do `MakeResident` em lote e
  do staging sem residência.
  - Mas fps, p5 e slow2x ficam dentro do ruído (média 9,5–10, p5 1,3–2,8,
    slow2x 15–23%); 1% low ~7,5–8 fps; pior frame 1,5–3,6 s.
  - Nenhum slot retido e nenhuma textura preta. Juntado na `master` pela
    estabilidade e pela linha de métricas "frame pacing:".
  - Conclusão: os picos não vêm da residência. Ainda falta achar a causa
    (próximos suspeitos: a passada de texturas no teto, as threads de
    DirectStorage e auxiliares, a compilação de pipeline na primeira vez).
- `bvh-table` (fxceless 9a9091d) com `VICTORY_BVH_BUILDER=1`: o jogo quebra em
  4–5 s, antes do mundo.
  - As cópias numeradas dobram a cada frame (64 → 1036, 369 MB → 4,3 GB) e
    2,25 GB por frame são atualizados; a memória do sistema chega a 90%.
  - Não foi juntado.

### Campanha 6 (2026-11-27, 11 rodadas)
- **`VICTORY_SKIP_WC_BACK=1`** (Peppa, A/B na mesma rodada): **−10,2 ms por
  frame (−14%)**, melhor em 5 de 5 pares, ~130 GB de copy-back pulados por
  rodada. Falta conferir a imagem antes de virar padrão.
- `LAND_ASIDE`, `MERGE_SUBMISSIONS` e mimalloc: sem ganho.
- `inplace-constants`: não ligou nenhuma vez (0 regiões); o buffer de 174 MB
  não passa na checagem. Falta investigar.
- `bvh-table` com orçamento: ainda quebra ~4 s depois do builder. As cópias
  são numeradas todas antes do fim do primeiro frame (3,3–4,4 GB) e nada pode
  ser solto ainda.
- ~~A RAM do sistema chega a 90–98%~~ **Correção (campanha 7):** os CSVs de
  memória das campanhas anteriores foram lidos errado por causa da vírgula
  decimal do Windows em português. Medido de novo: RAM ~62%, **commit ~91%**
  (42 GB). O commit alto continua sendo suspeito.
- **Campanha 7 (13h23): todos os builds passaram a quebrar no boot**, no
  frame 82, ~16 s, com int3 / assert do jogo em victory-image+0x4dcbc9d.
  - Quebra até o build que funcionou às 11h37, então a causa está no PC.
  - Descartados: arquivos do jogo, cache, save (perfil vazio também quebra),
    telemetria, memória.
  - Única mudança no sistema: o Windows Update instalou XboxIdentityProvider e
    Xbox.TCUI às 13h05. O PC estava ligado havia 66 h. Próximo teste: reiniciar.

## 8. O que avaliamos e descartamos

- 1R0nim/iR0-fork: projeto do zero, ainda não roda jogos, sem licença.
- Belobug `a-publier`: é o avatarmanz republicado + 3 commits; FSR 4 e guarda
  do compilador são só AMD.
- avatarmanz #96 (pool de 8 shards): bugs (slots podem ser entregues duas vezes).
- mgrein (governador de RAM, limite BC, 2 frames adiantados): dependem de
  código que não temos.
- XCL é GPL-2.0-only: só ideias, nenhum código copiado.

## 9. Próximos passos sugeridos

1. ~~Validar o `av-belo`~~ — feito em 2026-11-26: água corrigida no jogo, sem
   queda do device; `av-belo` juntado na `master`. Restam alguns artefatos nos
   reflexos (testar `VICTORY_BVH_BUILDER=1 VICTORY_BVH_QUARANTINE=1`).
2. ~~Método de device 0x218~~ — **não fazer**: o upstream (PR #3163) mostrou
   que o jogo tem fallback próprio para 0x218/0x1c8 e responder 0x218 subiu os
   draws descartados de 82 para 1.440 por frame. Em vez disso: tabela de
   constantes depois das instruções (upstream e04c0781, VRAM no driver NVIDIA)
   e pular cópias não escritas desde a última (upstream 19533398).
   Ver [pesquisa/report-I-marvisak.md](pesquisa/report-I-marvisak.md).
3. `VICTORY_PORT_CONSTANTS` para cortar cópias na thread de preparo.
4. Console flow para grupos de várias waves.
5. Copy-back preguiçoso.
