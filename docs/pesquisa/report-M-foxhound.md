# Report M: readmet3xt-lab/foxhound (2026-11-27, head 454ffead7)

**Security: CLEAN.** The review was read only; nothing was built or run.
- **What it is:** a squashed copy of the VIctory family under GPL-3.0-or-later. Its LICENSE is identical to Marvisak's. It has 268 files: 193 blobs already exist in our object store, and 75 are its own.
- **Credits:** license headers are kept, and the README (262-283) credits VIctory, fxceless, avatarmanz, cool_fox, DexNom and Belobug. It says it contains no XCL code. **We can use its code**, keeping the per-file "ported from" credits.
- **Binary:** only `victory-formats/src/bcpack-tables.bin`, identical to upstream's.
- **Scripts:** only set `VICTORY_*` and run the locally built exe. No downloads, `iex`, registry changes or Defender changes.
- **build.rs and Cargo.lock:** build.rs only hashes local source. Cargo.lock pulls only from crates.io, with no `[patch]` section.
- **Runtime:**
  - The net stubs refuse every connection except loopback.
  - `WriteProcessMemory` and `NtWriteVirtualMemory` target only the process itself.
  - `RegGetValueW` reads the TDR values and writes nothing.
  - `WinVerifyTrust` checks NVIDIA's signature on the Streamline DLL offline.
- **CI:** read-only clippy and tests.
- **Minor:** `Play-VIctory.cmd:13` prefers a prebuilt `victory-3d-rtx-pareto-residency.exe` if one exists beside it. The repo doesn't ship one.

## Ideas for NVIDIA performance and stutter
The figures are the author's, on an RTX 4070 SUPER with a 7800X3D, not verified by us.
- **Pipeline book:** `VICTORY_PIPELINE_BOOK` (`pipeline/known.rs:43`) and `apps/victory/src/warm.rs`. It records the pipelines each run uses and compiles them in an idle-priority child before the next start, against first-use driver compile stutter.
- **Soft views:** `VICTORY_SOFT_VIEWS=copies` (`victory-hle/src/modules/xmem.rs:2254`, 2784) keeps tiled-heap page mappings without Windows views, against freezes at scene cuts.
- **No copy-back to write-combined buffers:** `VICTORY_WC_NO_BACK` (`shadow.rs:2164`) skips copying shader writes back into large write-combined buffers: -5 ms a frame.
- **Helper priority:** `VICTORY_HELPER_PRIORITY` (`cores.rs:82`) raises frame-critical helpers above normal: worst second 74.8 → 63.8 ms.
- **DirectStorage priority:** `VICTORY_DSTORAGE_PRIORITY` / `WORKERS` (`dstorage.rs:642-646`), the source of trustno1 #39.
- **wave32 fixes:** `VICTORY_LOOPS_WAVE` (`emit/mod.rs:909`) and `VICTORY_LDS_FIRST_INIT` (`emit/lower.rs:5443`) fix dropped and dark water tiles on NVIDIA.
- **Others:**
  - DLSS and Frame Generation through Streamline (`streamline.rs`, `docs/dlss.md`);
  - native 1440p (DexNom);
  - a `VICTORY_LEAVE_OUT` launcher list that skips the decal defragmentation (5.6 ms of GPU a frame).
