# Changelog

## 2026-10-09 — Delivery 018: post-M10.2 soak-instrument patch

- **`patches/018-post-m10.2-soak-instrument.patch`** — 3 commits on
  master `f23e7cc`: the A7 soak instrument's crash telemetry made real
  (per-match `catch_unwind` panic isolation with seed attribution, the
  report survives the crash, exit stays non-zero), the nightly's
  evidence contract (aggregate runs on tier failure; a dev-profile
  `soak-dev` tier sweeps the A12 checker at soak scale), and the
  registers (A-127, DEBT-018).
- Zero sim movement: no diffs under `crates/sim`, `sim_api`, `fx`, `ai`,
  `content/`; goldens bit-identical; **553 dev / 548 release** green.
- Full note and apply instructions in [`NOTES.md`](NOTES.md).

## 2026-10-08 — Repo update (sync with working branch)

- Synced the repository with the latest local working state (`master`).
- `.gitignore` updated to ignore token/secret files:
  - `TOKEN.txt`, `.env`, `*.token`
- Full patch archive available on the `main` branch (patches `001`–`016`,
  including the M10.2 Phase 4 audio delivery, `016-m10.2-phase4-audio-v2`).

See [README.md](README.md) and [NOTES.md](NOTES.md) on the `main` branch for
the complete milestone history.
## 2026-10-09 — README theme: "Inferno"

- Restyled the README from the dark-navy/blue theme to a new **Inferno** theme:
  eggplant-black canvas (#150A1E), hot magenta (#FF3EA5), ember orange
  (#FF8C00 / #FFB020), gold (#FFD166) and lilac text (#F3E8FF).
- Recolored all animated assets in `assets/` (banner.svg, tagline.svg,
  commits.svg): node glows, progress line, chart gradient now run purple →
  pink → orange like an ember flame; patch-chain nodes glow violet.
- Updated typing-banner URL, badges, theme callout and footer swatch notes,
  plus SVG alt/description texts, to match the new theme. Animations and
  layout are unchanged.
