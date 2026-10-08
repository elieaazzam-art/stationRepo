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
[![Clippy][clippy-shield]](https://github.com/rust-lang/rust-clippy)
[![Golden tests][golden-shield]](NOTES.md)

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



[status-shield]: https://img.shields.io/badge/status-active%20archive-FF3EA5?style=for-the-badge&logo=box&logoColor=white
[source-shield]: https://img.shields.io/badge/source-E--Vex%2Fpandemonium--bd-BD00FF?style=for-the-badge&logo=github&logoColor=white
[patches-shield]: https://img.shields.io/badge/patches-16%20files%20%C2%B7%2015%20deliveries-FF8C00?style=for-the-badge&logo=git&logoColor=white
[commits-shield]: https://img.shields.io/badge/commits%20archived-111-FFD166?style=for-the-badge&logo=commitlint&logoColor=150A1E
[theme-shield]: https://img.shields.io/badge/theme-Inferno-FF3EA5?style=for-the-badge&labelColor=BD00FF
[rust-shield]: https://img.shields.io/badge/Rust-1.85%2B-dea584?style=flat-square&logo=rust&logoColor=white
[git-shield]: https://img.shields.io/badge/Git-format--patch-f03c2e?style=flat-square&logo=git&logoColor=white
[bash-shield]: https://img.shields.io/badge/Bash-tooling-4EAA25?style=flat-square&logo=gnubash&logoColor=white
[md-shield]: https://img.shields.io/badge/Markdown-docs%20first-000000?style=flat-square&logo=markdown&logoColor=white
[shieldsshield]: https://img.shields.io/badge/Shields.io-badges-31D8FF?style=flat-square
[gh-shield]: https://img.shields.io/badge/GitHub-hosted-222222?style=flat-square&logo=github&logoColor=white
[clippy-shield]: https://img.shields.io/badge/clippy--D%20warnings-8A2BE2?style=flat-square
[golden-shield]: https://img.shields.io/badge/golden%20tests-bit%20identical-FFD166?style=flat-square&labelColor=2D1743
[source-link]: https://github.com/E-Vex/pandemonium-bd
[repo-link]: https://github.com/elieaazzam-art/stationRepo
