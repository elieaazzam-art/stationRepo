# Pandemonium patches

| Milestone | Patch | Commits | Status |
|---|---|---|---|
| M6 | `m6-combat-vision.patch` | — | applied |
| M6 | `m6-readme-update.patch` | — | applied |
| M7 | `m7-ai-commands.patch` | 7 | applied |
| M8 | `m8-match-rules.patch` | 6 | ready |

## Applying a patch

```bash
git am <milestone>.patch
```

The patches are `git format-patch` output (one file per milestone, each
containing the milestone's commits in order). Apply on a clean tree at the
previous milestone's HEAD.
