Pandemonium M10.2 — Phase 1 (Controls) delivery
================================================

What this is
------------
One patch file containing EVERY commit of the M10.2 Phase 1 pass
(13 commits, one logical change each, never squashed, every commit
gate-green): the Generals ZH controls per docs/PLAN-M10.2.md — the
right-button command/drag threshold state machine (right-drag scroll),
middle-drag rotate, the depth-scaled 14 px edge-scroll band, selection
parity (shift+click/box, double-click same-kind, group double-tap
centering), the Escape ladder, the Space jump, the cursor order marker,
and the register/doc updates (PLAYTEST result #1, A-091..A-100,
DEBT-014/015, AI-Handoff, CHANGELOG, README controls card).

Base commit
-----------
bdf1266c71ff1fee778b4507b34c4baf1ed8ed72
(master of E-Vex/pandemonium-bd at the time of the pass)

How to apply
------------
    git clone https://github.com/E-Vex/pandemonium-bd.git
    cd pandemonium-bd
    git checkout bdf1266c71ff1fee778b4507b34c4baf1ed8ed72
    git am /path/to/m10.2-all-commits.patch

That preserves every commit and its message. The patch's author is
`elieaazzam-art <elieaazzam-art@users.noreply.github.com>` (GitHub
attributes those commits to the account on push); `git am` stamps you
as the committer from your local git config — if you would rather be
the author as well, follow with:

    git rebase --root --exec 'git commit --amend --no-edit --reset-author'

Verification already performed on a fresh clone + git am
--------------------------------------------------------
- cargo fmt --all -- --check                          PASS
- cargo clippy --workspace --all-targets -- -D warnings  PASS
- cargo test --workspace (dev, 440 tests)             PASS
- cargo test --workspace --release (435 tests)        PASS
- golden hashes bit-identical to M10.1:
    demo     0xb6fff6659cfb7709  (seed 7, 300 ticks)
    flagship 0x6e9a18bd7c5f699f  (seed 7, 7200 ticks, AI vs AI)
    content  0x9bc18c521107b262  (map id 0xd38136401ab02ff1)
- Xvfb + XTEST input smoke: 1500 frames, EXACTLY ONE command submitted
  from two right-button gestures (the short click ordered the context
  Move; the 130-px drag scrolled and its release ordered nothing — the
  threshold machine's contract), control group recall + double-tap,
  rotate, Escape, Space, shift+click all exercised, match ongoing.

Scope
-----
Phase 1 (Controls) only, per the owner's delivery answer (A-100).
Phases 2-4 (visual legibility, menus/settings, audio) are specified in
docs/PLAN-M10.2.md and wait on the owner's re-test of the controls
card (docs/PLAYTEST.md section 2). The Phase 4 audio backend is
pre-chosen as rodio (A-100); its architecture-law allow-list amendment
+ ADR land with that phase.
