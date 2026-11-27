# Report A — avatar PRs, shaders/wave32 (diffs in scratchpad\prs\)

vf-ss code ~identical to avatar pre-PR code for lane_uniform/widen/wave_wide/all_lanes/group_sync/lds_meetings/without_skips/Tracer → hunks apply by hand easily.

PORT: #81 (M) wave64-on-32: no unreachable barrier, loop exits wave-wide, whole group in wave-wide decision, all_lanes unwrap_or(true) — 3080Ti refused pipelines 9→1 (CS_Visibility, Tiling, TransmissionVolumetrics, DefragHeap, Meshlets); ours mod.rs:553, lower.rs:4110/4154 · #134 shader hunk only VICTORY_LDS_REGION_RACE (S, ~14 lines at lower.rs:1647; 404→11 refused "wants wave 64") · #155 (S) wave64 mask via s_mov_b32 pairs structure.rs:897 · #177 (S) tracer EXEC guard resource.rs:1117/1126/1278 (check GPL-3.0 origin) · #87 (S) LOD array coords lower.rs:10236 · #108 (S-M) VICTORY_SHADER_LOOP_LIMITS default 39f0e9aeb156a61c:512 (12.3→0.4 ms AMD) · #82 (S-M) cascade shadows ir.rs:592/639 · #114 (M) faces d16 table views.
MAYBE: #142→#173 lane_uniform fixed point (BVH/RT) · #109 auto GROUP_SYNC (TDR) · #107 R9G9B9E5 alias cast (L, 8.7→0.1 ms AMD) · #152 (flat fps).
SKIP: #66 (needs avatar partial-group infra). Already have: #4, #18, #10.
Order: #81 → #134 → #155,#177,#87 → #108 → #82,#114 → later #107,#142/#173,#109.
