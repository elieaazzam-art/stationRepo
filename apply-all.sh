#!/usr/bin/env bash
# apply-all.sh -- "applies" every patch in patches/.
#
# It does not. This is a prank: a fake patch-applying progress bar, a dancing
# ASCII figure, and a sad trombone. Completely harmless -- it never touches
# git, your files or the network, and it only writes one temp WAV file, which
# it deletes on exit. Press Ctrl-C at any time to bail out.
#
# usage: apply-all.sh [anything]    (arguments are ignored)
# the real thing:  git am patches/*.patch   (see README.md)
set -uo pipefail

# Automation must never mistake the joke for a successful patch run.
if [ ! -t 1 ]; then
  echo "apply-all.sh: gotcha! This is a prank script -- nothing was applied." >&2
  echo "apply-all.sh: to really apply the patches: git am patches/*.patch" >&2
  exit 1
fi

tmp=""
wav=""
snd_pid=""

# shellcheck disable=SC2329  # invoked via trap
cleanup() {
  [ -n "$snd_pid" ] && kill "$snd_pid" 2>/dev/null
  [ -n "$tmp" ] && rm -rf "$tmp"
  printf '\033[?25h\033[0m'
}
trap cleanup EXIT
trap 'echo; exit 130' INT TERM

if [ -z "${NO_COLOR:-}" ]; then
  col() { printf '\033[38;5;%sm' "$1"; }
  rst=$'\033[0m'
else
  col() { :; }
  rst=""
fi

# ---------------------------------------------------------------- sound ----
# Synthesizes a cartoon "boing" followed by a sad trombone into a WAV file.
make_sound() {
  command -v python3 >/dev/null 2>&1 || return 1
  python3 - "$1" <<'PY' 2>/dev/null || return 1
import math, struct, sys, wave

SR = 22050
out = []

def silence(sec):
    out.extend([0.0] * int(SR * sec))

def boing(dur=0.55, amp=0.45):
    phase = 0.0
    for i in range(int(SR * dur)):
        t = i / SR
        f = 260 + 140 * math.exp(-3 * t) + 260 * math.sin(2 * math.pi * 10 * t) * math.exp(-4 * t)
        phase += 2 * math.pi * f / SR
        out.append(amp * math.exp(-3 * t) * math.sin(phase))

def brass(f0, dur, f1=None, vib=0.0, amp=0.3):
    f1 = f0 if f1 is None else f1
    n = int(SR * dur)
    phase = 0.0
    for i in range(n):
        t, p = i / SR, i / n
        f = (f0 + (f1 - f0) * p) * (1 + vib * math.sin(2 * math.pi * 5.5 * t))
        phase += 2 * math.pi * f / SR
        bright = 0.35 + 0.65 * math.sin(math.pi * min(1.0, p * 1.1))  # the "wah"
        s = sum(math.sin(h * phase) / h ** (1.6 - 0.9 * bright) for h in range(1, 8))
        env = min(1.0, t / 0.04) * min(1.0, (dur - t) / 0.08)
        out.append(amp * env * s / 2.2)

boing()
silence(0.15)
for f in (233.08, 220.00, 207.65):   # wah, wah, wah ...
    brass(f, 0.45)
    silence(0.06)
brass(196.00, 1.5, f1=170.0, vib=0.03)  # ... waaaaaah

with wave.open(sys.argv[1], "wb") as w:
    w.setnchannels(1)
    w.setsampwidth(2)
    w.setframerate(SR)
    w.writeframes(b"".join(struct.pack("<h", int(max(-1.0, min(1.0, x)) * 32767)) for x in out))
PY
}

play_wav() {
  if   command -v afplay >/dev/null 2>&1; then afplay "$1" >/dev/null 2>&1 &
  elif command -v paplay >/dev/null 2>&1; then paplay "$1" >/dev/null 2>&1 &
  elif command -v aplay  >/dev/null 2>&1; then aplay -q "$1" >/dev/null 2>&1 &
  elif command -v play   >/dev/null 2>&1; then play -q "$1" >/dev/null 2>&1 &
  elif command -v ffplay >/dev/null 2>&1; then ffplay -nodisp -autoexit -loglevel quiet "$1" >/dev/null 2>&1 &
  else return 1
  fi
  snd_pid=$!
}

play_fallback() {
  local msg="wah wah wah waaah. You have been pranked."
  if   command -v say       >/dev/null 2>&1; then say "$msg" >/dev/null 2>&1 &
  elif command -v espeak-ng >/dev/null 2>&1; then espeak-ng "$msg" >/dev/null 2>&1 &
  elif command -v espeak    >/dev/null 2>&1; then espeak "$msg" >/dev/null 2>&1 &
  elif command -v spd-say   >/dev/null 2>&1; then spd-say -w "$msg" >/dev/null 2>&1 &
  else return 1
  fi
  snd_pid=$!
}

play_sound() {
  printf '\a'  # the terminal bell, for good measure
  if [ -n "$wav" ] && play_wav "$wav"; then return 0; fi
  play_fallback
}

tmp="$(mktemp -d 2>/dev/null || true)"
if [ -n "$tmp" ]; then
  wav="$tmp/prank.wav"
  make_sound "$wav" || wav=""
fi

# ------------------------------------------------------------ animation ----
steps=(
  "reticulating splines"
  "convincing git that you are in charge"
  "feeding the build hamsters"
  "untangling the commit graph"
  "downloading more RAM"
  "polishing the pixels"
  "asking the compiler nicely"
  "bribing the linter"
  "negotiating with merge conflicts"
  "summoning the Pandemonium"
  "applying patches to the patches"
  "teaching Rust to dance"
  "calibrating the fun levels"
  "almost done (probably)"
)
total=${#steps[@]}

bar() {  # $1 = percent
  local width=30 filled i out=""
  filled=$(( $1 * width / 100 ))
  for ((i = 0; i < width; i++)); do
    if [ "$i" -lt "$filled" ]; then out+="#"; else out+="."; fi
  done
  printf '[%s] %3d%%' "$out" "$1"
}

spin() {  # $1 = seconds, $2 = label
  # shellcheck disable=SC1003  # the backslash is a spinner frame, not an escape
  local frames='|/-\' end=$((SECONDS + $1)) i=0
  while [ "$SECONDS" -lt "$end" ]; do
    printf '\r\033[K%s %s' "${frames:$((i % 4)):1}" "$2"
    sleep 0.1
    i=$((i + 1))
  done
}

printf '\033[?25l'
echo "$(col 51)apply-all.sh$rst: applying the Pandemonium patch chain..."
echo

for ((n = 0; n < total; n++)); do
  num="$(printf '%03d' $((n + 1)))"
  printf '\r\033[K'
  printf '%s==>%s %s  %s ... %sok%s\n' "$(col 244)" "$rst" "$num" "${steps[n]}" "$(col 46)" "$rst"
  bar $(( (n + 1) * 99 / total ))
  sleep 0.22
done

sleep 0.5
printf '\r\033[K'
spin 2 "stuck at 99%... any moment now..."
printf '\r\033[K%shmm.%s\n' "$(col 214)" "$rst"
sleep 0.6
printf '%sERROR: unexpected amount of awesomeness detected.%s\n' "$(col 196)" "$rst"
sleep 1.2
echo

# ------------------------------------------------------------- the joke ----
rainbow=(196 202 208 214 220 226 190 154 118 82 46 48 51 45 39 33 27 57 93 129 165 201)
nr=${#rainbow[@]}
banner="*** YOU'VE BEEN PRANKED! ***"

fig0=(' \(^o^)/ ' '   ( )   ' '   / \   ')
fig1=('  (^o^)  ' ' <(   )> ' '   / \   ')
fig2=(' /(^o^)\ ' '   ( )   ' '   | |   ')
fig3=('  (^o^)  ' '  /( )\  ' '  _/ \_  ')
sway=(0 2 4 6 4 2)

draw() {  # $1 = frame number
  local f=$1 pad i line
  pad="$(printf '%*s' "${sway[f % 6]}" '')"
  printf '%s' "$pad"
  for ((i = 0; i < ${#banner}; i++)); do
    printf '%s%s' "$(col "${rainbow[(i + f) % nr]}")" "${banner:i:1}"
  done
  printf '%s\033[K\n' "$rst"
  for ((i = 0; i < 3; i++)); do
    case $((f % 4)) in
      0) line="${fig0[i]}" ;;
      1) line="${fig1[i]}" ;;
      2) line="${fig2[i]}" ;;
      *) line="${fig3[i]}" ;;
    esac
    printf '%s%s%s%s\033[K\n' "$pad" "$(col "${rainbow[(f * 2 + i * 4) % nr]}")" "$line" "$rst"
  done
}

play_sound
for ((f = 0; f < 34; f++)); do
  [ "$f" -gt 0 ] && printf '\033[4A'
  draw "$f"
  sleep 0.11
done

echo
echo "Just kidding! Nothing was applied. No files were harmed."
echo "The real thing:  git am patches/*.patch"

[ -n "$snd_pid" ] && wait "$snd_pid" 2>/dev/null
snd_pid=""
exit 0
