@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem Prepara no cache do DRIVER da placa os pipelines que o jogo ja usou (registrados pelo Play-VIctory.cmd),
rem para nao engasgar quando eles aparecem. Rode DEPOIS de jogar pelo menos uma vez com esta versao,
rem e de novo quando atualizar o driver da placa ou o pacote. Pode parar e continuar depois.
rem   Aquecer-Driver.cmd        so os pipelines que o jogo desenhou (rapido)
rem   Aquecer-Driver.cmd tudo   todos os pipelines que o jogo criou (dezenas de milhares, demora muito)
call "%~dp0preset.cmd"
set "quais=--used"
if /i "%~1"=="tudo" set "quais="
echo Preparando os pipelines no cache do driver...
"%~dp0victory.exe" warm %quais%
echo Pronto.
pause
exit /b %errorlevel%
