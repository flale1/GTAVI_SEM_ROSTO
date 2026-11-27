# Report N: codec-d/cool_fox (local copy S:\cool_fox\cool_fox, f4b48ad), 2026-11-27

**Security: CLEAN, with one caution.** Build it from source only. Never run the exe in `target/`: it is unsigned and matches no known hash (SHA256 E197A8F3…33F4). `Play-VIctory.cmd:12` prefers a `victory-3d-rtx-pareto-residency.exe` that isn't in the repo, so that file must never be present. README.md:5 points to a ZIP in "private releases".

- **Scripts and build:** Cargo.lock uses only crates.io. build.rs only hashes source, and the scripts only set VICTORY_*.
- **Runtime:** network is loopback-only and `WriteProcessMemory` targets only the process itself.

**What it is:**
- avatarmanz/VIctory-7900XTX at 0a43566, plus 6 codec_d commits from 2026-11-25.
- Its merge-base with our master is a26859fc.
- **Vice-Tay = cool_fox + ~600 commits**, so the fork bench covers it through Vice-Tay; it needs no test of its own.

**Claims and license:**
- No 25 fps or CGBJ claim in it. Its README says a 7900 XTX runs 13-22 fps using 40-46 GB of RAM, and recommends 64 GB. Its bug journal reports an RTX 5090 with 32 GB at a 54 ms median.
- `console_insn.rs:5` says "Ported from XCL (GPL-2.0-only)". That came from fxceless 578d459 and our tree has the same file, so it needs a license review on our side too.

**What it has:**
- "pareto-residency": admission by host RAM commit, which throttles texture prefetch and staging under 1.5 GiB of free commit (`residency.rs:58-79`).
- `VICTORY_DSTORAGE_STAGING_MB`.
- Wave-wide forced for two hardcoded digests.

**What it lacks:** console flow, `WAVE_PAIRED` and `MESH_LAUNCH`.
