@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem VIctory Series S + pouca RAM (RTX 4060 Ti 8 GB, 24 GB de RAM). Defina VICTORY_GAME_DIR para a pasta do SEU dump.
if not defined VICTORY_GAME_DIR if exist "%~dp0game_scarlett_master.exe" set "VICTORY_GAME_DIR=%~dp0."
if not defined VICTORY_GAME_DIR if exist "%~dp0..\game_scarlett_master.exe" set "VICTORY_GAME_DIR=%~dp0.."
if not defined VICTORY_GAME_DIR (
  echo Defina VICTORY_GAME_DIR com a pasta do seu dump, que contem game_scarlett_master.exe. 1>&2
  echo Exemplo: set VICTORY_GAME_DIR=D:\Jogos\MeuDump 1>&2
  exit /b 2
)
if not exist "%VICTORY_GAME_DIR%\game_scarlett_master.exe" (
  echo Nao achei "%VICTORY_GAME_DIR%\game_scarlett_master.exe". 1>&2
  exit /b 2
)
set "runner=%~dp0victory.exe"
rem preset base do fork avatarmanz (scripts\play.ps1)
if not defined VICTORY_TEXTURE_NO_WAIT set "VICTORY_TEXTURE_NO_WAIT=1"
if not defined VICTORY_RELAY set "VICTORY_RELAY=2"
if not defined VICTORY_WIDE_BACK set "VICTORY_WIDE_BACK=1"
if not defined VICTORY_CARD_REHASH_RUNS set "VICTORY_CARD_REHASH_RUNS=1"
if not defined VICTORY_JOIN_COPIES set "VICTORY_JOIN_COPIES=1"
if not defined VICTORY_INDIRECT_WINDOW set "VICTORY_INDIRECT_WINDOW=1"
if not defined VICTORY_RELAY_COPY set "VICTORY_RELAY_COPY=1"
if not defined VICTORY_CARD_STEPS set "VICTORY_CARD_STEPS=2"
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
if not defined VICTORY_PIPELINE_WAIT_MS set "VICTORY_PIPELINE_WAIT_MS=10000"
rem VRAM de 8 GB: copias de buffers na placa limitadas
if not defined VICTORY_CARD_BUFFERS_MIN_MB set "VICTORY_CARD_BUFFERS_MIN_MB=1"
if not defined VICTORY_CARD_BUFFERS_MB set "VICTORY_CARD_BUFFERS_MB=1536"
rem modo rapido (do preset cool_fox, sem custo de VRAM)
if not defined VICTORY_THIN set "VICTORY_THIN=1"
if not defined VICTORY_JOIN_PARTS set "VICTORY_JOIN_PARTS=8"
if not defined VICTORY_AMBIENT_AIR set "VICTORY_AMBIENT_AIR=1.5"
if not defined VICTORY_LOG set "VICTORY_LOG=warn"
rem VICTORY_LOW_RAM liga sozinho com 24 GB ou menos; VICTORY_LOW_RAM=0 desliga os cortes de RAM
"%runner%" run "%VICTORY_GAME_DIR%\game_scarlett_master.exe" --console series-s --execute
exit /b %errorlevel%
