# Pandemonium patch archive

This is the delivery archive for **Pandemonium**, a classic real-time
strategy game built in Rust. The game's source code lives in its own
repository (`E-Vex/pandemonium-bd`) — this repo holds no source. Instead,
each milestone of work is delivered here as a numbered patch file: the
output of `git format-patch`, containing that milestone's commits in
order and with their original messages. Replaying the patches onto the
source repository rebuilds the project's history exactly.

## Layout

| Path        | What it is                                                                |
| ----------- | ------------------------------------------------------------------------- |
| `patches/`  | The patches, zero-padded and numbered so the listing reads oldest → newest |
| `NOTES.md`  | Per-patch delivery notes — scope, base commit, verification, open asks     |

## The patch chain

Each patch applies on the HEAD produced by the one before it, so they
must be applied in numerical order.

| #   | Milestone                          | Patch                                          | Commits | Status                                            |
| --- | ---------------------------------- | ---------------------------------------------- | ------- | ------------------------------------------------- |
| 001 | M6                                 | `001-m6-combat-vision.patch`                   | —       | applied                                           |
| 002 | M6                                 | `002-m6-readme-update.patch`                   | —       | applied                                           |
| 003 | M7                                 | `003-m7-ai-commands.patch`                     | 7       | applied                                           |
| 004 | M8                                 | `004-m8-match-rules.patch`                     | 6       | applied                                           |
| 005 | M8                                 | `005-m8-readme-update.patch`                   | 1       | ready                                             |
| 006 | M9                                 | `006-m9-alpha-content-feel-pass.patch`         | 6       | applied (see the M9 note)                         |
| 007 | M9.1                               | `007-m9.1-input-hotfix.patch`                  | 4       | ready — applies on the M9 HEAD (dad840a)          |
| 008 | pre-M10                            | `008-pre-m10-cleanup.patch`                    | 7       | ready — applies on the M9.1 HEAD (1a49c27)        |
| 009 | pre-M10                            | `009-pre-m10-review-and-scaffolding.patch`     | 8       | ready — applies on the M9.1 HEAD (5183fc8)        |
| 010 | M10                                | `010-m10-stabilization-and-declaration.patch`  | 10      | ready — applies on the pre-M10 review HEAD (a4393a1) |
| 011 | M10.1                              | `011-m10.1-decal-render-fix.patch`             | 1       | ready — applies on the M10 HEAD (8b4757a)         |
| 012 | M10.1                              | `012-m10.1-pre-declaration-hardening.patch`    | 5       | ready — applies on the decal-fix HEAD (6ec9693)   |
| 013 | M10.2 Phase 1 (Controls)           | `013-m10.2-phase1-controls.patch`              | 13      | delivered — base: pandemonium-bd master (bdf1266) |
| 014 | M10.2 Phase 2 (Visual legibility)  | `014-m10.2-phase2-visual-legibility.patch`     | 14      | delivered — base: the Phase 1 HEAD (d84203e)      |

For what each patch actually does, see the matching note in
[NOTES.md](NOTES.md).
