<p align="center">
  <img src="assets/banner.svg" alt="Animated banner: a packet travels along the chain of Pandemonium patches 001 to 015, lighting each one in order" width="100%">
</p>

<p align="center">
  <img src="assets/tagline.svg" alt="Typewriter tagline cycling through: a classic RTS, built in Rust; 15 patches, 111 commits, one history; every milestone, kept as a patch; build, destroy, repeat" width="100%">
</p>

# Pandemonium patch archive

<br>

<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&pause=1000&color=3B82F6&background=0B1220&center=true&vCenter=true&width=435&lines=dark+theme;classic+RTS+%E2%80%A2+built+in+Rust;15+patches+%E2%80%A2+111+commits" alt="Typing SVG: dark theme; classic RTS, built in Rust; 15 patches, 111 commits" />
</p>

This is the delivery archive for **Pandemonium**, a classic real-time
strategy game built in Rust. The game's source code lives in its own
repository (`E-Vex/pandemonium-bd`) — this repo holds no source. Instead,
each milestone of work is archived here as a numbered patch file: the
output of `git format-patch`, containing that milestone's commits in
order and with their original messages. The patches are a record of what
was delivered — kept for reference and history, not meant to be applied.

> **Theme:** this README is styled for a **dark** look — deep-navy animated
> banner, tagline and chart (see [`assets/`](assets)), bright blue accents
> and light text, so it reads cleanly on GitHub's dark mode and any dark
> Markdown viewer.

## Layout

| Path             | What it is                                                                 |
| ---------------- | -------------------------------------------------------------------------- |
| `patches/`       | The archived patches, zero-padded and numbered so the listing reads oldest → newest |
| `NOTES.md`       | Per-patch delivery notes — scope, base commit, verification, open asks     |
| `assets/`        | Animated SVGs used by this README (banner, tagline, chart)                 |
| `apply-all.sh`   | A harmless prank: fake progress, a dancing figure, a sad trombone. Applies nothing |

## The patch chain

Patches are numbered in delivery order, oldest → newest, and are kept
here as an archive — they are not meant to be applied. The **Base**
column is the source-repo commit each patch was generated against, as
recorded when it was delivered (`—` where no base was recorded).

<p align="center">
  <img src="assets/commits.svg" alt="Animated bar chart: one bar per patch showing its commit count, from 12 commits in patch 001 up to 16 in patch 015, with a running total that ends at 111 commits" width="100%">
</p>

| #   | Milestone                         | Patch                                         | Commits | Base                                       |
| --- | --------------------------------- | --------------------------------------------- | ------- | ------------------------------------------ |
| 001 | M6                                | `001-m6-combat-vision.patch`                  | 12      | —                                          |
| 002 | M6                                | `002-m6-readme-update.patch`                  | 1       | —                                          |
| 003 | M7                                | `003-m7-ai-commands.patch`                    | 7       | —                                          |
| 004 | M8                                | `004-m8-match-rules.patch`                    | 6       | —                                          |
| 005 | M8                                | `005-m8-readme-update.patch`                  | 1       | —                                          |
| 006 | M9                                | `006-m9-alpha-content-feel-pass.patch`        | 6       | M8 HEAD (2861479) — see the M9 note        |
| 007 | M9.1                              | `007-m9.1-input-hotfix.patch`                 | 4       | M9 HEAD (dad840a)                          |
| 008 | pre-M10                           | `008-pre-m10-cleanup.patch`                   | 7       | M9.1 HEAD (1a49c27)                        |
| 009 | pre-M10                           | `009-pre-m10-review-and-scaffolding.patch`    | 8       | M9.1 HEAD (5183fc8)                        |
| 010 | M10                               | `010-m10-stabilization-and-declaration.patch` | 10      | pre-M10 review HEAD (a4393a1)              |
| 011 | M10.1                             | `011-m10.1-decal-render-fix.patch`            | 1       | M10 HEAD (8b4757a)                         |
| 012 | M10.1                             | `012-m10.1-pre-declaration-hardening.patch`   | 5       | decal-fix HEAD (6ec9693)                   |
| 013 | M10.2 Phase 1 (Controls)          | `013-m10.2-phase1-controls.patch`             | 13      | `pandemonium-bd` master (bdf1266)          |
| 014 | M10.2 Phase 2 (Visual legibility) | `014-m10.2-phase2-visual-legibility.patch`    | 14      | Phase 1 HEAD (d84203e)                     |
| 015 | M10.2 Phase 3 (Menus & settings)  | `015-m10.2-phase3-menus-settings.patch`       | 16      | master (404e906) — the Phase 2 HEAD        |
| 016 | M10.2 Phase 4 (Audio)             | `016-m10.2-phase4-audio.patch`                | 5       | Phase 3 HEAD (1210cbd)                     |
| 016-v2 | M10.2 Phase 4 (Audio, rebased)  | `016-m10.2-phase4-audio-v2.patch` | 5       | master (08748d9) - 016 re-applied on the slim handoff |

Commit counts are the number of commits in each patch file. For what each
patch actually does, see the matching note in [NOTES.md](NOTES.md) (not
every patch has one yet).

## Badges

<p align="center">
  <img src="https://img.shields.io/badge/Pandemonium-patch%20archive-0B1220?style=for-the-badge&logoColor=white" alt="Pandemonium patch archive">
  <img src="https://img.shields.io/badge/patches-15-3B82F6?style=for-the-badge" alt="15 patches">
  <img src="https://img.shields.io/badge/commits-111-93C5FD?style=for-the-badge" alt="111 commits">
  <img src="https://img.shields.io/badge/language-Rust-4ADE80?style=for-the-badge&logo=rust&logoColor=white" alt="Built in Rust">
  <img src="https://img.shields.io/badge/theme-dark%20navy-1E293B?style=for-the-badge&logoColor=white" alt="Dark navy theme">
</p>

---

<p align="center">
  <sub><b>Dark theme</b> — deep-navy canvas (<code>#0B1220</code>), blue accents
  (<code>#3B82F6</code> / <code>#93C5FD</code>) and light text
  (<code>#E2E8F0</code>) across all animated assets. Best viewed in GitHub dark mode.</sub>
</p>
