# PortWatch VI snapshot (diff base for the hourly checks)

Source: https://portwatch-vi.xyz (data/tracker.json; source github.com/4lwayz/portwatch-vi). Last check 2026-11-27 ~18:25 UTC (tracker.updated 16:18:23Z).

tracker.updated=2026-11-27T10:19:47Z efforts=44 candidates=30 news_latest=2026-11-26-multiplayer-running (portwatch repo head 48a0e37d5 10:21Z)

| Repo | Last commit | State |
|---|---|---|
| Marvisak/VIctory | 63bcca43c 2026-11-25T23:27Z | AMD 6700XT ~1fps README; owner: gameplay reachable |
| fxceless/victory-fork | f299fba1a 2026-11-27T17:52Z | trustno1 line; NVIDIA water fix (thread ticket + VolumePortalsOnly wave-wide), THIN_GATE 6→15fps 4070, MEMORY_NEAR; raytracing branch 3e573d255 |
| avatarmanz/VIctory-7900XTX | 404 | GONE (account 404) since check 8; our ports live in origin/avatar; cool_fox local copy at S:\cool_fox\cool_fox |
| Belobug/VIctory-Belobug-AMD | 404 | GONE (account 404) since check 8; console flow lives in origin/av-belo and master |
| DexNom/VIctory | 8114ff779 2026-11-26T23:11Z | AMD, best picture, 3-4fps |
| stellarr-studio/kelvaroq | 92606ea7f 2026-11-27T09:40Z | ~10fps public; private ~30fps claim; v0.2.0 zip |
| uiliannn/VItoriaBr | 15779f819 2026-11-27T10:40Z | NVIDIA, ≤4fps, ≈victory-fork |
| Zettrox/ztrx | 404 | gone |
| xcl-dev/xcl | 6089122a1 2026-11-27T16:16Z | GPL-3.0-or-later; pso-precompile 062158eab |
| Vaximous/Victory-Blueyes | d6fe07e53 2026-11-27T07:27Z | 4070Ti 16.6fps p99 135ms (ours: 21-25 Series S, skipping 4 shaders); no new commits |
| Peppacodes/playablegames-peppa | 14d8e9daf 2026-11-27T08:31Z | 5080 23.5fps; open PRs #22-24 |
| Bebrik229/VIctory-NVIDIA-Hybrid | 9c5c8a11c 2026-11-27T17:06Z | 5070 14.5-16fps; fps unlocked by default, PORT_CONSTANTS=0 on NVIDIA, run-nvidia-fast.bat (do not run) |
| TaynanGT/Vice-Tay | 104c3d36a 2026-11-27T18:06Z | 4090 21.1fps, 1% low 17.0; #339 auto 10-19GB profile, #294, #321; open #305 BVH loop 512 |
| trustno1-coder/VIctory-NVIDIA | ca9c75cd6 2026-11-27T18:12Z | 26-30fps claim (5070 DLSS+FG); open #101 LDS programs wave-wide, #104, #108 halves mask high dword, #57, #81, #82, #96 |
| voidopcode/vilocity | 5c1733a47 2026-11-27T17:03Z | bundle; 5080 33fps median opening; 60fps default, DLSS FG |
| all3n1k/VIctory-RTX3090 | abf70c485 2026-11-27T08:09Z | merge fork |
| Dathinel/victory-4gb | 803ebfa97 2026-11-27T01:38Z | 3050 4GB 6.5-7fps |
| Maykzera/victory-rtx3060 | c413a2311 2026-11-27T15:33Z | 3060 13.7-13.9fps; INPLACE_CONSTANTS port, CARD_TOUCHED |
| Dolberthi/neptune-dolberth-nvidia-8gb | 99b231fae 2026-11-26T23:37Z | 8GB merge |
| 0v3rr/Tequesta | c18e5ca73 2026-11-27T14:19Z | A4500 2-14fps |
| PiloteCode/PiloteBox | 75321b262 2026-11-27T13:40Z | v0.13.1 46.6/48.8 ms |
| lameloball2813-ui/cool-fox | 06502b502 2026-11-27T03:23Z | 5060Ti 8fps |
| Ryanabcraft/scarlett-victory-bench | 95e188469 2026-11-25T21:29Z | DexNom fork bench |
| myokex/victory-amd | aa8399e5b 2026-11-25T23:46Z | AMD base (Doomsday) |
| brcly/TuxBox | 8c082e654 2026-11-27T17:21Z | Linux; RT shadow ray queries; first Win11 native D3D12 runs |
| luizwidmer/palmetto | 51dd01de8 2026-11-27T16:13Z | Leonida continuation, black frames |
| R0Y00/Xbox2Windows | 63a30dc1e 2026-11-27T17:03Z | static recomp, menus; PSO recipes persisted; xmem merged page runs |
| omonkeyz/xbox-emulator | a618736df 2026-11-25T13:19Z | no GTA VI run |
| zortos293/XSEmu | 450757752 2026-11-27T14:32Z | XCL-based |
| LakshanSivakumar/Native-Victory-macOS | b998bb652 2026-11-27T16:25Z | macOS port; world flat grey |
| DesignWithTommy/i95-GTA6-PC-Launcher | f23a5e681 2026-11-27T17:17Z | **SUSPICIOUS** meta-launcher: avoid |
| POMXARK/bcpack-gpu-hlsl | de0992b5e 2026-11-27T15:39Z | **SUSPICIOUS** claims, zips, prebuilt .dxil and .bat: avoid |
| readmet3xt-lab/foxhound | 9f8838b10 2026-11-27T13:38Z | CLEAN at 454ffead7 (report-M); C# launcher (don't build) |
Private (no repo): CGBJ 25fps (+TeK multiplayer 25-30), darkworldhm 12-15fps NVIDIA, NotNozy, Doomsday 3-5fps RT, suri ~3fps, omonkey ~5fps.

Flagged:
- From PortWatch: 107 re-uploads; 27 clone/installer-lure networks; victory-fork lookalikes (whein94-alt, Proto-ventures, nounouseki-cmd); fake installers carrying Vidar.
- Ours: the i95 launcher; trustno1's PLAY_FRAMEGEN.cmd (0a542c06f, bypasses the execution policy); vilocity is a bundle.

## Check 2 (2026-11-27 11:25 UTC): queued to port/test
- **fxceless PRs #1456 `VICTORY_TEXTURE_FRAME_BUDGET` + #1457 texture CPU profile + #1458 refresh counters.** They go straight at our texture-pass spikes. Do them after the `minimas` branch.
- **trustno1 80c70b7 / Bebrik #59: helper threads run at the submit thread's priority.** On a 3060: 8.6 → 9.6 fps, card idle 24.7 → 13.2 ms. Cheap; test it.
- **aec85efb / Bebrik #57 `VICTORY_RAW_VIEW_CLAMP`** (raw views stay inside their buffer): correctness; check whether we already have it (fxceless PR 1266).
- fxceless #1455 CBV reuse, #1453 LEGACY_PLAIN, #768 WIDE_TEXTURES: test later.
- Vice-Tay: 1% low of 17 fps on a 4090 (the best lows seen); helper priority 5c803d236, prelude pool.
- vilocity: evicts at 75% of the VRAM budget instead of 88% (an idea for the residency thresholds).
## First survey: what to port (2026-11-27)

1. **PORT**: fxceless/victory-fork 9a9091d18 fixes our BVH crash.
   - Per-list memory sync, COPIES 1023 → 4095, written pages flagged by shaders, RT view address from `Location`.
   - Prerequisites: 4966cd671, 1320dfd74/1170216fd, 17533c5c6.
   - Also test from that fork: bcc542151 `VICTORY_INPLACE_CONSTANTS`, 3461f52fa `VICTORY_GPU_DETILE`, 0e006f005, 62a8d51e8.
2. **TEST/PORT**: Vaximous/Victory-Blueyes, on our GPU (4070 Ti): 16.6 fps, p99 135 ms.
   - `VICTORY_TILED_RESIDENCY`: 8bc188708, cbf12489c, 5ddc8408e.
   - `KEEP_SHOWN`: 15a1c59b5.
   - Copy-queue uploads: c378b81f5.
   - `PIPELINE_WAIT_ONCE`: b6f6136ef.
   - `CLAMP_WAITS`: 92a27aa72.
   - `REFRESH_PIECES`/`WIDE_PIECES`: 32b536f3f, 105305a4c.
   - `WAKE_FEW`/`TOUCHED_LIST`: 2b8934b56.
3. **TEST**: Peppacodes (5080, 23.5 fps), every switch A/B-measured.
   - mimalloc: cd950293a.
   - `SKIP_WC_BACK`: ca2432bd6.
   - `FILL_TITLE=2`: f203ba868.
   - `MERGE_SUBMISSIONS`: 9cbc10100.
   - `PORT_GUARD`: 01a3f7648.
   - `LAND_ASIDE`: cb412956c.
   - Its `VICTORY_AB` switch flips a setting within one run: an in-run A/B.
4. **IDEA**: Bebrik229 `SLOT_REMAP` (3 heap banks), `NATIVE_BARRIERS`, CBV `twin` guard.
5. Maykzera 94be17f63: a 1% low / p99 meter.

Tools that need installing: RenderDoc (victory-fork says it breaks runs), PIX, Graphics Tools (debug layer/GBV), Agility SDK. Not installed: ask the user first.

## Check 3 (2026-11-27 12:25 UTC): queued
- **PORT:**
  - fxceless #1466 0e2d0a9bb: pages written every frame are pulled back, bounded (correctness of copies).
  - trustno1 #39 c0ab82aa7: DirectStorage workers below normal priority. A/B on a 4070 Ti: worst 5 s windows 134 → 105 and 361 → 98 ms. Do it together with helper priority 80c70b7.
  - Vice-Tay 369f940ce: one walk to gather due slots.
  - trustno1 #33 3f6ba0116: prelude upload re-checks `host_written` (speckled faces).
- **TEST:**
  - env `VICTORY_CARD_WINDOWS_MB=1024` (claim: 4070 SUPER 3 → 21-25 fps).
  - Vice-Tay #247 `VICTORY_REAPER=1`, #251 `VICTORY_CARD_DIRTY_QUEUE`, #238/#231.
  - trustno1 #34 (placed constants snapshot) against INPLACE_CONSTANTS.
  - fxceless #868 SKIP_WC_BACK against the Peppa version.
- **IDEA:** trustno1 #18 (`-Fast` preset, 5090 11.8 → 21.9), #38; vilocity, one submission ahead; Xbox2Windows FP32 BVH units fix 1c879506b.
- **Suspicious, new:**
  - trustno1 PR #37 setup-3080.ps1 (ExecutionPolicy Bypass, winget installs, extra DLSS DLL).
  - Vice-Tay PR #244 changes CI and calls for testers.
  - trustno1 #38: history rewritten.
  - foxhound: reviewed, CLEAN (report-M).
- XCL is now GPL-3.0-or-later.
## Check 4 (2026-11-27 13:25 UTC)
- Vice-Tay #274: forced DRED breadcrumbs cost a lot on NVIDIA (2080 Ti: 11.7 → 16.8 fps without them). **Checked: none of our runs is affected.** Ours are release builds: DRED needs the diagnostics feature plus `VICTORY_D3D12_DRED`, and av-env sets neither.
- **TEST:**
  - Vice-Tay #272 3caeac1ff: `CopyDescriptors` batches of 64, fewer allocations and SipHash.
  - trustno1 #41 e5dc2af9e: AVX2 micro-tile detiler with a pool. Large, a bulk PR.
- **IDEA:**
  - avatarmanz #450 592417861 `VICTORY_EARLY_SCREEN_MAX_BYTES`: compiles small screen pipelines at creation; cut gaps of up to 11.9 s on cold runs, which fits our multi-second worst frames.
  - avatarmanz #457 (pooled lists), #460 (14 stability fixes).
  - trustno1 #43: LDS alias analysis for paired wave64.
- Claim: vilocity, 5080, 33 fps median through the opening (README only).
- Suspicious:
  - Vladimir-Human bulk PRs (trustno1 #41-43, Vice-Tay #275): read line by line.
  - The i95 launcher now rebuilds other people's repos as its own versions.
## Check 5 (2026-11-27 14:25 UTC)
- **TEST first:** trustno1 #44 401adb9e7 `VICTORY_SECTION_MB=2`. Physical pages go in sections of at most 2 MiB, so mapping no longer queues behind the Windows section lock. 4060 Laptop: worst mapping second 1950 → 264 ms; lock waits 26.6 → 0.6 s. Fits our worst frames of 1.5-3.6 s.
- **TEST:**
  - fxceless #1450 17a6f01d7: compute pipeline wait capped at 8 s.
  - fxceless #1476 e40825961 `VICTORY_CARD_SIDE=1`.
  - Vice-Tay #278: 4 GB BAR preset, about `CARD_WINDOWS_MB=4096`.
  - fxceless #1480: `bury` outside its lock.
- **PORT:**
  - Vice-Tay bb529f127: `send::take` in one pass.
  - trustno1 854f57ff7: thread ticket for 32x2 groups on NVIDIA (`VICTORY_THREAD_TICKET`); check whether we already have fxceless #1243.
  - avatarmanz #468 63c5a453f and Vice-Tay #283 7f02913db: levels-on-demand tiles counted in the VRAM budget. Port these together with Blueyes TILED_RESIDENCY.
  - foxhound 9f8838b10: static samplers in a fixed order, so the driver finds saved pipelines again. Don't build its new C# launcher.
- **IDEA:**
  - TuxBox 6ea8f39ac: coalesce placed-texture waits.
  - macOS port 95627c666: GPU-written targets are not refilled from title memory.
  - macOS port 3a03e6edc: a compiler crash uses up the frame's pipeline budget.
- Suspicious: POMXARK now ships prebuilt .dxil and START_*.bat files; the i95 launcher keeps mirroring others' heads. PortWatch now counts 108 re-uploads and 28 clone networks.
## Check 6 (2026-11-27 16:25 UTC)
- **fxceless/victory-fork is now trustno1's line** (5dbf5ce22). Its own line has stopped and PRs #1447-1480 are closed. Our `upstream` remote now points at trustno1 code: follow trustno1 directly.
- **PORT, RAM (our runs sit at 90-98% RAM):**
  - avatarmanz #474 3b39ae43a: a list gives its 4 MiB scratch chunks back when its submission lands (bench: 546 → 0 MB).
  - avatarmanz #206 3940a01ed: under PC memory pressure, idle texture copies are freed after 5 s instead of 10 min.
  - Maykzera 333a51114 `VICTORY_CARD_TOUCHED`: `card_dirty` walks only the copies touched since the last walk.
- **TEST, BVH:** fxceless 3e573d255 (raytracing branch). The RT fault-note pages get a recycled 512 MB budget instead of a fixed cap.
- **TEST:**
  - fxceless 52dfd12ea `VICTORY_DYNAMIC_WAIT`;
  - trustno1 #59 `VICTORY_REFRESH_LOCKLESS`;
  - Vice-Tay #307: bounded wait on the mapping fence;
  - vilocity: 12 s cap on the compute wait in the first frame.
- **INPLACE:** diff Maykzera c413a2311 (a clean port of bcc542151) against ours to find why ours never engages.
- Suspicious: trustno1's PLAY_FRAMEGEN.cmd, Get-NVIDIA-DLSS.cmd and get-nvidia-sdks.ps1 now sit in fxceless too (downloaders: don't run them).
## Check 7 (2026-11-27 17:25 UTC): high-value only
- **TEST first:** Vice-Tay #305 e7de67fe9 `VICTORY_SHADER_TRACE_LOOP_LIMIT=512`. Measured on a 4070 Ti: GPU 72.8 → 41.5 ms, median 12.1 → 13.9 fps; `CS_ScreenProbes_TraceRays_RayBinning_BVH_Mixed` 41 → 4.9 ms. Only helps if our runs walk the BVH: check how much GPU time that program takes in our frames.
- **PORT:** Vice-Tay #294 fcded4ebf `VICTORY_SKIP_VIEW_ASK` + the PLACEHOLDERS bitmap: −12 ms per frame (3060 Ti, Proton); texture refreshes 44.7 → 16.3 ms.
- **TEST, lows:**
  - trustno1 #57 99096e67f upload pool: longest wait 1006 → 152 ms.
  - trustno1 #81 a162ae7f9: the 1 GB pipeline library is not saved every 20 s under pressure (hard faults while it saves).
- **TEST, picture:** trustno1 #82 `VICTORY_BVH_MISS` + `VICTORY_NAN_SCRUB` (purple vegetation, black blobs).
- Suspicious: Bebrik run-nvidia-fast.bat and get-agility-sdk.ps1 (do not run).
## Check 8 (2026-11-27 18:25 UTC)
- **avatarmanz and Belobug: accounts and repos are 404.** Our ports survive in origin/avatar, origin/av-belo and master; cool_fox (the avatarmanz base) is local at S:\cool_fox\cool_fox; Vice-Tay contains cool_fox.
- **PORT/TEST first:** fxceless f299fba1a.
  - The water on NVIDIA: thread ticket plus a wave-wide form for `water_shading:CS_TransmissionVolumetrics_VolumePortalsOnly`, which removes the holes in the water.
  - `VICTORY_THIN_GATE`: draws are no longer dropped when dynamic slots run out. On a 4070: 6 → 15 fps at 3-5k draws per frame. Blueyes uses THIN=1, so this matters for it.
- **IDEA:**
  - P1nkman issue #7: 5dc3b259 and 6f225b64 are the two water programs that aren't exact in the paired form, which is why Blueyes skips them. Use them as the A/B target for our console flow.
  - SrGoes issue #30: 02384a60 panics in bitcode.rs:872 when lowered to wave32.
- **TEST:**
  - trustno1 #101: 4 LDS programs added to the wave-wide list.
  - trustno1 #108: halves-mode high dword bug, which matters for paired wave64.
  - trustno1 #104: LDS bounds.
- vilocity tip: other programs holding VRAM shrink the game's budget (64-122 ms GPU frames). Close them before benchmarks.