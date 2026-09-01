if [ -n "$TARGET" ]; then
    echo "target is set ($TARGET) - running non-git based build" >&2
    if [ "$TARGET" = "all" ]; then
        CHANGED_FILES=$(find . -name Dockerfile)
    else 
        CHANGED_FILES=$(find . -name Dockerfile | grep "$TARGET")
    fi
else
    CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | sed 's|^\./||g')
    echo "changed: $(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | sed 's|^\./||g')" >&2
fi

DIRS=()
for file in $CHANGED_FILES; do
    DIR=$(echo "$file" | cut -d'/' -f1)
    echo "$file" | cut -d'/' -f1 >&2
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