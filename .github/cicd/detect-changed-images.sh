if [ -n "$TARGETS" ]; then
    if [ "$TARGETS" = "all" ]; then
        CHANGED_FILES=$(find . -name Dockerfile)
    else 
        CHANGED_FILES=$(find . -name Dockerfile | grep "$TARGETS")
    fi
else
    CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA)
fi

DIRS=()
for file in $CHANGED_FILES; do
    DIR=$(echo "$file" | cut -d'/' -f2)
    if [ -d "$DIR" ] && [ -f "$DIR/Dockerfile" ]; then
        DIRS+=("$DIR")
    fi
done

if [ ${#DIRS[@]} -eq 0 ]; then
    JSON_ARRAY="[]"
else
    JSON_ARRAY=$(printf '"%s"\n' "${DIRS[@]}" | sort -u | uniq | jq -s -c .)
fi

echo "$JSON_ARRAY"