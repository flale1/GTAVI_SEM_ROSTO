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
call "%~dp0preset.cmd"
rem VICTORY_LOW_RAM liga sozinho com 24 GB ou menos; VICTORY_LOW_RAM=0 desliga os cortes de RAM
if not defined VICTORY_CONSOLE set "VICTORY_CONSOLE=series-s"
rem Series S: luz magenta que o programa do titulo deixa conta como nenhuma (filtro do Belobug e942896, usado no VIctory-8GB-v6)
if /i "%VICTORY_CONSOLE%"=="series-s" if not defined VICTORY_AMBIENT_MAGENTA set "VICTORY_AMBIENT_MAGENTA=1"
echo Console: %VICTORY_CONSOLE%  (RAM %VICTORY_RAM_GB% GB, VRAM %VICTORY_VRAM_GB% GB, limite de memoria %VICTORY_COMMIT_GB% GB, buffers na placa %VICTORY_CARD_BUFFERS_MB% MB)
set "need=32"
if /i "%VICTORY_CONSOLE%"=="series-x" set "need=48"
if %VICTORY_COMMIT_GB% GTR 0 if %VICTORY_COMMIT_GB% LSS %need% (
  echo.
  echo AVISO: o limite de memoria do Windows ^(RAM + arquivo de paginacao^) e %VICTORY_COMMIT_GB% GB e o perfil %VICTORY_CONSOLE% precisa de %need% GB.
  echo O jogo pode fechar sem aviso por falta de memoria. Aumente o arquivo de paginacao: veja o LEIA-ME.txt.
  echo.
)
"%runner%" run "%VICTORY_GAME_DIR%\game_scarlett_master.exe" --console %VICTORY_CONSOLE% --execute
exit /b %errorlevel%
