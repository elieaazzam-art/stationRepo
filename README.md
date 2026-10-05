# Pandemonium patches

| Milestone | Patch | Commits | Status |
|---|---|---|---|
| M6 | `m6-combat-vision.patch` | — | applied |
| M6 | `m6-readme-update.patch` | — | applied |
| M7 | `m7-ai-commands.patch` | 7 | applied |
| M8 | `m8-match-rules.patch` | 6 | applied |
| M8 | `m8-readme-update.patch` | 1 | ready |
| M9 | `m9-alpha-content-feel-pass.patch` | 6 | applied (see the M9 note) |
| M9.1 | `m9.1-input-hotfix.patch` | 4 | ready — applies on the M9 HEAD (dad840a) |
| pre-M10 | `pre-m10-cleanup.patch` | 7 | ready — applies on the M9.1 HEAD (1a49c27) |

## pre-M10 note

`pre-m10-cleanup.patch` is the review-and-improve pass over M0–M9.1 the
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

## M9.1 note

The first human playtest of the windowed client (DEBT-008) found the
input layer mirrored and half-missing: D panned left and A right (the
camera's screen-right axis has been negated since M3), W retreated,
the mouse could not move the camera at all, there was no way to order an
attack, rejected orders were silent, the opening zoom rendered the
starting force as specks, and the M9 feedback cues never expired.
`m9.1-input-hotfix.patch` fixes all of it — plan §11.3's input slice
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

## M9 note

`m9-alpha-content-feel-pass.patch` was regenerated from scratch. The
first attempt in this repo (commit c669ce9) tuned AI constants and added
an audio stub but never re-pinned the AI-vs-AI golden it moved, added no
M9 exit tests, and left the actual stall (chase orders outliving their
dead targets) unfixed — applying it to the M8 HEAD would leave the test
suite red. The replacement applies cleanly on the M8 HEAD (2861479),
reproduces its tree exactly (verified: identical tree hashes), and is
green-gated end to end: fmt, clippy -D warnings, 333 dev / 328 release
tests, demo golden untouched, the moved flagship re-pinned twice with
written reasons in the tests themselves.

## Applying a patch

```bash
git am <milestone>.patch
```

The patches are `git format-patch` output (one file per milestone, each
containing the milestone's commits in order). Apply on a clean tree at the
previous milestone's HEAD.
