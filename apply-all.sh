#!/usr/bin/env bash
# Apply the numbered patches in patches/ to a checkout of the source repo.
#
# usage: apply-all.sh <source-repo-dir> [first] [last]
#   first/last are patch numbers (e.g. 013 014); default is all patches.
set -euo pipefail

if [ $# -lt 1 ] || [ $# -gt 3 ]; then
  echo "usage: $0 <source-repo-dir> [first] [last]" >&2
  exit 2
fi

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="$1"
first="${2:-000}"
last="${3:-999}"

git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 \
  || { echo "error: $repo is not a git repository" >&2; exit 1; }
[ -z "$(git -C "$repo" status --porcelain)" ] \
  || { echo "error: $repo has uncommitted changes" >&2; exit 1; }

applied=0
for patch in "$here"/patches/[0-9][0-9][0-9]-*.patch; do
  name="$(basename "$patch")"
  num="${name%%-*}"
  # force base-10 so 008/009 are not read as invalid octal
  [ $((10#$num)) -ge $((10#$first)) ] && [ $((10#$num)) -le $((10#$last)) ] || continue
  echo "==> $name"
  if ! git -C "$repo" am "$patch"; then
    echo "error: $name failed to apply; 'git am' is still in progress in $repo" >&2
    echo "       inspect it, or run 'git -C $repo am --abort' to back out" >&2
    exit 1
  fi
  applied=$((applied + 1))
done

echo "done: $applied patch(es) applied; HEAD is $(git -C "$repo" rev-parse --short HEAD)"
