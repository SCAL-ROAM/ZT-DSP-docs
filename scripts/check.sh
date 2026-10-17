#!/usr/bin/env bash
# Repository-local self-check. Runs in the git root.
set -eu
root=$(git rev-parse --show-toplevel)
cd "$root"

cn_file="cn/spec/ZT-DSP-1.0.0-总指导.md"
en_file="en/spec/ZT-DSP-1.0.0-Master_Guide.md"
for f in "$cn_file" "$en_file"; do
  [ -f "$f" ] || { echo "missing spec file: $f"; exit 1; }
done

cn=$(wc -l < "$cn_file" | tr -d ' ')
en=$(wc -l < "$en_file" | tr -d ' ')
if [ "$cn" != "$en" ]; then
  echo "spec mirrors are not aligned: cn=$cn en=$en"
  exit 1
fi
echo "spec mirrors aligned at $cn lines"
