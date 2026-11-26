@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem Traduz todos os shaders do jogo para o cache ANTES de jogar (alguns minutos, uma vez por versao).
rem Sem isso, na primeira passagem por cada lugar a imagem pode sair errada (agua cinza, borroes) e engasgar.
if not defined VICTORY_GAME_DIR if exist "%~dp0game_scarlett_master.exe" set "VICTORY_GAME_DIR=%~dp0."
if not defined VICTORY_GAME_DIR if exist "%~dp0..\game_scarlett_master.exe" set "VICTORY_GAME_DIR=%~dp0.."
if not defined VICTORY_GAME_DIR (
  echo Defina VICTORY_GAME_DIR com a pasta do seu dump, que contem game_scarlett_master.exe. 1>&2
  exit /b 2
)
echo Traduzindo os shaders de "%VICTORY_GAME_DIR%". Pode levar alguns minutos...
"%~dp0victory.exe" shaders "%VICTORY_GAME_DIR%"
echo Pronto. Agora rode o Play-VIctory.cmd.
pause
exit /b %errorlevel%
