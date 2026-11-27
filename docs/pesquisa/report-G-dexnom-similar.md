# Report G — DexNom/VIctory + similar projects + Aftermath (2026-11-26)

## A/B results (automated, RTX 4070 Ti, same spot after story load, 2nd half of world frames)
- base seriess: 9.4 fps, prep 41.6, copies 102 MB (exited silently at ~6 min)
- avatar RW=4 + OWN_STRUCTURED=0: 9.6 fps, prep 43, copies 95 MB, drop 119
- avatar RW=4 only (OWN_STRUCTURED on): 5.3 fps → OWN_STRUCTURED now off by default; ROOT_WINDOW_MB default 4 (commit 504b60f/e281360)

## DexNom/VIctory (main is Radeon-only rewrite 570a941; value is in open PRs)
PORT: #40 (6684db0, 23 lines emit/mod.rs ~512: widen as last resort on wave32 → fixes 369cbe906ea72764 CS_Visibility (one of OUR refused) and sr_tracing CS_Tiling_Generate_Opaque) · #64 3a9874c + 9eac44a d01a06a cffdc06 73d8513 7b317c5 f592276 851713d ed45fe9 722655c: device method 0x218 (native compute = texture-array mip gen; native_build.rs) — our device.rs:438 stub · #61 630c7b5 0118c86 · #35 lane_uniform/thread_limited (BVH, 52/52 on RTX 4080) · #72 partial detile · #25 readback union · #24 #53 #33 locks.
MAYBE: #60 TEXTURE_MAX (mips dropped under VRAM pressure) · cd94d35+940d32f view marks (copy-back by marked pages, L) · #64 paired form (L) · #68 (393,215 split; env VICTORY_DYNAMIC_SLOTS=606784) · #75 #43 #63 #66.

## Similar projects (fxceless/victory-fork: 891 forks, 98 ahead)
1. Lazy readback (Xenia/RPCS3/shadPS4 style) — nobody in VIctory family has it; biggest win, L.
2. triippywhale/victory-fork 9e7a6322a0 VICTORY_PRECOMPILED=1 (0x218), ed8c0ce8ea retry textures refused for memory, d861e3d534 indirect windows default.
3. GPU detile: SwavyJayden 4c722a58d7 e22a024a41 be41396035 (gpu_detile.rs).
4. Fewer copies: tuffn3ss/victory-plus 3ead56e175 PAGE_PARTS, 1a411ae49b ASK_EARLY; ZigZagBoi1/ScarlettPort REMAP_LAZY/MEM_SUBPAGE/COPY_NOQUERY (286→84 MB/frame), FAIR_DUE=2 (waiting textures 21k→110); cxchhh/victory-gta6 93e26e93f3.
5. Env: SwavyJayden 5760122623 RELAY=2, PIPELINE_WAIT_MS=5, LATE_WAIT=3; flamingo HEAP_WORKER, CARD_BUFFERS_MIN_KB=64+MB=1536 (9.8→11.1 on 4070).
6. zm0kiemedia/Neptune_VI CLAMP_AFTER_WRITER=1 + INDIRECT_RAW=3 (4.6→8.4 fps); LooperSalty/AnyXboxX 13.8 fps 4070 SUPER.
7. Residency: D3DX12Residency LRU, SetResidencyPriority (we have none); spk-c 86b048b375.
8. fxceless PR #823 (four refused compute on 32-lane), #854 paired.

## Aftermath
SDK DLL: C:\Program Files\NVIDIA Corporation\Nsight Graphics 2026.4.0\SDKs\NsightAftermathSDK\2026.3.26197.2318\lib\x64\GFSDK_Aftermath_Lib.x64.dll. Module exists only in S:\VIctory-main\crates\victory-gpu\src\aftermath.rs (hooks host.rs:111/197/212); port to vf-av = copy file + lib.rs mod + 3 hooks (create before D3D12CreateDevice, initialize after, fail() wait_for_dump), diag build `cargo build --profile diag -p victory --features diagnostics`, env VICTORY_AFTERMATH=<dll>, VICTORY_AFTERMATH_DIR, VICTORY_SHADER_SAVE, DRED off. Analyze .nv-gpudmp in ngfx-ui.exe; S:\VIctory-main\target\aftermath-report.ps1. Profiling: VICTORY_PROFILE=1 (diag), wpr.exe; Nsight Systems/PIX not installed.
