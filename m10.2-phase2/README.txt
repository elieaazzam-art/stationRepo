Pandemonium M10.2 — Phase 2 (Visual Legibility) delivery
========================================================

What this is
------------
One patch file containing EVERY commit of the M10.2 Phase 2 pass
(14 commits, one logical change each, never squashed, the branch
gate-green at every step): the visual legibility half of the owner's
playtest finding #2, per docs/PLAN-M10.2.md Phase 2 —

- distinct multi-part silhouettes per kind (client/src/silhouette.rs,
  pure, keyed by the bundle's kind name with the capability-shape
  fallback): worker + visible tool, rifleman + thin rifle, raider
  buggy, guardian hull/treads/turret/barrel, command center + corner
  tower, barracks + flag, supply depot + stacked crates, turret
  pedestal, amber ore crystals — no presentation data touches
  content/ (the content hash is bit-identical);
- the colorblind-safe blue/orange team palette (A-102, the owner's
  pick): P1 shifted off content-red onto orange, client-side only;
  team-color ground rings under every unit, team band parts on every
  structure (CC tower cap, barracks flag, depot/turret trim), minimap
  dots re-tinted to match;
- selection & info (§2.3): a bigger ALWAYS-ON health bar for the
  selected entity (64x7 px vs 36x4), hover name tooltips with an owner
  tag (yours/enemy/neutral; suppressed over the bottom bar; big
  structures read from farther out via footprint-scaled reach), and a
  production-queue summary in the single-selection info panel;
- distinct minimap markers (§2.4): units one tile (own blue / enemy
  orange), buildings a solid 2x2 block, neutral ore a 3x3 amber
  diamond — color AND shape AND size;
- calmer ground contrast (§2.5, crates/engine): muted low-saturation
  steppe so entities pop, darker rock so walls read as obstacles;
- tests (§2.6): 26 new tests (unique mesh per kind, per-kind part /
  vertex counts, above-ground + inside-radius invariants, tone/team
  separability, fallback paths, facing rotation at yaw 0 and 90, team
  rings, minimap markers, the selected bar, hover picks, tooltip
  placement, the queue summary, the shared display-name lookup);
- the register/doc updates: A-101..A-106, DEBT-016, the PLAYTEST
  re-test row + the Phase 2 evidence note, the CHANGELOG entry, and
  the AI-Handoff refresh (snapshot, counts, status board, inventory,
  gotchas).

Base commit
-----------
d84203ed2c49a2e9404ed80f2be25cd47984f271
(master of E-Vex/pandemonium-bd at the time of the pass — the Phase 1
delivery HEAD; the patch applies directly on top of it)

How to apply
------------
    git clone https://github.com/E-Vex/pandemonium-bd.git
    cd pandemonium-bd
    git checkout d84203ed2c49a2e9404ed80f2be25cd47984f271
    git am /path/to/m10.2-phase2-all-commits.patch

That preserves every commit and its message. The patch's author is
`elieaazzam-art <elieaazzam-art@users.noreply.github.com>` (GitHub
attributes those commits to the account on push); `git am` stamps you
as the committer from your local git config — if you would rather be
the author as well, follow with:

    git rebase --root --exec 'git commit --amend --no-edit --reset-author'

Verification already performed on a fresh clone + git am
--------------------------------------------------------
- cargo fmt --all -- --check                          PASS
- cargo clippy --workspace --all-targets -- -D warnings  PASS
- cargo test --workspace (dev, 466 tests)             PASS
- cargo test --workspace --release (461 tests)        PASS
- golden hashes bit-identical to M10.1/Phase 1:
    demo     0xb6fff6659cfb7709  (seed 7, 300 ticks)
    flagship 0x6e9a18bd7c5f699f  (seed 7, 7200 ticks, AI vs AI)
    content  0x9bc18c521107b262  (map id 0xd38136401ab02ff1)
- Xvfb + llvmpipe windowed smokes (the machine half of the Phase 2
  exit test): 700/1500/2000/1600-frame runs all healthy through the
  real wgpu GL path; captures verified on sight — the command center
  reads as THE base, workers and ore name themselves on hover
  ("Worker / yours", "Ore Node / neutral", "Command Center / yours"),
  the selected worker shows the bigger always-on health bar plus the
  selection brackets and the build panel, the minimap carries the
  markers. The pass caught and fixed one live miss (the CC's tower
  mass fell outside the fixed hover radius — now footprint-scaled).
  Per the owner's evidence answer (A-104) no screenshots are included
  in this delivery; the human eyeball pass is the owner's re-test.

What to re-test (the visual pass)
---------------------------------
- identify command center / worker / tank on sight, without a legend
  (the Guardian was not on camera in the Xvfb windows — the start
  force fields none; its silhouette is test-pinned only);
- tell the sides apart at a glance (blue vs orange, bands + rings);
- read the minimap (buildings bigger, ore diamonds) and the health
  state (the bigger selected bar, always visible);
- hover things — the tooltip names them;
- select the Command Center — the info panel shows its queue state;
  anything that does not read is a finding, not a wave-through.

Scope
-----
Phase 2 (Visual legibility) only, per the owner's kickoff answers
(A-101). Phases 3-4 (menus/settings, audio) remain specified in
docs/PLAN-M10.2.md and wait on the owner's re-test verdict. The Phase 4
audio backend is pre-chosen as rodio (A-100); its architecture-law
allow-list amendment + ADR land with that phase.
