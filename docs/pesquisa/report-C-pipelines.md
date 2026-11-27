# Report C — avatar PRs, pipelines/misc (diffs in scratchpad\prs\)
Machine: Ryzen 7 9800X3D (1 CCD), RTX 4070 Ti 12 GB, Win11.

PORT: #103a VICTORY_GROUP_SYNC=auto default (S; vf-ss emit/mod.rs:166, lower.rs:5133; hang/device-removed pattern; recompile cache; GPL-3.0 origin VItoriaBr) · #103b value_uniform for v_readfirstlane (M, with tests; lower.rs:8104) · #149 DXGI_MWA_NO_ALT_ENTER (2 lines, host.rs:8656) · #153 VICTORY_MOUSE (S-M, gameinput.rs same shape) · #39 DRED wording (host.rs:6089) · #139 host wave width resolved once (main.rs:193 vs translate.rs:246).
MAYBE: #53 HLE fidelityfx.rs real FSR 3.1 in Series S (M-L, needs SDK signedbin; merge with our ffxDispatch stretch) · #53 FSR3 FG ×2 shown fps (L, later; conflicts over.rs) · #103c per-binding UAV write tracking (M, cuts copy-back; flag) · #103d HUD VRAM · #103e HIDDEN_WINDOW · #100 · #131 KEYS_LIVE · #164.
USE NOW (no code): VICTORY_DISPLAY_MODE=1920x1080 (dxgi.rs:230; 4070 12GB VRAM 99→92%, evict churn 700→20/min) · NVIDIA panel: shader cache Unlimited, Prefer max performance.
SKIP: AMD #179 #167 #55; Win10 #165; Linux #166 #151 #129 #162; #20; infra-missing #170 #128 #144 #176 #169; #147; already have #175 #171 #158 #28 #141 #103-compose; docs #183 #181 #160; #63/#88 idea: save pipeline cache on device removal.
Leads: avatar VICTORY_PORT_CONSTANTS/DESCRIPTORS (port.rs); DexNom 76749ce.
