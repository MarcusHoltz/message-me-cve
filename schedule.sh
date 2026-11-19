#!/usr/bin/env bash
# Picks a random prime minute (primes in 0-59) and writes it into the cron
# line of .github/workflows/message-me-cve.yml. All runs share the minute so
# they stay exactly 2 h apart (NVD: poll no more than once every two hours).
# Commit the workflow afterwards.
set -euo pipefail
cd "$(dirname "$0")"
wf=.github/workflows/message-me-cve.yml
primes=(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59)
m=$(shuf -n 1 -e "${primes[@]}")
grep -qE "^    - cron: '[0-9]+ 5,7,9,11,13,15 \* \* \*'$" "$wf" ||
	{ echo "cron line not found in $wf" >&2; exit 1; }
sed -i -E "s/^(    - cron: ')[0-9]+( 5,7,9,11,13,15 \* \* \*')$/\1$m\2/" "$wf"
grep -n "cron:" "$wf"
