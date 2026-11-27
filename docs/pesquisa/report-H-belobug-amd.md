# Report H — Belobug/VIctory-Belobug-AMD (2026-11-26)
Branches a-publier/rx9070xt (cd8dfc0) = avatarmanz c9c932c + 3 Belobug commits (e942896, 5d6bd84, cd8dfc0). Shares root f4504f6 with us (merge-base a26859f) but trees differ a lot → hand ports. ~270 PRs on Belobug main (older line). No env-only switch applies to our build.
Comparison repo: scratchpad\cmp.git (refs belo/*, ava-main, fork-live, dex-main, refs/pr/<n>), patches p_<sha>.patch.

PORT: PR #128 dc79d82e ds_(b)permute in own 32-lane half (S; our lower.rs:4807-4842, 1632) · PR #128 God489 d93d5d7c 9d19eb96 1d8a05e0 bb6f2fc9 (+#68, #221, #236): multi-wave halves meet via polled group counter with loop_limit give-up (no hang) — likely fix for 926c/6f22/5dc3 hangs (L, re-implement) · VICTORY_PORT_CONSTANTS 86dc109 4b82f6c 9c23e8d port.rs (M; uses inplace place_for/cover_in we have; ~17 MB/frame + 6k fills removed; title-build specific).
MAYBE: PORT_DESCRIPTORS 9997d25 4cb90be · PORT_CBV 3920dc2 (needs raw twins) · PORT_GUARD/JOURNAL, 306722b · SHOW_NEW_LATER 4cd2d13 91018a5 · e942896 TEXTURE_MAX/from_base · 5d6bd84 · PR #185 split ClearRenderTargetView rects >=64 (NVIDIA 0xc0000409; our list.rs:1338) · ideas #258 #253/#178 #215 LATE_SIGNALS #179 #199 #195 #222 #162/#145.
SKIP: cd8dfc0 FSR4 (AMD), compiler guard (AMD), #252 #204 #157 #273 #203.
