# PortWatch: log das verificações horárias

Base de comparação: portwatch.md (Check 8, 2026-11-27 18:25 UTC).

## 2026-11-27 ~19:25 UTC (Check 9)
tracker.updated=2026-11-27T19:13:01Z; notícia mais recente: 2026-11-27-belobug-dmca (GitHub removeu o Belobug por violar os ToS; AvatarManz offline). VIctory-NVIDIA (trustno1) lidera a corrida.

- **TESTAR primeiro (fps/mínimas):** Vice-Tay #344, merge 10675b58f: `VICTORY_PLACED_FILL_REDIRECT=1` + `VICTORY_PLACED_ORDER=1`. Planeja os fills de GPU que ficam atrás de cópias posicionadas. Medido numa RTX 4090: 14.83 → 16.52 fps; mediana do frame time 66.5 → 58.2 ms. Depende de #322/#285.
- **PORTAR, textura/correção NVIDIA:** fxceless cd9355206 `VICTORY_WATER_TILE_SLOTS`. Cada lane ganha seu próprio slot nas listas de tiles da luz da água. Remove os blocos escuros 16x16 no mar em placas de 32 lanes (testado numa 4070). Complementa o f299fba1a.
- **TESTAR, texturas:** vilocity 05c70d7d2: um slot de textura do mesmo tamanho só substitui outro se for a mesma imagem (mediana 20 → 21 fps). vilocity b0d0e2851: texturas mapeadas em outros endereços são revisadas enquanto estão visíveis.
- **IDEIA:** Vice-Tay aa917f3f7 (#343) reaproveita rodadas de heap sync entre submissões na fila (sem medição). Vice-Tay a33271f25 (#342) guarda os stamps de write-watch das páginas de GPU posicionadas.
- **IDEIA:** Maykzera e67ab0708: os fills podem ler a memória do título no lugar (com INPLACE_CONSTANTS); alega 20-23 fps e 30-40 ms. Maykzera 4bc84c819 play-best.ps1: 17.2 fps, 1% low 9.5 numa 3060. Serve de comparação para o nosso INPLACE.
- vilocity e7eafec71: o overlay avisa quando a VRAM enche (quedas para 4-7 fps a 1440p; a parte da placa no frame vai de 6 para 64-122 ms).
- **Novo:** kylepelham/El1xr, criado hoje às 14:39Z, sem histórico. Alega ~25 fps em 4K numa 5090; base AnyXboxX/VIctory. Só observar.
- **Suspeito, só anotado:** trustno1 0cef07e9d e 10862a6d8. O "MFG Unlocker" e o FSR da AMD são baixados e carregados na inicialização (binários de terceiros). Não usar.
- Sem mudanças: Bebrik, Blueyes, Peppa, xcl, DexNom e Marvisak/VIctory (ainda em 63bcca43c, sem push desde 2026-11-25).
- PortWatch agora conta 110 re-uploads, 31 redes de clones/iscas e 33 repos "switch-emulator" (malware).
