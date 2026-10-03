# Pandemonium M6 patches

Two `git am`-able patches from the M6 (Combat & Vision) milestone work.

## `m6-readme-update.patch` (11 KB, 1 commit)

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

## `m6-combat-vision.patch` (205 KB, 11 commits)

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

**Do NOT apply `m6-combat-vision.patch` on top of a repo that already has
the M6 commits** — it will conflict with itself. The two patches are
mutually exclusive scopes: use the combat-vision one to replay the full
milestone from M5, or the readme-update one to add the README polish on
top of an already-merged M6.
