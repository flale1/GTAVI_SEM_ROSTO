@echo off
rem Mesmo jogo no perfil Xbox Series X: mais detalhe, bem mais RAM e VRAM (testado: ~27 GB de RAM).
rem Recomendado so com 32 GB de RAM ou mais e placa com 12 GB de VRAM ou mais.
set "VICTORY_CONSOLE=series-x"
call "%~dp0Play-VIctory.cmd" %*
exit /b %errorlevel%
