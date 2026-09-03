#!/bin/bash

TAGS=$(git tag -l)
PREFIXES=$(echo "$TAGS" | sed -E 's/-r[0-9]+$//' | uniq)
IMAGES=()

for i in $PREFIXES; do
    LATEST="$(echo "$TAGS" | grep "$i" | sort -V | tail -n 1)"
    IMAGES+=("$LATEST")
done

if [ ${#IMAGES[@]} -eq 0 ]; then
    JSON_ARRAY="[]"
else
    JSON_ARRAY=$(printf '"%s"\n' "${IMAGES[@]}" | sort -u | uniq | jq -s -c .)
fi

echo $JSON_ARRAY