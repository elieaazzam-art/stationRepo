# Pandemonium patches

| Milestone | Patch | Commits | Status |
|---|---|---|---|
| M6 | `m6-combat-vision.patch` | — | applied |
| M6 | `m6-readme-update.patch` | — | applied |
| M7 | `m7-ai-commands.patch` | 7 | applied |
| M8 | `m8-match-rules.patch` | 6 | applied |
| M8 | `m8-readme-update.patch` | 1 | ready |
| M9 | `m9-alpha-content-feel-pass.patch` | 6 | ready — replaces the earlier M9 attempt (216 lines: constant tweaks without the root-cause sim fix, no golden re-pins despite moving the flagship hash, no exit tests — it would have failed the green gate) |

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
