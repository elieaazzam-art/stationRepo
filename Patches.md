# Pandemonium patches

`git am`-able patches from the Pandemonium milestone work, newest first.

## `m7-ai-commands.patch` (238 KB, 7 commits) — M7: AI through commands

The full M7 milestone series, for a repo at the M6 baseline (`fa38451`):

1. `feat(ai): Controller trait + the scripted Alpha opponent (plan §9.6, M7)`
2. `refactor(sim): one canonical command-log driver (repay DEBT-005)`
3. `feat(engine): AiMatchHost — controllers on the tick boundary (plan §9.6, M7)`
4. `feat(tools): headless --p1/--p2 ai controller slots + replay-verify world resolution (plan §12, M7)`
5. `test(ai): M7 exit suite — A5 + A11 green, AI-vs-AI matches complete (plan §14 M7)`
6. `ci: AI match round-trip in the replay job + AI quick-start in binaries (M7)`
7. `docs: bring the handoff, architecture, assumptions, and README current through M7`

Scope: 22 files, +4196/−192 — the `Controller` trait with the scripted Alpha
opponent (gather management, build/train script, size+timer waves, defense),
`AiMatchHost` running controllers on the tick boundary, headless
`--p1/--p2 demo|ai|idle` slots, the 8-test M7 acceptance suite (A5 + A11,
mirrored 20-pair battery + proptest fuzz), CI wiring, and full docs
(AI-Handoff, ARCHITECTURE, ASSUMPTIONS A-060..A-065, DEBT-005 repaid).

Verified before shipping: applying the patch to a clean clone of `fa38451`
reproduces tree `6ad244164790dfb747103654036db485041e5487` bit-for-bit; the
patched tree passes the full workspace suite (27 test binaries, 0 failures)
with both determinism goldens unchanged (demo hash `0x9d5ba9b565060336`,
content identity `0x249b69f0ee343a10`).

Apply on a repo at the M6 baseline (`fa38451`):

```bash
cd pandemonium-bd
git checkout fa38451   # the M6 baseline HEAD
git am m7-ai-commands.patch
cargo test --workspace # expect all green
```

**Do NOT apply on top of a repo that already has the M7 commits** — it will
conflict with itself. If the tree moved past `fa38451`, try `git am -3`.

---

## `m6-combat-vision.patch` (205 KB, 11 commits) — M6: Combat & Vision

The full M6 milestone series, for a repo at the M5 baseline (`cabdf1f`):

1. `docs(sim): decide DEBT-010 — over-cap allowed, spawn-blocking (A-053)`
2. `feat(sim): map Attack capability at the world seam (DEBT-006 retired)`
3. `docs: log A-056 — M6 encoding bump (state v4 + fixture v4)`
4. `feat(sim): combat pipeline — stage 7 immediate-hit attack (plan §9.2)`
5. `feat(sim): Attack/AttackMove/Stop command semantics (plan §8.1, §9.2)`
6. `test(combat): full-pipeline kill — death lifecycle + id-never-reused + slot clear`
7. `feat(sim): three-state fog (plan §9.5) — Hidden/Explored/Visible per player per tile`
8. `docs: log A-057/A-058/A-059 — combat acquisition tie-break, vision-vs-acquire, fog-state placement`
9. `test(combat,vision): M6 acceptance suite + A12 combat invariants`
10. `test(content): A3 fight half — the data-defined kind fires AttackHit (DEBT-007 retired)`
11. `docs: update AI-Handoff (§2/§4/§5/§6/§8/§9) + ARCHITECTURE for M6`

Apply on a repo at `cabdf1f`:

```bash
cd pandemonium-bd
git checkout cabdf1f   # the M5 baseline HEAD
git am m6-combat-vision.patch
```

## `m6-readme-update.patch` (11 KB, 1 commit) — M6 README polish

Single commit that updates `README.md` to reflect M6 completion:
- Stage badge: `M5_economy_done` → `M6_combat_&_vision_done`
- "Inside a tick" table: stages 5/7/8/9 now live
- "Current status": M0–M6 complete, 269 dev / 264 release tests
- Roadmap: M6 → Complete, M7 → Next

Apply on top of a repo that already has the M6 work:

```bash
cd pandemonium-bd
git am m6-readme-update.patch
```

**The two M6 patches are mutually exclusive scopes**: use the combat-vision
one to replay the full milestone from M5, or the readme-update one to add the
README polish on top of an already-merged M6.
