<div align="center">

<img src="assets/banner.svg" alt="Animated inferno banner: a glowing ember travels along the chain of Pandemonium patches 001 to 016, igniting each one in order" width="100%">

<img src="assets/tagline.svg" alt="Typewriter tagline cycling through: a classic RTS, built in Rust; 15 patches · 111 commits · one history; every milestone, kept as a patch; build. destroy. repeat." width="100%">

# PANDEMONIUM · PATCH ARCHIVE

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


