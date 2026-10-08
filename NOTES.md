# Patch notes

Detailed delivery notes for the patches that have one, ordered oldest →
newest. The index of all patches lives in
[README.md](README.md). **New notes are appended at the bottom of this
file — never inserted in the middle.**

## M9 note

`patches/006-m9-alpha-content-feel-pass.patch` was regenerated from scratch. The
first attempt in this repo (commit c669ce9) tuned AI constants and added
an audio stub but never re-pinned the AI-vs-AI golden it moved, added no
M9 exit tests, and left the actual stall (chase orders outliving their
dead targets) unfixed — applying it to the M8 HEAD would leave the test
suite red. The replacement applies cleanly on the M8 HEAD (2861479),
reproduces its tree exactly (verified: identical tree hashes), and is
green-gated end to end: fmt, clippy -D warnings, 333 dev / 328 release
tests, demo golden untouched, the moved flagship re-pinned twice with
written reasons in the tests themselves.

## M9.1 note

The first human playtest of the windowed client (DEBT-008) found the
input layer mirrored and half-missing: D panned left and A right (the
camera's screen-right axis has been negated since M3), W retreated,
the mouse could not move the camera at all, there was no way to order an
attack, rejected orders were silent, the opening zoom rendered the
starting force as specks, and the M9 feedback cues never expired.
`patches/007-m9.1-input-hotfix.patch` fixes all of it — plan §11.3's input slice
(edge scroll + middle-drag + zoom-toward-cursor + right-click context
orders attack/gather/move + the armed-'A' attack-move flow),
direction-pinning camera tests, refusal cues, selection brackets, the
start-anchored opening camera, and the always-advancing feedback
clock. Green-gated end to end: fmt, clippy -D warnings, 352 dev / 347
release tests, and **zero golden movement** (demo 0x9d5ba9b565060336,
flagship 0x01b3b60b741f03e9, content 0x249b69f0ee343a10 re-verified
bit-identical — the fix touches only the client and the engine's
camera, both above the sim boundary). The windowed loop re-verified
under Xvfb + llvmpipe with XTEST injection: 900 frames presented,
drag-box selection of the 5 start entities, 2 commands submitted.

## pre-M10 note

`patches/008-pre-m10-cleanup.patch` is the review-and-improve pass over M0–M9.1 the
project owner requested before starting M10 (Stabilization &
declaration). It applies cleanly on the M9.1 HEAD (1a49c27), reproduces
its tree exactly (verified: identical tree hashes), and is green-gated
end to end: fmt, clippy `-D warnings`, **356 dev / 351 release tests**
(was 352 / 347; +4 new `fx` property tests), and **zero golden movement**
(demo `0x9d5ba9b565060336`, flagship `0x01b3b60b741f03e9`, content
`0x249b69f0ee343a10` re-verified bit-identical). No frozen decision
changed; no dependency bumped; no `STATE_ENCODING_VERSION` bump.

Seven commits, one logical change each:

1. **`ci`** — `Swatinem/rust-cache@v2` added to every CI job, keyed on
   `Cargo.lock`. A separate `.github/workflows/audit.yml` runs
   `cargo audit` on every `Cargo.lock` change and nightly. Read-only over
   the lockfile.
2. **`docs(architecture)`** — refreshed `docs/ARCHITECTURE.md`'s status
   header from M8 to M9.1; added `tests/alpha_loop.rs` to its test list.
3. **`community`** — added `CHANGELOG.md`, `SECURITY.md`,
   `.editorconfig`, `.github/PULL_REQUEST_TEMPLATE.md`, and
   `.github/ISSUE_TEMPLATE/bug_report.md`.
4. **`refactor(content)`** — `map_passability` and `map_buildability`
   now share one helper (`map_flag`); output bytes unchanged.
5. **`fix(engine)`** — the A15 "checkpoint trail" assertion was a no-op
   (`assert_eq!(x.len(), x.len())` plus an empty loop); replaced with a
   real `assert_eq!(oa.hashes, ob.hashes)`.
6. **`test(fx)`** — four new property tests: `Fnv1a64` integer-write
   LE encoding (u8/u16/u32/u64/i32/i64 ↔ `to_le_bytes`),
   `Fx::abs` non-negativity + idempotence, `Fx::square` == `mul(self)`,
   `Vec2Fx::dist(a, b)` == `(a - b).len()`.
7. **`docs(ai)`** — per-constant `///` doc comments on the scripted-
   opponent tuning block in `crates/ai/src/scripted.rs`.

The audit deliberately excluded the sim tick pipeline, the capability
stores, the state hash encoding, and any code path that touches a
pinned golden — those are M10's scope, not a pre-M10 cleanup's. Every
commit was individually green-gated before the next started; the final
release-mode sweep is green too.

## pre-M10 review-and-scaffolding note

`patches/009-pre-m10-review-and-scaffolding.patch` is the deeper review-and-improve
pass the project owner requested before starting M10 — the hot-path
tightening, the Generals: Zero Hour-style feel additions, and the M10
scaffolding (soak, bench) that the plan §12 deliverables list calls for.
It applies cleanly on the M9.1 HEAD (5183fc8) and is green-gated end to
end: fmt, clippy `-D warnings`, **367 dev tests** (was 352; +15 new
across sim, fx, engine, tools), and **zero golden movement** — the demo,
flagship, content, determinism, combat, economy, movement, alpha_loop,
vision, ai, and match_rules goldens all re-verified bit-identical in
both dev and release profiles.

Eight commits, one logical change each — every commit was individually
green-gated before the next started:

### Performance (no semantic change — golden hashes preserved)

1. **`perf(sim): batch entity removal in death & cleanup (stage 8)`** —
   stage 8 removed one entity at a time, each call doing up to 13
   binary searches + 13 `Vec::remove` shifts across the capability
   stores. New `World::remove_batch(ids: &[EntityId])` does a single
   merge-join sweep per store (both `ids` and the stores are ascending
   by id), reducing the cost from `O(m · (log n + n))` to `O(n + m)`
   per store. The post-state is byte-identical to the per-id path —
   pinned by a new test that builds two identical worlds, removes the
   same non-contiguous id set via each path, and asserts every store
   compares equal. At alpha scale (n=200, m=10 dead): ~10x speedup;
   at the 10× scale test (n=2000, m=100 dead): ~100x.
2. **`perf(sim): lockstep entity_view with health store in
   snapshot/player_view`** — `Sim::snapshot` and `Sim::player_view`
   both projected each entity through `entity_view(id)`, which
   binary-searched the health store per entity for `hp_fraction_milli`.
   New `entity_views_lockstep` walks the entity stream and the health
   store in tandem (both ascending), turning the per-entity lookup
   into an O(n + h) lockstep walk. Output byte-identical; the per-id
   `entity_view` helper is removed (no remaining callers).
3. **`perf(engine): skip state_hash in HUD when debug overlay hidden`**
   — `MatchHost::hud_state` used to call `Sim::state_hash()` every
   frame, even though the value is only read inside the F3 debug
   overlay. The cheap path leaves `state_hash` at zero; the new
   `hud_state_with_hash` variant is called by the client only when
   the overlay is visible. The `HudState` struct shape is unchanged.
4. **`perf(fx): make Fx::from_milli a const fn`** — every op in the
   conversion is const-evaluable in stable Rust 1.98 once the clamp is
   hand-written (i64::clamp is not yet const-stable). Callers can now
   build `const` lookup tables for content stats. Behavior unchanged,
   pinned by an existing property test plus a new const-context test.

### Generals: Zero Hour-style feel

5. **`feat(client): camera rotation (Q/E) and pitch (Ctrl+wheel)`** —
   the camera already had `rotate()` and `set_pitch()` methods but no
   input bindings. Q/E orbit the camera around its target (continuous,
   scaled by the frame delta — frame-rate-independent, like the WASD
   pan); Ctrl+wheel tilts the pitch up/down (clamped to the supported
   range). Cancels an armed attack-move so the player can re-orient
   mid-order. Adds supporting getters on `RtsCamera` (`pitch`, `yaw`,
   `distance`) and an `adjust_pitch(delta)` helper. README controls
   updated. No sim-side changes — the camera is presentation-only
   (ADR-0001), so golden hashes are unaffected.

### M10 scaffolding (the plan's own deliverables)

6. **`feat(tools): add soak subcommand for M10 prep (A7 acceptance
   gate)`** — plan §12 calls for `tools soak --matches N` to run many
   seeded AI-vs-AI matches with crash/stall detection and win-rate
   telemetry. This is the sequential single-process version: nightly
   CI that wants parallelism spawns N `headless --seed N --p1 ai --p2
   ai` subprocesses. Reports resolved/mutual-destruction/unresolved/
   crashed counts, per-player wins, avg/max end tick, resolution rate
   (A7 wants 100%), and ticks/second throughput. Exits non-zero only
   when a match crashed (the A7 crash signal).
7. **`feat(tools): add bench subcommand for M10 perf baselines (plan
   §15)`** — plan §12 calls for `tools bench` to measure tick cost
   against plan §15's perf budgets (≤ 1 ms avg, ≤ 4 ms p99, ≥ 1000 t/s
   on Alpha-size). Samples each tick's wall-clock duration with
   `Instant::now` (presentation-only telemetry — `tools` is exempt
   from the determinism source bans) and reports avg / p50 / p95 /
   p99 / max + throughput against the plan's thresholds. Sample
   dev-profile run on this commit: 0.40 ms avg, 0.47 ms p99, 2512 t/s
   — all three budgets met. Criterion integration is the natural
   follow-up; this harness gives M10 the same numbers without pulling
   criterion's transitive deps into the workspace's build.

### Documentation

8. **`docs: update AI-Handoff.md with M10 prep summary`** — adds a new
   section 6.5 'M10 prep — pre-milestone improvements (review pass)'
   between the milestone status board and the milestone inventory,
   summarizing the 8 commits above and listing what M10 still owes
   (A1–A15 acceptance sweep with pinned evidence in
   `docs/ALPHA_DECLARATION.md`, the 1000-match nightly soak run, the
   release-profile perf baselines, and DEBT-008's human re-verification).

### What this pass deliberately did NOT touch

- The sim's tick pipeline order (plan §6.3) — unchanged.
- The state hash encoding (`STATE_ENCODING_VERSION`) — unchanged.
- Any frozen decision (FD-1..FD-10) — unchanged.
- Any dependency (no `Cargo.toml` bumps).
- The demo, flagship, content, or AI goldens — all re-verified
  bit-identical in both dev and release.

The previous `patches/008-pre-m10-cleanup.patch` (7 commits) was the surface pass
(CI cache, community files, doc comments, one no-op assertion fix, four
fx property tests). This patch is the deeper pass — the hot-path
optimizations, the Generals-feel additions, and the M10 scaffolding the
plan §12 deliverables list calls for. They stack cleanly: the cleanup
patch lands first (on M9.1 HEAD 1a49c27), then this patch lands on top
of it (it was authored against 5183fc8, the M9.1 HEAD as of this pass).

## M10.1 decal render fix note

`patches/011-m10.1-decal-render-fix.patch` fixes the deterministic first-frame
crash in the decal rendering pipeline: the decal pipeline declares two
vertex buffer slots (slot 0 geometry, slot 1 per-instance
`DecalInstance` data), but the draw block uploaded the instance data
with `queue.write_buffer` and never bound it to the pass — wgpu's
validation rejected the very first draw with "requires vertex buffer 1
to be set", and the panic's teardown then surfaced the secondary
"Trying to destroy a SurfaceAcquireSemaphores" error. The fix is one
binding (`pass.set_vertex_buffer(1, self.decal_instance_buf.slice(..))`)
placed before both decal draws, plus a hermetic regression test in the
repo's source-scanning law style (a GPU integration test cannot run on
the project's headless CI). Verified end to end: fmt, clippy
`-D warnings`, the full workspace suite, the replay round-trip, the
determinism golden (`headless --seed 7 --ticks 300` still ends at
`0x9d5ba9b565060336`), and a real windowed run under Xvfb + lavapipe
where the unfixed build reproduces both panics and the fixed build
presents 600 frames and exits cleanly. Simulation behavior is
untouched — the change is client-rendering-only.

## M10.1 pre-declaration hardening note

`patches/012-m10.1-pre-declaration-hardening.patch` is the pass between M10 and
the Alpha declaration (AGENT-TASK-M10.1): the one open gate is A14 (the
human playtest), and it lacked its enabling machinery — no
`docs/PLAYTEST.md`, no client `--seed`, no client replay recording, no
§11.6 bug-report dump. The pass builds that machinery, repays the one
debt whose trigger had fired (DEBT-001), hardens the nightly soak, and
closes out the registers. Five commits, one logical change each:

1. **`feat(fx)`** — DEBT-001 repaid: `XxHash64` (the reference XXH64,
   written in-repo like PCG32 — the dependency law forbids
   `twox-hash`) becomes the canonical hasher behind the same
   `write_*`/`finish` surface. **The pass's single hash-moving
   commit**: every pinned golden re-pinned with its written reason
   (demo `0xb6fff6659cfb7709`, flagship `0x6e9a18bd7c5f699f`, tick-0
   `0x71a924ad5799e4b3`, content hash `0x9bc18c521107b262` / map id
   `0xd38136401ab02ff1`; the FNV-era values are history in the docs).
   Golden-tested against reference vectors (stripe boundaries
   31/32/33, a nonzero seed) plus a chunking-invariance property;
   `STATE_ENCODING_VERSION` and the replay `format_version`
   unchanged (A-087 — byte layouts identical, no replay files existed
   in the wild); `Fnv1a64` retained as the replay *file* checksum.
2. **`feat(client)`** — `--seed <u64>` (default 7), `--record <path>`
   (the segment's replay written at match end / clean exit — every
   exit path funnels through the winit `exiting` hook; `tools
   replay-verify` accepts the file), and **F8**: the §11.6
   deterministic bug-report dump (`pandemonium-report-<seed>-tick<tick>.pdrp`
   + the `-info.txt` sidecar with seed/tick/content identity/frame
   count/selection/controls line — no wall-clock; works while paused).
   Pure assembly in the new `crates/client/src/report.rs` with the
   client-seam A2 test (decode + `run_command_log` re-sim + hash
   equality), pause validity, and sidecar-determinism tests. Zero
   golden movement — client-only.
3. **`docs`** — `docs/PLAYTEST.md`, the A14 instrument, all eight
   sections (per-OS quickstart, the README's controls card + F8, the
   unaided-loop checklist, spectator legibility, the DEBT-011/012/A8
   probes, the F8 procedure, the five-row results table, the pass
   bar). Every referenced command was run against the tree before
   writing it down.
4. **`ci`** — the nightly soak sharded 10×100 (seeds disjoint by
   construction — the arithmetic proven in the workflow's comments),
   `timeout-minutes` on every job (90/shard, 30 smoke, 30 bench),
   per-shard evidence artifacts, and an aggregate job that gates on
   any nonzero `crashed` count. Zero Rust changes.
5. **`docs`** — the close-out: CHANGELOG folds `[Unreleased]` into
   `[M10]` and adds `[M10.1]`; DEBT-013 (the client monoliths) logged
   with the post-alpha split plan; DEBT-011/012 triggers sharpened to
   name their PLAYTEST.md probes; A-087..A-090 logged; AI-Handoff
   §2/§4/§5/§6/§8 refreshed (the "Next:" line now points at the
   playtest); ARCHITECTURE carries the post-alpha refactor map; the
   README's bug-report promise names F8 and the dump files; the stage
   badge stays `A14 playtest pending` (the owner flips it).

Green-gated end to end: fmt, clippy `-D warnings`, **414 dev / 409
release tests** (20 new: 8 fx, 12 client), the replay round-trip PASS
at the new identity, `content-validate` PASS, an 8-match soak spot
check (8/8 resolved, 0 crashed), and the §15 bench budgets still met
(0.25 ms avg, 2.25 ms p99, 4003 t/s). Windowed verification under
Xvfb + llvmpipe with XTEST injection (DEBT-008's recipe): `--seed 42`
runs and diverges from seed 7, `--record` writes at exit and
replay-verifies, two F8 presses (one mid-run, one during pause) both
replay-verify PASS, and the `.pdrp` is byte-identical across
same-tick presses.

Task 6 (optional CI binary artifacts for testers) was **dropped** per
its own escape clause: the task's mandated local verification failed —
the client's content resolution is compile-time baked
(`CARGO_MANIFEST_DIR`), so a CI-built binary cannot find `content/`
beside it on a tester's machine. The repo quickstart remains the
distribution path. Also flagged: **no LICENSE exists** — a public repo
taking external playtesters needs a license decision (the owner's
copyright, the owner's call; the game's README already says so).

## M10.2 Phase 1 (Controls) note

`patches/013-m10.2-phase1-controls.patch` is the M10.2 Phase 1 (Controls)
delivery: one patch file containing EVERY commit of the M10.2 Phase 1
pass (13 commits, one logical change each, never squashed, every commit
gate-green): the Generals ZH controls per docs/PLAN-M10.2.md — the
right-button command/drag threshold state machine (right-drag scroll),
middle-drag rotate, the depth-scaled 14 px edge-scroll band, selection
parity (shift+click/box, double-click same-kind, group double-tap
centering), the Escape ladder, the Space jump, the cursor order marker,
and the register/doc updates (PLAYTEST result #1, A-091..A-100,
DEBT-014/015, AI-Handoff, CHANGELOG, README controls card).

Base commit: `bdf1266c71ff1fee778b4507b34c4baf1ed8ed72` (master of
E-Vex/pandemonium-bd at the time of the pass).

Verification already performed on a fresh clone + `git am`:

- cargo fmt --all -- --check                          PASS
- cargo clippy --workspace --all-targets -- -D warnings  PASS
- cargo test --workspace (dev, 440 tests)             PASS
- cargo test --workspace --release (435 tests)        PASS
- golden hashes bit-identical to M10.1:
    demo     0xb6fff6659cfb7709  (seed 7, 300 ticks)
    flagship 0x6e9a18bd7c5f699f  (seed 7, 7200 ticks, AI vs AI)
    content  0x9bc18c521107b262  (map id 0xd38136401ab02ff1)
- Xvfb + XTEST input smoke: 1500 frames, EXACTLY ONE command submitted
  from two right-button gestures (the short click ordered the context
  Move; the 130-px drag scrolled and its release ordered nothing — the
  threshold machine's contract), control group recall + double-tap,
  rotate, Escape, Space, shift+click all exercised, match ongoing.

Scope: Phase 1 (Controls) only, per the owner's delivery answer (A-100).
Phases 2–4 (visual legibility, menus/settings, audio) are specified in
docs/PLAN-M10.2.md and wait on the owner's re-test of the controls
card (docs/PLAYTEST.md section 2). The Phase 4 audio backend is
pre-chosen as rodio (A-100); its architecture-law allow-list amendment
+ ADR land with that phase.

## M10.2 Phase 2 (Visual legibility) note

`patches/014-m10.2-phase2-visual-legibility.patch` is the M10.2 Phase 2
(Visual Legibility) delivery — the visual legibility half of the owner's
playtest finding #2, per docs/PLAN-M10.2.md Phase 2. One patch file
containing EVERY commit of the pass (14 commits, one logical change
each, never squashed, the branch gate-green at every step):

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
  selected entity (64×7 px vs 36×4), hover name tooltips with an owner
  tag (yours/enemy/neutral; suppressed over the bottom bar; big
  structures read from farther out via footprint-scaled reach), and a
  production-queue summary in the single-selection info panel;
- distinct minimap markers (§2.4): units one tile (own blue / enemy
  orange), buildings a solid 2×2 block, neutral ore a 3×3 amber
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

Base commit: `d84203ed2c49a2e9404ed80f2be25cd47984f271` (master of
E-Vex/pandemonium-bd at the time of the pass — the Phase 1 delivery
HEAD; the patch applies directly on top of it).

Verification already performed on a fresh clone + `git am`:

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

What to re-test (the visual pass):

- identify command center / worker / tank on sight, without a legend
  (the Guardian was not on camera in the Xvfb windows — the start
  force fields none; its silhouette is test-pinned only);
- tell the sides apart at a glance (blue vs orange, bands + rings);
- read the minimap (buildings bigger, ore diamonds) and the health
  state (the bigger selected bar, always visible);
- hover things — the tooltip names them;
- select the Command Center — the info panel shows its queue state;
  anything that does not read is a finding, not a wave-through.

Scope: Phase 2 (Visual legibility) only, per the owner's kickoff answers
(A-101). Phases 3–4 (menus/settings, audio) remain specified in
docs/PLAN-M10.2.md and wait on the owner's re-test verdict. The Phase 4
audio backend is pre-chosen as rodio (A-100); its architecture-law
allow-list amendment + ADR land with that phase.

## M10.2 Phase 3 note (menus and settings)

`patches/015-m10.2-phase3-menus-settings.patch` — 16 commits, base
`404e9066543c0ad89b1dffa966e2775e752abefc` (master of E-Vex/pandemonium-bd
at the time of the pass — the Phase 2 delivery HEAD; the patch applies
directly on top of it).

Scope: PLAN-M10.2 §3 (menu and settings) only, per the owner's go-ahead
(A-107: the Phase 2 re-test verdict was a pass). What landed:

- **§3.1 the state machine** — the new pure `crates/client/src/screens.rs`:
  `MainMenu -> (Settings | NewMatch) -> InMatch -> (PauseMenu | EndScreen)
  -> MainMenu` as (state, effect) transitions, a wrapping focus model shared
  by keyboard and mouse, and the three match modes' setup/controller mapping
  (Player vs AI = today's wiring; AI vs AI spectate = both slots driven;
  Sandbox = P2 present in the setup but controller-less, its force idles —
  A-112). 33 unit tests: every diagram edge, back-navigation, the settings
  return-memory, focus movement, seed editing.
- **§3.2/§3.3 the start flow** — the host construction is deferred: the game
  starts at the main menu and `begin_match` builds the host when Start is
  pressed (the A15 drop + reconstruct discipline — determinism unchanged,
  same-seed restarts still reproduce bit-for-bit). The New Match screen
  carries the mode, the seed (random by default from std's OS-entropy
  source, never the sim's RNG — A-111; `--seed N` pre-fills it), and the
  map from the content tree. Spectate silences the human order path at the
  orders layer (A-113). A latent wgpu bug the menu-first world exposed is
  fixed (the entity draw re-binds the camera group when no decals exist).
- **§3.4 settings** — the new `crates/client/src/config.rs`: a
  hand-written `key=value` file (no serde, no new crates — the allow-list is
  untouched), seven keys (edge_scroll, pan_speed, zoom_min, zoom_max,
  master_volume [stored/shown, audible in Phase 4], fullscreen,
  debug_overlay), per-key salvage on malformed values, range clamping, and
  the std-env config-dir resolution with the no-HOME/APPDATA fallback
  (persistence silently disabled, never a panic — A-108/A-109). DEBT-014
  repaid: the edge-scroll toggle is a settings row and the Phase 1 flag
  loads from the file. The engine's `DISTANCE_RANGE` is public and
  `RtsCamera::clamp_distance_to` applies user zoom limits (intersected with
  the engine's own range).
- **§3.5 the pause menu** — Esc's exhausted rung opens the pause menu
  instead of quitting the application (the earlier rungs — cancel armed,
  cancel placement, clear selection — are exactly as Phase 1 re-tested
  them; the rung test + both control cards carry the change in the same
  commit). Resume / Settings / Restart / Quit to Menu over the paused
  match; opening force-pauses through the existing MatchHost pause (A-114);
  P stays a direct toggle. The end screen promotes from InMatch when the
  host reports an outcome and offers Rematch / Main Menu (R remains).
- **§3.6 the menu UI** — `ui::build_menu` renders every screen through the
  existing fontdue overlay pass: solid panels, label/value rows, the
  focused row brightened with the Phase 2 blue/orange accents, hit rects
  in focus-index order. Every screen is keyboard AND mouse navigable;
  menus own the input (the world's clicks/keys/wheel/edge-scroll are dead
  while a menu is up, and held keys clear — A-116); nothing in a menu
  sends a sim command or touches a replay (a menu-only session records
  nothing).

Verification already performed on the delivery tree and re-performed on a
fresh clone + `git am`:

- cargo fmt --all -- --check                          PASS
- cargo clippy --workspace --all-targets -- -D warnings  PASS
- cargo test --workspace (dev, 523 tests)             PASS
- cargo test --workspace --release (518 tests)        PASS
- golden hashes bit-identical to M10.1/Phases 1-2:
    demo     0xb6fff6659cfb7709  (seed 7, 300 ticks)
    flagship 0x6e9a18bd7c5f699f  (seed 7, 7200 ticks, AI vs AI)
    content  0x9bc18c521107b262  (map id 0xd38136401ab02ff1)
- Xvfb + llvmpipe + XTEST (the machine half of the phase exit, DEBT-008
  recipe): keyboard alone navigates menu -> New Match -> Start (a match
  runs, tick 216); mouse alone does the same by clicking the rendered
  rows (tick 217); spectate and Sandbox both start and run; the pause
  menu opens by Esc, resumes (the sim tick froze for exactly the paused
  window: 80 ticks over 3 s), restarts (tick reset), and quits to menu;
  settings toggle, Done saves to the config file, and a fresh run reports
  "loaded the file" with the persisted value; a spectate match at seed 7
  resolved naturally through the real wgpu GL path — "player 0 wins
  (tick 10446, seed 7)" — matching the tools' headless reference for the
  same seed (resolved in (10400, 10500] by bisection), the end screen took
  the input, and R rematched (the exit line shows the fresh match at
  tick 99).
- The pass caught and fixed two live bugs the pure tests could not see:
  the zero-entity bind-group error (first menu frame) and the focus carry
  into an entered screen (the settings persistence run).

What to re-test (the human half):

- the game opens at a menu, not in a match;
- a match starts in each of the three modes and plays (spectate: the
  camera and selection stay live but your clicks order nothing — that is
  deliberate; sandbox: the enemy base just stands there);
- settings persist across runs (toggle edge scroll off, Done, relaunch,
  then back on — the startup line says where the settings came from);
- Esc opens the pause menu after the familiar cancel rungs; Resume,
  Restart, Quit to Menu all behave; P still pauses directly;
- the end screen offers Rematch and Main Menu (R still works);
- fullscreen toggles and the window comes back sane (Xvfb has no window
  manager, so the machine pass cannot prove this one — A-118);
- everything is reachable by keyboard alone and by mouse alone;
- nothing from the Phase 1 controls card or the Phase 2 visual pass
  regressed.

Registers: ASSUMPTIONS A-107..A-118, DEBT-014 repaid, DEBT-015 narrowed to
Phase 4 (audio) only, DEBT-017 added (the one-map terrain-mesh renderer
note). Scope: Phase 3 only. Phase 4 remains specified in
docs/PLAN-M10.2.md; the audio backend is pre-chosen (rodio, A-100), its
allow-list amendment + ADR due then.


## M10.2 Phase 4 note (audio)

`patches/016-m10.2-phase4-audio.patch` — 5 commits, base
`1210cbd2aba3826776f25d94a9ca23f166a221ed` (the Phase 3 delivery HEAD of
E-Vex/pandemonium-bd; the patch applies directly on top of it — master has
since carried two housekeeping commits past it, both ancestors-in-law to
nothing in this patch).

Scope: PLAN-M10.2 §4 (audio) only, per the owner's go-ahead (A-119: the
Phase 3 re-test verdict cleared the way, 2026-10-08). The goal, in the
plan's own words: "simple sounds that make events feel real." What landed:

- **§4.1 the backend** — rodio 0.22.2 joins the client as its only new
  external crate, `default-features = false, features = ["playback"]`:
  the decoder formats and the noise/rand machinery stay off because every
  sound this pass makes is synthesized PCM. The allow-list amendment and
  ADR-0002 (the owner's pre-choice A-100, the resolved version, the
  feature trim, the alternatives considered) landed in the same commit.
  rodio 0.22 renamed the stream owner: `MixerDeviceSink` is the old
  `OutputStream`'s successor — it is boxed inside the sink's arm enum and
  lives for the App's whole lifetime (dropping it silences everything;
  the match reset never re-probes, it only clears counters and the
  rate-limit windows).
- **§4.2 the sounds** — `crates/client/src/sound.rs`, pure: the `CueBank`
  synthesizes the nine cues' mono 44100 Hz PCM at startup (one fixed
  sample rate, logged at startup; every buffer under a second, pairwise
  distinct by construction, soft-limited into the rail, deterministic —
  two runs synthesize identical banks; no asset files). Six cues come
  from the existing `cue_for` event mapping (attack landed, unit lost,
  unit ready, structure done, delivery, match ended); three are
  client-side moments with no sim event — command ack, selection click,
  UI click — and arrive through a new `AudioSink::on_cue` method on the
  engine seam. The three have no `cue_for` arm BY DESIGN: nothing below
  the boundary learned anything, and the null sink counts them on their
  own counter (the wiring oracle the tests read).
- **§4.3 the fallback** — the sink's constructor probes the device once.
  On ANY failure (no device, Xvfb, CI) it falls back to the engine's
  `NullAudioSink` silently: no panic, no stderr spam, one honest startup
  line. A Linux `/dev/snd` pre-check skips the probe entirely on machines
  with no kernel sound stack — libasound's config parser would otherwise
  print a stderr burst on its way to the same conclusion (A-124). A
  device lost mid-session (the stream's error callback flags it) degrades
  to the null arm: one line, once, counting continues, never a panic, and
  the render loop is never blocked (voicing is an infallible channel send
  to rodio's mixing thread).
- **§4.4 the controls and the limiter** — master volume is live (the
  settings row drives the sink directly; A-115 semantics: changes apply
  immediately, Done saves, Esc leaves this run's value unsaved), and
  `muted` joins as the eighth config key right after it (settings row 5;
  fullscreen/debug shift to rows 6/7, Done to 8; keyboard and mouse both
  reach it — the focus map and the ui.rs button-id tests pin the
  nine-row layout). Mute beats volume and never zeros it (A-125:
  unmuting restores the loudness the player set; a Phase 3 seven-key
  file parses with mute off). The rate limiter is a pure struct in
  `sound.rs`, one 80 ms window PER CUE (a fight's attack storm does not
  silence the loss cues), sitting between the cue source and the sink
  arm — the drop path is one array lookup, so a big fight costs almost
  nothing until a voice survives the window.
- **the wiring (thin, in `main.rs`)** — the step's events still feed the
  sink after the step (FD-9's order kept); a submitted order
  acknowledges on the direct path ("acknowledged" = submitted, stamped
  and handed to the host — NOT non-rejected; the sim's verdict surfaces
  separately through the refusal feedback, A-120; spectate's silence
  carries over); every user-driven selection change funnels through one
  `set_selection` gate that cues the membership change (a redundant
  re-select is not a click, A-122); every menu row activation — Enter,
  mouse click, or the end screen's R shortcut — funnels through one
  `menu_activate` core that cues the UI click (A-121).

The honesty rule for this pass: **the machine cannot hear.** Every
machine-verified run (CI, Xvfb) takes the null arm, and the evidence
lines say exactly what the audio did — the arm first (active (rodio,
44100 Hz) / null fallback (no device), plus [muted] when muted), then the
cues' three fates (fed / voiced / dropped, and the client-side count) —
in the `--frames` windowed summary and the headless smoke. The machine
claims wiring, distinctness-by-construction, and counting; it never
claims the sounds are good.

Verification performed on the delivery tree and re-performed on a fresh
clone + `git am`:

- cargo fmt --all -- --check                          PASS
- cargo clippy --workspace --all-targets -- -D warnings  PASS
- cargo test --workspace (dev, 546 tests)             PASS
- cargo test --workspace --release (541 tests)        PASS
- golden hashes bit-identical to M10.1/Phases 1-3:
    demo     0xb6fff6659cfb7709  (seed 7, 300 ticks)
    flagship 0x6e9a18bd7c5f699f  (seed 7, 7200 ticks, AI vs AI)
    content  0x9bc18c521107b262  (map id 0xd38136401ab02ff1)
- the headless smoke constructs the real audio sink: the startup probe
  prints its one honest line (null fallback on the CI machine), the
  events flow, and the smoke's audio wiring line reports the counted
  fates; the smoke asserts the sink was fed, never that anything was
  audible.
- Xvfb + llvmpipe + XTEST (the machine half of the phase exit, DEBT-008
  recipe): a menu-only run (the null fallback's own evidence), a
  600-frame match run started through the real menu keys (the match
  ran, event cues counted 4/4/0), the settings pass — volume down 5%
  (row 4, Left), mute on (row 5, Enter), Done (row 8, Enter) — with the
  config file round-tripping `master_volume=0.95` / `muted=true`, a
  relaunch reporting "loaded the file" and the `[muted]` audio line, and
  an Esc-discard run on a fresh config that writes nothing (the
  unsaved-but-live mute still showed in that run's own audio line).
  The three client-side cues counted in the real binary (3 client-side
  on the settings run — the Settings open, the mute toggle, and Done).

What to re-test (the human half — this phase's re-test is entirely about
ears; the machine cannot hear):

- sounds actually play on real hardware (the startup line should say
  "active (rodio), 44100 Hz, 9 synthesized cues");
- each of the nine moments makes its sound and they are distinct:
  attack landed (a low thud), unit lost (a descending two-step), unit
  ready (a rising chirp), structure done (a low chord), delivery (a
  bright ding), match ended (a three-tone fanfare), command ack /
  selection click / UI click (three short blips you can tell apart);
- volume changes loudness live while playing; mute silences everything;
  both persist after Done + relaunch (and Esc discards, as the settings
  screen documents);
- a big fight reads as a heartbeat, not noise (the per-cue 80 ms
  limiter) — and units dying in that fight are still audible over the
  attack thuds;
- nothing from Phases 1-3 regressed (controls, visuals, menus,
  settings).

Registers: ASSUMPTIONS A-119..A-125, DEBT-011 repaid (the audible
backend, the synthesized bank, the limiter, the fallback, volume + mute,
the direct-path cues), DEBT-015 closed (all four playtest-1 phases
delivered; the A14 >=5-tester playtest gate is the owner's, not a
debt). Scope: Phase 4 only — the milestone's last. Next: the owner's
Phase 4 re-test, then the A14 playtest.
## M10.2 Phase 4 patch note - v2 (the rebase)

`patches/016-m10.2-phase4-audio-v2.patch` replaces 016 when applying on the
current `master`. Two commits landed upstream after 016 was cut on the
Phase 3 HEAD (1210cbd): 896c7c5 slimmed AI-Handoff.md (same section
numbers, about a thousand lines removed) and 08748d9 fixed a CI step name.
No code changed, so 016's first four commits still applied - but the docs
commit (0005) was written against the fat handoff, and `git am` rejected it
at AI-Handoff.md:31.

The v2 series is the same five commits (same subjects, same author) with
the closeout re-applied onto the slim handoff: the snapshot
(Status/Tests/Registers plus the one-paragraph), the 546 dev / 541 release
counts, the smoke's audio-evidence wording, the workspace-map and
inventory rows, the status board's M10.2 row (all four phases), the
not-built-yet list (the Phase 4 owner re-test merged with Phase 5; the
remaining items renumbered), and the three Phase 4 gotchas (the rodio
stream owner's lifetime, the on_cue client-side path, the cannot-hear
rule) - ported into the lean structure, not pasted over it.

Apply: checkout `master` (08748d9 or later), then `git am
patches/016-m10.2-phase4-audio-v2.patch`. If a partially-applied 016 is
sitting in the tree (`git am` stopped at 0005), run `git am --abort`
first - it rewinds the four already-applied commits too, so the v2 series
applies whole.

Re-verified end to end on 08748d9: fmt, clippy -D warnings, 546 dev /
541 release tests, the three goldens bit-identical, the headless smoke
with its audio evidence line, and the Xvfb machine pass (null fallback,
menu-only, a 600-frame match, the settings save/relaunch/discard runs).
One finding, pre-existing and outside the patch: the fx property test
`checked_div_agrees_in_range` flakes roughly once per few hundred runs
(entropy-seeded proptest finds a raw quotient that overflows i32, e.g.
a=-458752, b=-1, where `checked_div` correctly returns None and `div`
saturates - the test's guard only excludes b=0; fx is untouched by this
patch: `git diff 08748d9..HEAD --stat -- crates/fx` is empty). A test-guard
fix is a candidate for the owner's next pass; the library itself honors
its documented contract.

## M10.2 Phase 5 patch note (the closeout)

`patches/017-m10.2-phase5-closeout.patch` closes M10.2 — the
verification-and-handoff phase. Six commits on `652f6cf` (master's Phase 4
closeout), docs-only: no commit touches a `.rs` file, so the tree is
code-identical to Phase 4's.

What the phase verified (the full gate ran twice — once on the working
branch, once on a fresh clone after `git am`):

- fmt + clippy `-D warnings` clean; **546 dev / 541 release tests green**;
- the three goldens bit-identical: demo `0xb6fff6659cfb7709`, flagship
  `0x6e9a18bd7c5f699f`, content `0x9bc18c521107b262`;
- the replay round-trip (A2) PASS and the headless client smoke PASS with
  their audio evidence lines;
- an Xvfb + XTEST machine pass over the M10.2 paths — five sessions, 29
  checks, all green: a seed-7 vs-AI match driven end to end (a box-select
  of the five start entities, one right-click ground order, a right-drag
  scroll that issued **no** order — the 6 px threshold — and the Esc
  ladder through pause/resume), a menu-only session whose New Match row
  was mouse-activated, the settings persistence pair (volume to 0.95,
  mute on, Done saves, the relaunch loads the file and the audio line
  reports `[muted]`), and the Esc-discard run (no file written). The
  harness was built locally per the standing recipe (AI-Handoff §9), and
  its one new lesson — the bright 30 px band is the focused row's plate,
  not the panel border — is now a gotcha in the handoff itself.

The owner's Phase 4 real-hardware audio re-test verdict is recorded as
**pass, clean** (A-126, 2026-10-09): the nine cues are distinct, volume
is live, mute silences, both persist, and a big fight is a heartbeat.
DEBT-011 is fully repaid; M10.2 is complete. The A14 playtest is
scheduled — five first-time tester slots T1–T5 in `docs/PLAYTEST.md` §7,
three waves to 2026-10-31 — and it is the last gate before the Alpha
declaration.

Apply on a fresh clone:

```
git clone https://github.com/E-Vex/pandemonium-bd.git
cd pandemonium-bd
git checkout 652f6cf80fc1f817e06349935ff5e1b741ac9dc4
git am /path/to/017-m10.2-phase5-closeout.patch
```

Verified end to end: `git am` applies all six commits cleanly, the
am'ed tree hash is identical to the branch tree, and the full gate
re-ran green on the am'ed clone (fmt, clippy, 546 dev / 541 release,
the three goldens, the headless smoke).

The fx proptest `checked_div_agrees_in_range` flake (~1-in-250,
pre-existing, noted with 016-v2) did not fire in either gate run this
phase; the standing advice stays "re-run, don't fix".
