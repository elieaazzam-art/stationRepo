# Pandemonium patches

Patches are numbered in the order they were produced and applied:
`001-` is the oldest entry, and **every new patch is appended at the
bottom with the next sequence number** — never inserted in the middle.
Because of the zero-padded prefixes, the file listing (which sorts
alphabetically) always reads oldest → newest, top → bottom.

| # | Milestone | Patch | Commits | Status |
|---|---|---|---|---|
| 001 | M6 | `001-m6-combat-vision.patch` | — | applied |
| 002 | M6 | `002-m6-readme-update.patch` | — | applied |
| 003 | M7 | `003-m7-ai-commands.patch` | 7 | applied |
| 004 | M8 | `004-m8-match-rules.patch` | 6 | applied |
| 005 | M8 | `005-m8-readme-update.patch` | 1 | ready |
| 006 | M9 | `006-m9-alpha-content-feel-pass.patch` | 6 | applied (see the M9 note) |
| 007 | M9.1 | `007-m9.1-input-hotfix.patch` | 4 | ready — applies on the M9 HEAD (dad840a) |
| 008 | pre-M10 | `008-pre-m10-cleanup.patch` | 7 | ready — applies on the M9.1 HEAD (1a49c27) |
| 009 | pre-M10 | `009-pre-m10-review-and-scaffolding.patch` | 8 | ready — applies on the M9.1 HEAD (5183fc8), the project owner's "review and improve before M10" pass |
| 010 | M10 | `010-m10-stabilization-and-declaration.patch` | 10 | ready — applies on the pre-M10 review HEAD (a4393a1) |
| 011 | M10.1 | `011-m10.1-decal-render-fix.patch` | 1 | ready — applies on the M10 HEAD (8b4757a), the first-frame decal crash fix |
| 012 | M10.1 | `012-m10.1-pre-declaration-hardening.patch` | 5 | ready — applies on the decal-fix HEAD (6ec9693), the pre-declaration hardening & A14 enablement pass |

## Adding a new patch

1. Name the file with the next sequence number, e.g. the next patch is
   `012-<short-name>.patch`.
2. Append its row to the **bottom** of the table above (it is the
   latest entry — do not reorder or renumber existing rows).
3. Add its note section at the **bottom** of the notes below (above
   "Applying a patch"), so the notes read oldest → newest too.

## M9 note

`006-m9-alpha-content-feel-pass.patch` was regenerated from scratch. The
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
`007-m9.1-input-hotfix.patch` fixes all of it — plan §11.3's input slice
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

`008-pre-m10-cleanup.patch` is the review-and-improve pass over M0–M9.1 the
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

`009-pre-m10-review-and-scaffolding.patch` is the deeper review-and-improve
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

The previous `008-pre-m10-cleanup.patch` (7 commits) was the surface pass
(CI cache, community files, doc comments, one no-op assertion fix, four
fx property tests). This patch is the deeper pass — the hot-path
optimizations, the Generals-feel additions, and the M10 scaffolding the
plan §12 deliverables list calls for. They stack cleanly: the cleanup
patch lands first (on M9.1 HEAD 1a49c27), then this patch lands on top
of it (it was authored against 5183fc8, the M9.1 HEAD as of this pass).

## M10.1 decal render fix note

`011-m10.1-decal-render-fix.patch` fixes the deterministic first-frame
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

`012-m10.1-pre-declaration-hardening.patch` is the pass between M10 and
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
copyright, the owner's call; the README already says so).

## Applying a patch

```bash
git am <sequence>-<name>.patch
```

The patches are `git format-patch` output (one file per milestone, each
containing the milestone's commits in order). Apply on a clean tree at the
previous milestone's HEAD. The full chain, in order:

```bash
git am 001-m6-combat-vision.patch
git am 002-m6-readme-update.patch
git am 003-m7-ai-commands.patch
git am 004-m8-match-rules.patch
git am 005-m8-readme-update.patch
git am 006-m9-alpha-content-feel-pass.patch
git am 007-m9.1-input-hotfix.patch
git am 008-pre-m10-cleanup.patch
git am 009-pre-m10-review-and-scaffolding.patch
git am 010-m10-stabilization-and-declaration.patch
git am 011-m10.1-decal-render-fix.patch
git am 012-m10.1-pre-declaration-hardening.patch
```
