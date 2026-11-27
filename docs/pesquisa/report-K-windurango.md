# Report K: WinDurango/WinDurango (2026-11-26, HEAD ab7717f)

**Verdict:**
- WinDurango is an Xbox One (Durango/ERA, D3D11.x) compatibility layer written in C++. It replaces DLLs (kernelx, d3d11_x, Windows.Xbox.*) and forwards to D3D11.
- It does not translate shaders: ERA titles ship DXBC.
- Its D3D12.x part is only stubs. It covers nothing of GDK/Scarlett, wave64, residency, DirectStorage or 0x218/0x1c8.
- Our xmem/xg/write-watch code is already ahead of theirs.
- License: LGPL-3.0 since PR #222. However, the memory code came from XWine1 SlimEra/GenERA (PR #206), and its origin is unclear. Take ideas only.
- Nothing here helps VRAM residency or wave64.

## Ideas
1. **IDEA, M:** use Microsoft's XG library as a detile oracle (`WinDurango.D3D11X/include/WinDurango.D3D11X/XG.h` ~385-570).
   - If the game package ships `xg_xs.dll`, a local test can detile title textures with it.
   - The result is diffed byte by byte against `victory_formats::texture`.
   - The `XGCreateTextureComputer` slots are already documented in `victory-hle/src/modules/xg.rs` (0x10/0x40/0x48/0x50).
   - Test only; never ship it.
2. **IDEA, S:** edge cases to check against the `xmem.rs` tests. Source: `kernelx.cpp` ~180-580, 7362f14.
   - `AllocateTitlePhysicalPages`:
     - 64K and 4MB together is an error, and so is neither.
     - 4MB needs `count & 63 == 0` and runs of 64 contiguous pages.
     - It may return a partial count, with ERROR_OUTOFMEMORY only when the count is 0.
   - `MapTitlePhysicalPages` with a null array unmaps and keeps the placeholder.
   - `VirtualQuery`/`VirtualProtect` over split placeholders merge the pieces into one region.
   - `VirtualFree(MEM_DECOMMIT)` uses `MEM_PRESERVE_PLACEHOLDER`.
3. **IDEA, S:** VA ranges by allocation type, as a hint only, since Scarlett may differ. Compare with `address_range()`.
   - MEM_GRAPHICS: 4 GiB to 1 TiB.
   - MEM_TITLE: 0x400_0000_0000 to 0x7FF_FFFF_FFFF.
   - Everything else: 0x200_0000_0000 to 0x3FF_FFFF_FFFF.
4. **IDEA, S:** CPU waits on memory with a limit (open PR #253, `MemorySync.h`).
   - 8 compare functions, plus a mask.
   - Pumps the background contexts while it waits.
   - Gives up after 1 s and logs, instead of hanging.
5. **IDEA, S:** fences that are addresses. `IsFencePending(f) = f > 0xFFFF && !*(BOOL*)f`.
6. **SKIP:** dirty tracking by write fault (vectored handler plus PAGE_READONLY). It is unfinished, and our GetWriteWatch path is better.
7. **SKIP:**
   - DXGIX/ESRAM stubs: Scarlett has no ESRAM.
   - XMemAlloc: we already cover it, and theirs has a bug (4KB → MEM_LARGE_PAGES).
   - Bundles, WinRT stubs, Kinect, XMA.
