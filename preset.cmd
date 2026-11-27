@echo off
rem Preset comum do Play-VIctory.cmd e do Preparar-Shaders.cmd. As variaveis que entram na chave do cache
rem de shaders (BVH_MISS, NAN_SCRUB) TEM que ser iguais nos dois, senao o cache preparado nao e usado.
rem Toda variavel ja definida antes (set ou $env:) vence o valor daqui.
rem Placa e RAM: com 12 GB de VRAM ou mais, 4 GB de buffers na placa. O perfil padrao e o Series S, que no 5070 Ti
rem ficou bem mais liso que o Series X; o Series X fica no Play-SeriesX.cmd.
if not defined VICTORY_RAM_GB for /f "tokens=1,2,3" %%a in ('powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0hw.ps1"') do (
  set "VICTORY_RAM_GB=%%a"
  set "VICTORY_VRAM_GB=%%b"
  set "VICTORY_COMMIT_GB=%%c"
)
if not defined VICTORY_RAM_GB set "VICTORY_RAM_GB=0"
if not defined VICTORY_VRAM_GB set "VICTORY_VRAM_GB=0"
if not defined VICTORY_COMMIT_GB set "VICTORY_COMMIT_GB=0"
if %VICTORY_VRAM_GB% GEQ 12 if not defined VICTORY_CARD_BUFFERS_MB set "VICTORY_CARD_BUFFERS_MB=4096"
rem preset base do fork avatarmanz (scripts\play.ps1)
if not defined VICTORY_TEXTURE_NO_WAIT set "VICTORY_TEXTURE_NO_WAIT=1"
rem modo liso (config testada no RTX 5070 Ti): passos na placa desligados, pouca RAM sempre. O relay fica no estagio 2:
rem o estagio 1 (VICTORY_RELAY=1) derrubou a placa ("device removed after 7 submissions sent ahead") num RTX 4060 Ti.
if not defined VICTORY_RELAY set "VICTORY_RELAY=2"
if not defined VICTORY_LOW_RAM set "VICTORY_LOW_RAM=1"
if not defined VICTORY_WIDE_BACK set "VICTORY_WIDE_BACK=1"
if not defined VICTORY_CARD_REHASH_RUNS set "VICTORY_CARD_REHASH_RUNS=1"
if not defined VICTORY_JOIN_COPIES set "VICTORY_JOIN_COPIES=1"
if not defined VICTORY_INDIRECT_WINDOW set "VICTORY_INDIRECT_WINDOW=1"
if not defined VICTORY_RELAY_COPY set "VICTORY_RELAY_COPY=1"
if not defined VICTORY_CARD_STEPS set "VICTORY_CARD_STEPS=0"
if not defined VICTORY_INDIRECT_BATCH set "VICTORY_INDIRECT_BATCH=2"
if not defined VICTORY_MAP_THREADS set "VICTORY_MAP_THREADS=1"
if not defined VICTORY_TITLE_PRIORITIES set "VICTORY_TITLE_PRIORITIES=0"
if not defined VICTORY_CARD_AWAKE set "VICTORY_CARD_AWAKE=1"
if not defined VICTORY_SHOW_AFTER set "VICTORY_SHOW_AFTER=1"
if not defined VICTORY_AMBIENT set "VICTORY_AMBIENT=0.8"
if not defined VICTORY_D3D12_DRED set "VICTORY_D3D12_DRED=light"
if not defined VICTORY_SKIP_PIPELINES set "VICTORY_SKIP_PIPELINES=none"
rem Series S em NVIDIA: compor o plano da interface, upscaler proprio, slots de descritor
if not defined VICTORY_COMPOSE set "VICTORY_COMPOSE=1"
if not defined VICTORY_OWN_UPSCALER set "VICTORY_OWN_UPSCALER=1"
if not defined VICTORY_RENDER_SCALE set "VICTORY_RENDER_SCALE=0.5"
if not defined VICTORY_DYNAMIC_SLOTS set "VICTORY_DYNAMIC_SLOTS=524288"
if not defined VICTORY_BVH_MISS set "VICTORY_BVH_MISS=1"
if not defined VICTORY_PIPELINE_WAIT_MS set "VICTORY_PIPELINE_WAIT_MS=500"
rem VRAM de 8 GB: copias de buffers na placa limitadas
if not defined VICTORY_CARD_BUFFERS_MIN_MB set "VICTORY_CARD_BUFFERS_MIN_MB=1"
if not defined VICTORY_CARD_BUFFERS_MB set "VICTORY_CARD_BUFFERS_MB=1536"
rem modo rapido (do preset cool_fox, sem custo de VRAM)
if not defined VICTORY_THIN set "VICTORY_THIN=1"
if not defined VICTORY_JOIN_PARTS set "VICTORY_JOIN_PARTS=8"
if not defined VICTORY_AMBIENT_AIR set "VICTORY_AMBIENT_AIR=0.5"
if not defined VICTORY_LOG set "VICTORY_LOG=warn"
rem rostos em NVIDIA: valores NaN dos shaders de pele viram 0 (entra na chave do cache)
if not defined VICTORY_NAN_SCRUB set "VICTORY_NAN_SCRUB=1"
rem nevoa e luz: teto do espalhamento no ar e luz que nao da saltos (Belobug)
if not defined VICTORY_AMBIENT_SETTLE set "VICTORY_AMBIENT_SETTLE=250,3"
rem registra os pipelines que o jogo cria, para o Aquecer-Driver.cmd prepara-los no cache do driver
if not defined VICTORY_PIPELINE_BOOK set "VICTORY_PIPELINE_BOOK=1"
rem LDS aproximado em grupos de 32 (port do victory-corgi): faz 5 shaders de calculo recusados na NVIDIA funcionarem (entra na chave do cache)
if not defined VICTORY_WAVE_LOOSE_LDS set "VICTORY_WAVE_LOOSE_LDS=1"
rem console wave de 64 rodando como duas waves de 32 da NVIDIA, com barreiras de grupo (entra na chave do cache):
rem shaders de calculo que ficavam em 64 e eram recusados (agua em blocos pretos) passam a rodar. Pode deixar manchas
rem escuras na agua e ja derrubou o driver em testes do fxceless. Se a tela travar: $env:VICTORY_WAVE_WIDE = '0' e Preparar-Shaders.
if not defined VICTORY_WAVE_WIDE set "VICTORY_WAVE_WIDE=1"
