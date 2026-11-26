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
echo Console: %VICTORY_CONSOLE%
"%runner%" run "%VICTORY_GAME_DIR%\game_scarlett_master.exe" --console %VICTORY_CONSOLE% --execute
exit /b %errorlevel%
