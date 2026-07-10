#!/usr/bin/env bash
# AESP suite structural validator — REQ uniqueness, file layout, YAML presence
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
ERR=0

echo "== AESP suite validator =="

need_three() {
  local n="$1"
  for sfx in "" "-continued" "-reference"; do
    f="specification/AESP-${n}${sfx}.md"
    if [[ ! -f "$f" ]]; then
      echo "MISSING $f"; ERR=1
    fi
  done
  y="specification/aesp-${n}.yaml"
  if [[ ! -f "$y" ]]; then
    echo "MISSING $y"; ERR=1
  fi
}

for n in 0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015; do
  need_three "$n"
done
[[ -f specification/AESP-0000.md ]] || { echo "MISSING AESP-0000.md"; ERR=1; }
[[ -f aesp.yaml || -f specification/aesp-0000.yaml ]] || echo "WARN: no aesp-0000.yaml (root aesp.yaml OK)"

check_prefix() {
  local pref="$1"; shift
  local files=("$@")
  local tmp
  tmp=$(mktemp)
  # shellcheck disable=SC2068
  rg -o "${pref}-REQ-[0-9]+" ${files[@]} 2>/dev/null | sed "s/.*${pref}-REQ-//" | sort -n | uniq >"$tmp" || true
  local count gaps=0
  count=$(wc -l <"$tmp" | tr -d ' ')
  local prev=0
  while read -r num; do
    [[ -z "$num" ]] && continue
    n=$((10#$num))
    if (( prev > 0 && n != prev + 1 )); then
      echo "GAP in ${pref}-REQ: $prev -> $n"
      gaps=1
    fi
    prev=$n
  done <"$tmp"
  echo "${pref}-REQ unique=$count last=$prev gaps=$gaps"
  if (( gaps )); then ERR=1; fi
  rm -f "$tmp"
}

check_prefix MEM specification/AESP-0004.md specification/AESP-0004-continued.md specification/AESP-0004-reference.md
check_prefix WF specification/AESP-0005.md specification/AESP-0005-continued.md specification/AESP-0005-reference.md
check_prefix KG specification/AESP-0006.md specification/AESP-0006-continued.md specification/AESP-0006-reference.md
check_prefix CG specification/AESP-0007.md specification/AESP-0007-continued.md specification/AESP-0007-reference.md
check_prefix DOC specification/AESP-0008.md specification/AESP-0008-continued.md specification/AESP-0008-reference.md
check_prefix DEP specification/AESP-0009.md specification/AESP-0009-continued.md specification/AESP-0009-reference.md
check_prefix TEST specification/AESP-0010.md specification/AESP-0010-continued.md specification/AESP-0010-reference.md
check_prefix OBS specification/AESP-0011.md specification/AESP-0011-continued.md specification/AESP-0011-reference.md
check_prefix REM specification/AESP-0012.md specification/AESP-0012-continued.md specification/AESP-0012-reference.md
check_prefix SEC specification/AESP-0013.md specification/AESP-0013-continued.md specification/AESP-0013-reference.md
check_prefix HITL specification/AESP-0014.md specification/AESP-0014-continued.md specification/AESP-0014-reference.md
check_prefix INT specification/AESP-0015.md specification/AESP-0015-continued.md specification/AESP-0015-reference.md

for f in schemas/*.json; do
  python3 -c "import json; json.load(open('$f'))" || { echo "INVALID JSON $f"; ERR=1; }
done
echo "JSON schemas: OK"

for f in specification/ARCHITECTURE.md specification/CONFORMANCE.md specification/GAP-ANALYSIS.md specification/INTEROP-MATRIX.md specification/AGENT-RUNTIME.md; do
  [[ -f "$f" ]] || { echo "MISSING $f"; ERR=1; }
done

if (( ERR )); then
  echo "RESULT: FAIL"
  exit 1
fi
echo "RESULT: PASS"
exit 0
