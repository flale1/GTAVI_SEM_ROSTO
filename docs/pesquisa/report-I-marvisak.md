# Report I — Marvisak/VIctory (upstream original), 2026-11-26

Shares root f4504f6; merge-base ffe310eb (2026-11-24). Since then upstream main has 479 commits, ours 113. A trial cherry-pick of 47 candidates found only 552208c8 applies cleanly; upstream redid the GPU memory layer differently (Marvis 11-24 22:36 batch), so ports have to be done by hand. Upstream runs ~1 fps on an RX 6700 XT; it has no fix for water reflections, because the RT structures are never built there either.

**Change of plan:** don't implement 0x218/0x1c8. Open PR #3163 shows the title has its own fallback, and answering 0x218 raised dropped draws from 82 to 1,440 a frame.

Already in our tree: 4e60ea3a #1635, a7381ed6 (LAZY_TEXTURES), 9cc37c5f, 321a4bc1 #2007, #2462, #2449, #2031, 0665a0e8 #573, eabb6b85 #1949, 06019553, 842b0cb7 #158, #2960 (= our async submit). bac1364a #2286 doesn't apply to our code.

## Ranked
1. **PORT, S:** e04c0781 #2143 — the constant table starts after the instructions (lower.rs `code_dword`, `code_table_start`). One 57 KiB table made the NVIDIA driver reserve GBs of VRAM per thread. Changes the cache key.
2. **PORT, M:** 19533398 — skip host copies the title hasn't written since they were taken (watch.rs, shadow.rs, host.rs). Upstream did 140–240k checks a frame, about 18% of the submit thread.
3. **PORT, M-L:** the texture refresh/detile set, ported together.
   - 23a4b62b: one upload per submission, only if the bytes changed.
   - cc5f9612: re-detile only the subresources whose pages changed.
   - d75491e9: a texture owning its pages skips the hash.
   - Open #2985: detile only the touched rows (2.73 → 0.086 ms).
   - fdf34ab7 + 8a3d9759: shared staging pool, 64 MiB cap.
4. **MAYBE, L:** the residency set.
   - 11e9a544: 64 MiB heaps made ahead (255 → 35 ms for 300 textures).
   - 69d1e8e7: idle textures given up after 120 s / 300 frames, plus LRU 90 → 85% of budget.
   - 52d14b10: read marks.
   - 4959d349: refresh only textures read in this frame or the last.
5. **Check:** open #2925 (RTX 4070 SUPER): program 34d88edf583f3778 was refused, so the ray-march pass c7feccae4e01e454 took 305 of ~520 ms. Run `VICTORY_WAVE_WHY` on it. Also #2920 (barrier balance at per-lane branches, TDR fix) and #3115 (DPP in halves).
6. **MAYBE, S-M:** 2a4938e6 — zero unmapped pages without a failing kernel read.
7. **MAYBE, M:** 6cc6aa35 — single-view copies share 16 MiB buffers.
8. **MAYBE:** 9a12a45e #2162 — depth twins share scratch buffers (~300 MB of VRAM).
9. **MAYBE, RT:** 0a5be3c7, 9337b35e, 38994e53, ec9e750e (builder frame writes withheld when its list misses memory); #3316 (BVH operand decode, S). #3294 is AMD-only.
10. **SKIP for now, L:** view marks cd94d353 + 940d32f6 + 53193663 (86 conflict hunks; needs #2958 on NVIDIA).
11. **Optional:** 552208c8 #1839 — unimplemented methods log their four arguments; applies cleanly.
12. **Small MAYBE:** 555c112e #2179, f821cb9d #1000, e9ea9a45 #983, 2bba7921 #1906, #3300.
    - SKIP #3301: it is wrong.

## A/B now (existing switches)
- `VICTORY_SHADER_LOOP_LIMIT` (needs its own cache)
- `VICTORY_TEXTURE_ROOM_PERCENT` / `VICTORY_TEXTURE_BUDGET_MB`
- `VICTORY_TEXTURE_SWEEP=0`
- `VICTORY_BVH_BUILDER=1 VICTORY_BVH_QUARANTINE=1`
- `VICTORY_LAZY_TEXTURES=0` (control only)
