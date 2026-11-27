# Report J — araeltoromtc4-arch/kelvaroq (stellarr-studio/kelvaroq), 2026-11-26

**Verdict:** not ahead of us overall. On an RTX 5080 at 4K it gets ~7.6 fps; on an RTX 4090 at 1440p, ~10-11 fps. On an RTX 5070 (issue #11) and an RTX 4060 (issue #19) it is slower than plain victory-fork. Three pieces are worth testing.

The README claims "unified memory" and "DXR implemented". Neither is in the public code: no `BuildRaytracingAccelerationStructure`, and the UMA patches are off by default.

## What it is
- 61 ordered patches (native/patches 0000-0064) applied by scripts/build_native.py on fxceless/victory-fork f85101b. That commit is already in our history.
- The araeltoromtc4 fork adds only aadae04 (FreeConsole) and 83177d4 (CI). Skip both.
- License GPL-3.0-or-later. It cites 37 XCL commits; XCL is GPL-2.0-only, so take ideas only from those hunks.
- Patches 0049-0064 arrived in one commit (f3c070c). All are off by default and unmeasured.

## Ranked
1. **PORT, to compare, L:** 0052 `VICTORY_WAVE64_PAIRED` (f3c070c, emit/bitcode/paired.rs).
   - One host lane carries guest lanes i and i+32, so a whole console wave fits in one host wave.
   - Handles groups of 64-1024 threads that are whole waves.
   - Issue #19 (RTX 4060): refused pipelines went 6 → 1, and the black/red blocks in the reflection disappeared.
   - Rescued 02384a60fda6f2d0 (one of the two programs keeping our BVH builder off), 5dc3b25986622949, 2cc4c197ee29e291 and 369cbe906ea72764. 2da4beb386509b77 is still refused.
   - Costs: ~20% fewer fps, and 1 crash (0xC0000005) in 2 runs.
   - It depends on other translator patches: applied alone it rescued 1 of 7.
   - Nothing known about 6b82bc7d22016cb5.
   - Compare with kindomrno32 df6820623 `VICTORY_WAVE_PAIR` (report F).
2. **PORT, then A/B, M:** 0041 `VICTORY_MESH_LAUNCH` (32c4ab4).
   - An amplification stage reads and clamps the indirect mesh records.
   - This removes the clamp pass and two GPU drains per draw.
   - Their numbers: p50 198 → 120 ms; GPU busy 78 → 35%.
   - A/B against our `VICTORY_INDIRECT_WINDOW` / `VICTORY_INDIRECT_GATHER`.
3. **PORT, M:** 0045 `VICTORY_WATCH_RESERVATION` / `VICTORY_COPY_SMALL` (e3b01f9).
   - One GetWriteWatch per reservation per submission.
   - Small reads grouped by page.
   - Their numbers: p50 129 → 110 ms.
4. **MAYBE, S-M:** 0046/0048 async present, at most `VICTORY_FRAMES_AHEAD=2`.
5. **MAYBE, M:** 0038-0040 (6a40d00).
   - `VICTORY_DIRECT_CONSTANTS`, `VICTORY_FILL_WAIT` (64 KiB blocks) and `VICTORY_REBAR_COPIES_MB` (GPU_UPLOAD heap).
   - Overlaps `VICTORY_PORT_CONSTANTS`.
6. **MAYBE, M:** 0056 `VICTORY_BVH_RESIDENT_BOXES`: a missing page reads as a zero box. Relevant to the reflections.
7. **MAYBE, M:** texture patches, all unmeasured.
   - 0054: eviction / level budget.
   - 0017: `VICTORY_TEXTURE_HEAPS`.
   - 0002: `VICTORY_BATCHED_RESIDENCY`.
8. **MAYBE, S-M:** 0024 `VICTORY_GPU_CONSTANT_FILLS` (af4820d) and 0033 `VICTORY_WAVE_ZERO_MASK` (94cdceb).
9. **SKIP for now, L:** 0062 `VICTORY_LAZY_REMAP` and 0063 `VICTORY_UMA*`.
10. **SKIP, L:** 0049/0050/0053/0055/0058/0060/0061. These are mostly XCL ideas, unmeasured.

Already in our tree: COPY_PLAIN, the wide card hash, ASYNC_SUBMIT/QUEUE2, TEXTURE_NO_WAIT, async present.
