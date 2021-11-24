#!/bin/bash
PATH="..:$PATH"

function die() { local error="$*"; echo "${BASH_SOURCE[0]}:${BASH_LINENO[0]}: ${error:-Test failed}"; exit 1; }
trap die ERR

DATA="${BASH_SOURCE[0]%%.sh}.json"
function assert() {
  if [[ "$1" != "$2" ]]; then
    echo "${BASH_SOURCE[0]}:${BASH_LINENO[0]}: ${3:-Test failed, '$1' is not the same as '$2'}";
    echo "Try:"
    echo "  assert \"\$a\" \"$1\"" | sed 's,'"$DATA"',${DATA},'
    exit 1;
  fi
}

a=$(jqgrep John "$DATA" 2>&1)       || die "The value 'John' was not found in $DATA"
assert "$a" "${DATA}: .name # John" 

a=$(jqgrep Johnny "$DATA" 2>&1)     && die "The value 'Johnny' *was* found in $DATA"
assert "$a" "" 

a=$(jqgrep car "$DATA" 2>&1)        || die "The string 'car' was not found in $DATA"
assert "$a" "${DATA}: .car # null"

a=$(jqgrep "[aeiou]" "$DATA" 2>&1)  || die "The regex [aeiou] was not found in $DATA"
assert "$a" "${DATA}: .name # John
${DATA}: .age # 30
${DATA}: .car # null"

a=$(jqgrep -v "[aeiou]" "$DATA" 2>&1)  || die "The regex [aeiou] was not found in the values of $DATA"
assert "$a" "${DATA}: .name # John"

a=$(jqgrep -k "[e]" "$DATA" 2>&1)  || die "The regex [e] was not found in the keys of $DATA"
assert "$a" "${DATA}: .name # John
${DATA}: .age # 30"

a=$(jqgrep -ck "[e]" "$DATA" 2>&1)  || die "The regex [e] was not found in the keys of $DATA"
assert "$a" "jq '.name' ${DATA} # John
jq '.age' ${DATA} # 30"

a=$(jqgrep -icv "j" "$DATA" 2>&1)  || die "The letter j was not found (case-insensitively) in the values of $DATA"
assert "$a" "jq '.name' ${DATA} # John"

echo "${BASH_SOURCE[0]} ok"
