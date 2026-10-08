<div align="center">

<img src="assets/banner.svg" alt="Animated inferno banner: a glowing ember travels along the chain of Pandemonium patches 001 to 016, igniting each one in order" width="100%">

<img src="assets/tagline.svg" alt="Typewriter tagline cycling through: a classic RTS, built in Rust; 15 patches · 111 commits · one history; every milestone, kept as a patch; build. destroy. repeat." width="100%">

# PANDEMONIUM · PATCH ARCHIVE

**The complete delivery history of a classic real-time strategy game, built in Rust —**
**every milestone preserved as a numbered `git format-patch` file.**

[![Status][status-shield]][status-link]
[![Source repo][source-shield]][source-link]
[![Patches][patches-shield]][chain-link]
[![Commits archived][commits-shield]][chain-link]
[![Language][toplanguage-shield]](#tech-stack--shields)
[![Shell][shell-shield]](#tech-stack--shields)
[![Theme][theme-shield]](#the-inferno-theme)
[![Stars][stars-shield]][repo-link]

[![GitHub stars][stars-flat]][repo-link]
[![GitHub forks][forks-flat]][repo-link]
[![GitHub issues][issues-flat]][issues-link]
[![GitHub last commit][commit-flat]][commits-link]
[![GitHub top language][lang-flat]][repo-link]
[![License][license-flat]](#license)

<br />

**`Explore the archive`**

<a href="#overview"><img src="https://img.shields.io/badge/%20-Overview-FF3EA5?style=for-the-badge&labelColor=2D1743&logo=bookstack&logoColor=FFB020" alt="Overview"></a>
<a href="#table-of-contents"><img src="https://img.shields.io/badge/%20-Contents-9A5CA0?style=for-the-badge&labelColor=2D1743&logo=book&logoColor=F3E8FF" alt="Contents"></a>
<a href="#tech-stack--shields"><img src="https://img.shields.io/badge/%20-Tech%20Stack-FF8C00?style=for-the-badge&labelColor=2D1743&logo=rust&logoColor=white" alt="Tech Stack"></a>
<a href="#key-features"><img src="https://img.shields.io/badge/%20-Features-BD00FF?style=for-the-badge&labelColor=2D1743&logo=superhums&logoColor=FFD166" alt="Features"></a>
<a href="#the-patch-chain"><img src="https://img.shields.io/badge/%20-Patch%20Chain-FFD166?style=for-the-badge&labelColor=2D1743&logo=git&logoColor=FF3EA5" alt="Patch Chain"></a>
<a href="#installation--usage"><img src="https://img.shields.io/badge/%20-Usage-2ECC71?style=for-the-badge&labelColor=2D1743&logo=gnubash&logoColor=white" alt="Usage"></a>
<a href="#architecture--delivery-flow"><img src="https://img.shields.io/badge/%20-Architecture-FFB020?style=for-the-badge&labelColor=2D1743&logo=schema&logoColor=F3E8FF" alt="Architecture"></a>
<a href="#demo--showcase"><img src="https://img.shields.io/badge/%20-Demo-F3E8FF?style=for-the-badge&labelColor=2D1743&logo=youtube&logoColor=FF3EA5" alt="Demo"></a>

</div>

---

## Overview

This is the **delivery archive** for [**Pandemonium**](https://github.com/E-Vex/pandemonium-bd), a classic
real-time strategy game built in Rust with a *Generals: Zero Hour*-style feel. The game's source code lives
in its own repository — **this repo holds no source**. Instead, each milestone of work is archived here as a
numbered patch file: the output of `git format-patch`, containing that milestone's commits in order and with
their original messages.

> [!IMPORTANT]
> **Archive, not installer.** The patches are a record of what was delivered — kept for reference and
> history, **not meant to be applied**. Treat `patches/` like git-bisect evidence, not an update channel.

> **Theme: Inferno.** This README is styled for a dark, volcanic look — an eggplant-black canvas
> (`#150A1E`) with hot magenta (`#FF3EA5`), ember orange (`#FF8C00` / `#FFB020`) and gold (`#FFD166`)
> accents, lit by a purple-to-flame gradient (`#BD00FF → #FF8C00`). Patches glow like embers along the
> chain. All assets honor `prefers-reduced-motion` and render cleanly in GitHub **dark and light** modes.

### At a glance

| Metric | Value | Meaning |
| :--- | :---: | :--- |
| **Patches** | **16 files / 15 deliveries** | Numbered `001`–`016`, zero-padded, oldest → newest |
| **Commits archived** | **111** | Every delivery commit, message intact |
| **Milestones** | **M6 → M10.2** | Combat vision → AI → match rules → polish phases |
| **Quality gates** | **Green end-to-end** | `fmt` · `clippy -D warnings` · 350+ tests · pinned goldens |
| **Determinism** | **Zero golden movement** | Bit-identical hashes re-verified per delivery |

---

## Table of Contents

- [Overview](#overview)
- [Tech Stack & Shields](#tech-stack--shields)
- [Key Features](#key-features)
- [The Patch Chain](#the-patch-chain)
  - [Per-patch notes](#per-patch-notes)
- [Repository Layout](#repository-layout)
- [Installation & Usage](#installation--usage)
  - [Verifying a patch file](#verifying-a-patch-file)
  - [The RUNME.sh easter egg](#the-runmesh-easter-egg)
- [Architecture & Delivery Flow](#architecture--delivery-flow)
- [Demo & Showcase](#demo--showcase)
- [The Inferno Theme](#the-inferno-theme)
- [Contributing](#contributing)
- [Roadmap](#roadmap)
- [License](#license)
- [Contact & Credits](#contact--credits)

---

<div align="center">

## Tech Stack & Shields

*The tools that forge the archive.*

<table>
<tr>
<td align="center" width="33%"><img src="https://skillicons.dev/icons?i=rust" width="56" alt="Rust"><br><b>Rust</b><br><sub>The game language —<br>deterministic RTS engine</sub></td>
<td align="center" width="33%"><img src="https://skillicons.dev/icons?i=git" width="56" alt="Git"><br><b>Git</b><br><sub><code>format-patch</code> ·<br><code>am</code> · SHAs as receipts</sub></td>
<td align="center" width="33%"><img src="https://skillicons.dev/icons?i=bash" width="56" alt="Bash"><br><b>Bash</b><br><sub>Repo tooling &<br>the <code>RUNME.sh</code> prank</sub></td>
</tr>
<tr>
<td align="center"><img src="https://skillicons.dev/icons?i=md" width="56" alt="Markdown"><br><b>Markdown</b><br><sub>Docs-first archive:<br>README · NOTES · CHANGELOG</sub></td>
<td align="center"><img src="https://skillicons.dev/icons?i=html" width="56" alt="HTML/SVG"><br><b>Animated SVG</b><br><sub>Banner, tagline &<br>flame-chart assets</sub></td>
<td align="center"><img src="https://cdn.simpleicons.org/githubactions/BD00FF" width="48" alt="GitHub Actions"><br><b>CI (upstream)</b><br><sub>rust-cache ·<br><code>cargo audit</code> nightly</sub></td>
</tr>
</table>

[![Rust][rust-shield]](https://www.rust-lang.org)
[![Git][git-shield]](https://git-scm.com/docs/git-format-patch)
[![Bash][bash-shield]](https://www.gnu.org/software/bash/)
[![Markdown][md-shield]](https://daringfireball.net/projects/markdown/)
[![Shields.io][shieldsshield]](https://shields.io)
[![GitHub][gh-shield]](https://docs.github.com)
[![Clippy][clippy-shield]](#key-features)
[![Golden tests][golden-shield]](#key-features)

</div>

---

## Key Features

> One milestone in, one immutable artifact out — the whole project history fits in a folder listing.

| Feature | What it gives you |
| :--- | :--- |
| **Numbered patch chain** | Zero-padded `001`–`016` names so `ls` reads chronologically, oldest → newest |
| **Faithful `git format-patch` output** | Original commit messages, authorship and diffs — nothing rewritten |
| **Base-commit provenance** | Each patch records the exact source SHA it was generated against |
| **Per-patch delivery notes** | [`NOTES.md`](NOTES.md): scope, verification results, open asks — appended, never edited mid-file |
| **Green-gated deliveries** | fmt + `clippy -D warnings` + full test suites before any patch ships |
| **Bit-identical goldens** | Pinned demo / flagship / content hashes re-verified — determinism is a contract |
| **Animated Inferno assets** | SVG banner, typewriter tagline and flame-chart in [`assets/`](assets) |
| **Reduced-motion friendly** | Every animation degrades gracefully under `prefers-reduced-motion` |
| **One scripted easter egg** | [`RUNME.sh`](RUNME.sh) — fake progress bar, dancing figure, sad trombone |

<details>
<summary><b>Why "zero golden movement" matters</b> — click to expand</summary>

<br>

Pandemonium's simulation is hash-pinned: deterministic *goldens* (e.g. demo
`0x9d5ba9b565060336`, flagship `0x01b3b60b741f03e9`, content
`0x249b69f0ee343a10`) must stay **bit-identical** across refactors and fixes.
A delivery that moves a golden without a written, test-pinned reason is a
regression. That rule is why this archive can be trusted as evidence of what
changed — and what provably did *not*.

</details>

---

## The Patch Chain

Patches are numbered in delivery order, oldest → newest, and are kept here as an **archive** — they are not
meant to be applied. The **Base** column is the source-repo commit each patch was generated against, as
recorded at delivery time (`—` where no base was recorded).

<div align="center">
<img src="assets/commits.svg" alt="Animated flame-chart: bars of ember gradient color grow one by one for each patch, from 12 commits in patch 001 up to 16 in patch 015, ending at a glowing 111-commit total" width="100%">
</div>

| No. | Milestone | Patch | Commits | Base |
| :-: | :--- | :--- | :-: | :--- |
| 001 | M6 | [`001-m6-combat-vision.patch`](patches/001-m6-combat-vision.patch) | 12 | — |
| 002 | M6 | [`002-m6-readme-update.patch`](patches/002-m6-readme-update.patch) | 1 | — |
| 003 | M7 | [`003-m7-ai-commands.patch`](patches/003-m7-ai-commands.patch) | 7 | — |
| 004 | M8 | [`004-m8-match-rules.patch`](patches/004-m8-match-rules.patch) | 6 | — |
| 005 | M8 | [`005-m8-readme-update.patch`](patches/005-m8-readme-update.patch) | 1 | — |
| 006 | M9 | [`006-m9-alpha-content-feel-pass.patch`](patches/006-m9-alpha-content-feel-pass.patch) | 6 | M8 HEAD `2861479` |
| 007 | M9.1 | [`007-m9.1-input-hotfix.patch`](patches/007-m9.1-input-hotfix.patch) | 4 | M9 HEAD `dad840a` |
| 008 | pre-M10 | [`008-pre-m10-cleanup.patch`](patches/008-pre-m10-cleanup.patch) | 7 | M9.1 HEAD `1a49c27` |
| 009 | pre-M10 | [`009-pre-m10-review-and-scaffolding.patch`](patches/009-pre-m10-review-and-scaffolding.patch) | 8 | M9.1 HEAD `5183fc8` |
| 010 | M10 | [`010-m10-stabilization-and-declaration.patch`](patches/010-m10-stabilization-and-declaration.patch) | 10 | review HEAD `a4393a1` |
| 011 | M10.1 | [`011-m10.1-decal-render-fix.patch`](patches/011-m10.1-decal-render-fix.patch) | 1 | M10 HEAD `8b4757a` |
| 012 | M10.1 | [`012-m10.1-pre-declaration-hardening.patch`](patches/012-m10.1-pre-declaration-hardening.patch) | 5 | decal-fix HEAD `6ec9693` |
| 013 | M10.2 · Phase 1 — Controls | [`013-m10.2-phase1-controls.patch`](patches/013-m10.2-phase1-controls.patch) | 13 | master `bdf1266` |
| 014 | M10.2 · Phase 2 — Visual legibility | [`014-m10.2-phase2-visual-legibility.patch`](patches/014-m10.2-phase2-visual-legibility.patch) | 14 | Phase 1 HEAD `d84203e` |
| 015 | M10.2 · Phase 3 — Menus & settings | [`015-m10.2-phase3-menus-settings.patch`](patches/015-m10.2-phase3-menus-settings.patch) | 16 | master `404e906` |
| 016 | M10.2 · Phase 4 — Audio | [`016-m10.2-phase4-audio.patch`](patches/016-m10.2-phase4-audio.patch) | 5 | Phase 3 HEAD `1210cbd` |
| 016‑v2 | M10.2 · Phase 4 — Audio *(rebased)* | [`016-m10.2-phase4-audio-v2.patch`](patches/016-m10.2-phase4-audio-v2.patch) | 5 | master `08748d9` |

Commit counts are the number of commits inside each patch file. **Total: 111 commits archived.**

### Per-patch notes

Detailed delivery notes — scope, base commit, verification transcript, open asks — live in
[`NOTES.md`](NOTES.md), ordered oldest → newest. New notes are **appended at the bottom, never inserted in
the middle**.

<details>
<summary><b>Milestone digest</b> — what each era delivered (click to expand)</summary>

<br>

| Era | Highlights |
| :--- | :--- |
| **M6–M8** (`001`–`005`) | Combat & vision systems, AI commands, match rules — plus README doc-sync patches |
| **M9 / M9.1** (`006`–`007`) | Alpha content & feel pass (regenerated from scratch, tree-hash verified); input hotfix — mirrored keys fixed, edge-scroll, middle-drag, zoom-to-cursor, right-click context orders, selection brackets; **zero golden movement**, Xvfb + XTEST re-verified (900 frames) |
| **pre-M10** (`008`–`009`) | Review-and-improve pass: `rust-cache` CI + nightly `cargo audit`, property tests for fixed-point math, dead assertion replaced; performance work & *Generals: Zero Hour*-style feel, M10 scaffolding |
| **M10 / M10.1** (`010`–`012`) | Stabilization & declaration, decal render fix, pre-declaration hardening |
| **M10.2 Phases 1–4** (`013`–`016`) | Controls → visual legibility → menus & settings → audio (Phase 4 rebased as **016-v2** onto the slim handoff at `08748d9`) |

</details>

---

## Repository Layout

```text
stationRepo/
├── patches/            #  The archive — 16 numbered git format-patch files (001 → 016)
│   ├── 001-m6-combat-vision.patch
│   ├── ...             #    zero-padded: the listing reads oldest → newest
│   └── 016-m10.2-phase4-audio-v2.patch
├── assets/             #  Animated SVGs powering this README
│   ├── banner.svg      #       ember travelling the patch chain
│   ├── tagline.svg     #       typewriter tagline
│   └── commits.svg     #       flame-chart, 111 commits
├── NOTES.md            #  Per-patch delivery notes (append-only)
├── CHANGELOG.md        #  Repo-level changelog
├── RUNME.sh            #  A harmless prank — see below
├── README.md           #  You are here
└── .gitignore          #  Build dirs + secret files ignored
```

---

## Installation & Usage

There is nothing to install or build — this repository contains **no source code**. Clone it to read the
history, inspect any delivery, or enjoy the easter egg.

<details open>
<summary><b>Step 1 — Clone the archive</b></summary>

```bash
git clone https://github.com/elieaazzam-art/stationRepo.git
cd stationRepo

# browse the chain, oldest first
ls patches/
```

</details>

<details>
<summary><b>Step 2 — Read a delivery like an email</b></summary>

Every file is RFC-2822-style `git format-patch` output: header lines, then one section per commit with its
message and diff.

```bash
# just the commit list of a milestone
grep '^Subject:' patches/013-m10.2-phase1-controls.patch

# skim the human-readable summary of what changed
git apply --stat patches/013-m10.2-phase1-controls.patch
```

</details>

### Verifying a patch file

Want proof a patch applies cleanly against its recorded base? Do it in a **throwaway clone of the source
repo** — never against your working copy, and never permanently in this archive:

<details>
<summary><b>Dry-run check (applies nothing)</b></summary>

```bash
# 1. get the source repo and check out the patch's recorded base commit
git clone https://github.com/E-Vex/pandemonium-bd.git && cd pandemonium-bd
git checkout <base-sha>              # e.g. bdf1266 for patch 013

# 2. dry-run the archived patch — three levels of strictness
git apply --check    ../stationRepo/patches/013-m10.2-phase1-controls.patch
git apply --stat     ../stationRepo/patches/013-m10.2-phase1-controls.patch
git am --dry-run     ../stationRepo/patches/013-m10.2-phase1-controls.patch   # git ≥ 2.42

# 3. leave the experiment behind
git am --abort 2>/dev/null; cd .. && rm -rf pandemonium-bd
```

> [!TIP]
> If `--check` fails, the base SHA recorded in [The Patch Chain](#the-patch-chain) is the place to look
> first — several patches chain off a previous patch's HEAD rather than a tagged release.

</details>

### The `RUNME.sh` easter egg

<details>
<summary><b>What happens if you run it?</b> (spoilers: nothing dangerous)</summary>

<br>

```bash
chmod +x RUNME.sh
./RUNME.sh
```

It **does not** apply anything. It is a prank: a fake patch-applying progress bar, a dancing ASCII figure,
and a sad trombone. Completely harmless — it never touches git, your files, or the network, writes exactly
one temp WAV (deleted on exit), and bails out instantly under Ctrl-C. In non-interactive contexts (CI,
pipes) it prints the punchline and exits `1`, so automation can never mistake the joke for a successful
patch run.

</details>

---

## Architecture & Delivery Flow

How a milestone travels from the source repo into this archive:

```text
 E-Vex/pandemonium-bd                          elieaazzam-art/stationRepo
┌─────────────────────────┐                   ┌──────────────────────────────┐
│  feature branch / work  │                   │                              │
│          │              │                   │                              │
│          ▼              │                   │                              │
│  quality gate:          │    delivery       │   patches/NNN-<milestone>.   │
│   fmt · clippy -D warn  │ ════════════════► │   patch                      │
│   dev + release tests   │  git format-patch │      │                       │
│   golden hashes pinned  │  --stdout         │      ▼                       │
│          │              │                   │  NOTES.md entry (appended)   │
│          ▼              │                   │      │                       │
│  milestone HEAD ────────┼── base SHA ───────┼──────┤ recorded in the       │
│  (tagged / announced)   │                   │      ▼    chain table        │
└─────────────────────────┘                   │  CHANGELOG.md / README.md    │
                                              │  refresh (doc-sync patches)  │
                                              └──────────────────────────────┘
```

| Stage | Contract |
| :--- | :--- |
| **1 · Work** | Happens exclusively in the source repo — this archive never holds code |
| **2 · Gate** | fmt, `clippy -D warnings`, full dev + release test suites, bit-identical goldens |
| **3 · Extract** | `git format-patch` over the milestone's commits, in order, messages untouched |
| **4 · Archive** | Stored as `NNN-<milestone>-<slug>.patch`; base SHA recorded in the chain table |
| **5 · Document** | Delivery note appended to `NOTES.md`; repo changelog updated |

---

## Demo & Showcase

> **GIF / screenshot slots — drop media into [`assets/`](assets) and it will light up automatically.**

<div align="center">

<table>
<tr>
<td align="center" width="33%">
<img src="https://placehold.co/320x180/150A1E/FF3EA5?text=%E2%96%B6+Gameplay+GIF&font=mono" alt="Gameplay capture placeholder"><br>
<b>Gameplay</b><br><sub>M10.2 combat & controls in motion<br><i>(replace with <code>assets/gameplay.gif</code>)</i></sub>
</td>
<td align="center" width="33%">
<img src="https://placehold.co/320x180/150A1E/FFB020?text=Menus+%26+HUD&font=mono" alt="Menus placeholder"><br>
<b>Menus & HUD</b><br><sub>Phase 3 settings & legibility pass<br><i>(replace with <code>assets/menus.png</code>)</i></sub>
</td>
<td align="center" width="33%">
<img src="https://placehold.co/320x180/150A1E/BD00FF?text=Terminal&font=mono" alt="Terminal placeholder"><br>
<b>Terminal vibes</b><br><sub><code>RUNME.sh</code> in action (screen-record!)<br><i>(replace with <code>assets/runme.gif</code>)</i></sub>
</td>
</tr>
</table>

</div>

---

## The Inferno Theme

<p align="center">
<code>#150A1E</code> · <code>#2D1743</code> · <code>#46266B</code> · <code>#BD00FF</code> · <code>#FF3EA5</code> · <code>#FF8C00</code> · <code>#FFB020</code> · <code>#FFD166</code> · <code>#F3E8FF</code>
</p>

| Swatch | Token | Role |
| :---: | :--- | :--- |
| ![Swatch](https://img.shields.io/badge/_-150A1E-150A1E?style=flat-square) | `#150A1E` | Eggplant-black canvas |
| ![Swatch](https://img.shields.io/badge/_-2D1743-2D1743?style=flat-square) | `#2D1743` / `#46266B` | Panel fills & borders |
| ![Swatch](https://img.shields.io/badge/_-BD00FF-BD00FF?style=flat-square) | `#BD00FF` | Purple side of the flame gradient |
| ![Swatch](https://img.shields.io/badge/_-FF3EA5-FF3EA5?style=flat-square) | `#FF3EA5` | Hot magenta — primary accent |
| ![Swatch](https://img.shields.io/badge/_-FF8C00-FF8C00?style=flat-square) | `#FF8C00` / `#FFB020` | Ember orange — heat & chart fire |
| ![Swatch](https://img.shields.io/badge/_-FFD166-FFD166?style=flat-square) | `#FFD166` | Gold — numbers & highlights |
| ![Swatch](https://img.shields.io/badge/_-F3E8FF-F3E8FF?style=flat-square) | `#F3E8FF` | Lilac text |

All animated assets ([`assets/`](assets)) share this palette, respect `prefers-reduced-motion`, and carry
descriptive `alt` text so the archive stays readable in any theme or screen reader.

---

## Contributing

Contributions are welcome — docs, notes, and metadata keep this archive honest.

1. Fork the repository
2. Create your branch: `git checkout -b docs/my-note`
3. Make your change (notes are **append-only**; never rewrite patch history)
4. Add a line to [`CHANGELOG.md`](CHANGELOG.md)
5. Open a Pull Request

> [!NOTE]
> `patches/*.patch` files are immutable historical artifacts. Corrections belong in a new note or a new
> patch delivery (as `016-v2` demonstrates), never in-place edits.

## Roadmap

| Status | Milestone | Scope |
| :---: | :--- | :--- |
| **Done** | **M6 – M9.1** | Combat vision, AI commands, match rules, alpha feel, input hotfix |
| **Done** | **pre-M10 – M10.1** | Cleanup & review pass, stabilization & declaration, decal fix, hardening |
| **Done** | **M10.2 Phases 1–4** | Controls, visual legibility, menus & settings, audio (v2 rebased) |
| **Next** | **Next deliveries** | Continue upstream in [E-Vex/pandemonium-bd](https://github.com/E-Vex/pandemonium-bd) — archived here as `017…` |

---

## License

No license file ships with this archive yet; all rights are presumed reserved by the authors. A deliberate
SPDX choice (MIT / Apache-2.0 / CC0 for docs) is tracked as an open ask — until then, treat the contents as
**reference material**. *(The badge above shows* `license · pending`*, matching GitHub's* `NOASSERTION`*
report:.)*

## Contact & Credits

<div align="center">

<table>
<tr>
<td align="center"><a href="https://github.com/elieaazzam-art"><img src="https://img.shields.io/badge/Maintainer-@elieaazzam--art-FF3EA5?style=for-the-badge&logo=github&logoColor=white" alt="Maintainer"></a><br><sub>Curator of this patch archive</sub></td>
<td align="center"><a href="https://github.com/E-Vex/pandemonium-bd"><img src="https://img.shields.io/badge/Source%20repo-E--Vex%2Fpandemonium--bd-FF8C00?style=for-the-badge&logo=rust&logoColor=white" alt="Source repository"></a><br><sub>Where the game itself lives</sub></td>
<td align="center"><a href="https://github.com/elieaazzam-art/stationRepo/issues"><img src="https://img.shields.io/badge/Issues-Bug%20reports%20%26%20asks-BD00FF?style=for-the-badge&logo=github&logoColor=white" alt="Issues"></a><br><sub>Questions about a delivery</sub></td>
</tr>
</table>

<sub><b>Inferno theme</b> — eggplant-black canvas (<code>#150A1E</code>), ember accents
(<code>#FF3EA5</code> / <code>#FF8C00</code> / <code>#FFD166</code>) and lilac text
(<code>#F3E8FF</code>) across all animated assets.</sub>

<br />

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&pause=1000&color=FF3EA5&background=150A1E&center=true&vCenter=true&width=435&lines=build.;destroy.;repeat." alt="Typing SVG: build. destroy. repeat." />

<br />

<sub>15 patches · 111 commits · one history — made with <b>Rust</b>, <b>git</b> and fire.</sub>

</div>

<!-- ─────────────────────────── reference-style shields ─────────────────────────── -->
[status-shield]: https://img.shields.io/badge/status-active_archive-2ECC71?style=for-the-badge&logo=checkmarx&logoColor=white
[status-link]: #the-patch-chain
[source-shield]: https://img.shields.io/badge/source-E--Vex%2Fpandemonium--bd-FF8C00?style=for-the-badge&logo=rust&logoColor=white
[source-link]: https://github.com/E-Vex/pandemonium-bd
[patches-shield]: https://img.shields.io/badge/patches-15-FF3EA5?style=for-the-badge&labelColor=2D1743
[chain-link]: #the-patch-chain
[commits-shield]: https://img.shields.io/badge/commits-111-FFD166?style=for-the-badge&labelColor=2D1743
[toplanguage-shield]: https://img.shields.io/badge/language-Rust-DEA584?style=for-the-badge&logo=rust&logoColor=white
[shell-shield]: https://img.shields.io/badge/tooling-Shell-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white
[theme-shield]: https://img.shields.io/badge/theme-Inferno-BD00FF?style=for-the-badge&labelColor=2D1743&logoColor=FFB020
[stars-shield]: https://img.shields.io/github/stars/elieaazzam-art/stationRepo?style=for-the-badge&logo=starship&logoColor=FFD166&color=FFD166&labelColor=2D1743
[repo-link]: https://github.com/elieaazzam-art/stationRepo
[stars-flat]: https://img.shields.io/github/stars/elieaazzam-art/stationRepo?style=social
[forks-flat]: https://img.shields.io/github/forks/elieaazzam-art/stationRepo?style=social
[issues-flat]: https://img.shields.io/github/issues/elieaazzam-art/stationRepo?style=social
[commit-flat]: https://img.shields.io/github/last-commit/elieaazzam-art/stationRepo?style=social
[lang-flat]: https://img.shields.io/github/languages/top/elieaazzam-art/stationRepo?style=social
[license-flat]: https://img.shields.io/badge/license-pending-9A5CA0?style=social&labelColor=2D1743
[issues-link]: https://github.com/elieaazzam-art/stationRepo/issues
[commits-link]: https://github.com/elieaazzam-art/stationRepo/commits/main
[rust-shield]: https://img.shields.io/badge/Rust-2024%20edition-DEA584?style=flat-square&logo=rust&logoColor=white
[git-shield]: https://img.shields.io/badge/git--format--patch-RFC--2822-F05032?style=flat-square&logo=git&logoColor=white
[bash-shield]: https://img.shields.io/badge/Bash-tooling-4EAA25?style=flat-square&logo=gnubash&logoColor=white
[md-shield]: https://img.shields.io/badge/Markdown-docs--first-000000?style=flat-square&logo=markdown&logoColor=white
[shieldsshield]: https://img.shields.io/badge/Shields.io-badges-33CCFF?style=flat-square&logo=shieldsdotio&logoColor=white
[gh-shield]: https://img.shields.io/badge/GitHub-archive-181717?style=flat-square&logo=github&logoColor=white
[clippy-shield]: https://img.shields.io/badge/clippy--D%20warnings-green?style=flat-square&labelColor=2D1743
[golden-shield]: https://img.shields.io/badge/goldens-bit--identical-FFB020?style=flat-square&labelColor=2D1743
