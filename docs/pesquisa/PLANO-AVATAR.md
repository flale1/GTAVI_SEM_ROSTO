# Plano consolidado — o que trazer do avatarmanz/VIctory-7900XTX (PRs + forks) para S:\vf-ss (seriess)
Data: 2026-11-26. Relatórios: report-A..F-*.md nesta pasta. Licença: vf-ss e avatar são GPL-3.0 → ports permitidos (manter atribuição).

## Fase 0 — só variáveis de ambiente / config (sem código)
- VICTORY_DISPLAY_MODE=1920x1080 (VRAM 99→92 %, churn de texturas 700→20/min numa 4070 12 GB)
- VICTORY_WAVE_LOCAL=idiom (recusa a forma aproximada "local waves" — DEVICE_HUNG)
- VICTORY_DYNAMIC_SLOTS=600000
- VICTORY_CARD_BUFFERS_MIN_KB/MB conforme mgrein deeb4d19 (64 KiB / 1280 MB) — confirmar nomes no vf-ss
- Painel NVIDIA p/ o exe: Shader Cache Unlimited, Prefer max performance; renomear victory.exe (perfil "The Culling")

## Fase 1 — correções pequenas (S), estabilidade/texturas
- Sampler heap 2048 + null 2047 (avatar #121 / dd67ae7)
- #23 structured→raw sem alinhamento · #150 readback ranges com deferred().backs
- Coldtrain 92b46ccb0 views limitadas ao tamanho real do buffer
- UwUCammie e2d5d9bcd BC7 rotation
- triippywhale 717cbc78 helper-lane readfirstlane (hang ~200 s) · b2413dd7 ForceEarlyDepthStencil
- YukiRyuu 05f0ad2a (page fault janela 4 MiB) + b2248e54/f2420f00 (VirtualQuery 1/s, +fps)
- jasonc 5ad04ad8 jitter no stretch Series S
- #149 Alt+Enter · #39/787c7b4 texto DRED · #139 host wave · #125 wait cap pipeline · #87 LOD array
- Rubenpannen b696f737e (default WAVE_LOCAL)

## Fase 2 — texturas / descritores (M)
- #96 probe de heap de views maior (hoje capado em 1M, jogo usa ~1,5M → slots lendo null) e depois pool 8 shards
- #97 placed texture UAV no recurso do título (log: "placed unordered texture view not mirrored")
- #24 + HEAP_SPREAD (pico de 124 ms a cada 16 passes)
- LloydNicholson 564d439b, 65d13a43 · triippywhale f8e6c3f3, 239a7798

## Fase 3 — tradutor wave32 / reflexos / RT (M-L)
- #81 widen wave64-em-32 (recusados 9→1) · #134 LDS_REGION_RACE (404→11) · #155 · #177 · #103a GROUP_SYNC auto (= mgrein 16fc3d72)
- xBandaku cube get_lod PS + 6 outros · 4fd34fd/#82 sombras cascata (cherry-pick fxceless #1002) · d1f883e lane mask
- mgrein f48bacb1 wave_same (52/52 BVH builder) + HamudL 801194e9 · kindomrno32 WAVE_PAIR (227/229 exatos) · SAZLEIB BVH_MISS
- re-precompilar cache após esta fase

## Fase 4 — fps CPU / extras
- mgrein nv/integration memória/latência (160→79 ms na 4070) · #98 streaming stores · SYNC_IN_PLACE+SPANS_QUICK · #108 loop limits
- #153 mouse · alex-IchiQ nvprofile · VICTORY_OUTPUT / RENDER_SCALE · #53 FSR 3.1 / DLSS (ASsDevpile af966f8f) depois
