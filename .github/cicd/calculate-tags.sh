IMAGE_DIR="${{ matrix.image }}"
DOCKERFILE="${IMAGE_DIR}/Dockerfile"

UPSTREAM_VER=$(grep -w -E "(FROM )|(COPY --from=)[a-zA-Z0-9/.]*$IMAGE_DIR:\S*" $IMAGE_DIR/Dockerfile | head -n 1 | sed -E 's/.*:([a-zA-Z0-9\._-]+)(@.+)?/\1/g')
[[ "$UPSTREAM_VER" =~ ^v ]] || UPSTREAM_VER="v${UPSTREAM_VER}"

# Look up highest revision for this specific image prefix
GIT_PREFIX="${IMAGE_DIR}/${UPSTREAM_VER}"
LATEST_TAG=$(git tag -l "${GIT_PREFIX}-r*" | sort -V | tail -n 1)

if [ -z "$LATEST_TAG" ]; then
    NEW_REV="1"
else
    CURRENT_REV=$(echo "$LATEST_TAG" | sed -E 's/.*-r([0-9]+)$/\1/')
    NEW_REV=$((CURRENT_REV + 1))
fi

echo "GIT_TAG=${GIT_PREFIX}-r${NEW_REV}" >> $GITHUB_ENV
echo "IMAGE_TAG=${UPSTREAM_VER}-r${NEW_REV}" >> $GITHUB_ENV
echo "VERSION_ALIAS=${UPSTREAM_VER}" >> $GITHUB_ENV
echo "MINOR_ALIAS=$(echo $UPSTREAM_VER | sed -E 's/(v?[0-9]+\.[0-9]+).*/\1/g')" >> $GITHUB_ENV