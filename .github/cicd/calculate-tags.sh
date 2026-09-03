IMAGE_DIR="${MATRIX_IMAGE}"
DOCKERFILE="${IMAGE_DIR}/Dockerfile"
SETTINGS_ENV="${IMAGE_DIR}/settings.env"
if [ -f $SETTINGS_ENV ]; then
    source $SETTINGS_ENV
fi

if [ -z "$IMAGE_NAME" ]; then
    IMAGE_NAME=$MATRIX_IMAGE
fi

if [ -n "$IMAGE_VERSION" ]; then
    UPSTREAM_VER=$IMAGE_VERSION
else
    UPSTREAM_VER=$(grep -w -E "(FROM )|(COPY --from=)[a-zA-Z0-9/.]*$IMAGE_DIR:\S*" $IMAGE_DIR/Dockerfile | head -n 1 | sed -E 's/.*:([a-zA-Z0-9\._-]+)(@.+)?/\1/g')
fi

[[ "$UPSTREAM_VER" =~ ^v ]] || UPSTREAM_VER="v${UPSTREAM_VER}"

if [ -n "$IMAGE_VARIANT" ]; then
    UPSTREAM_VER="${UPSTREAM_VER}-$IMAGE_VARIANT"
fi

# Look up highest revision for this specific image prefix
GIT_PREFIX="${IMAGE_NAME}/${UPSTREAM_VER}"
LATEST_TAG=$(git tag -l "${GIT_PREFIX}-r*" | sort -V | tail -n 1)

if [ -z "$LATEST_TAG" ]; then
    NEW_REV="1"
else
    CURRENT_REV=$(echo "$LATEST_TAG" | sed -E 's/.*-r([0-9]+)$/\1/')
    DIFF=$(git diff -U0 HEAD HEAD~1)
    ADDED=$(echo "$DIFF" | grep -E '^\+' | grep -v -E '^\+\+\+' | grep -v -E '^\-\-\-' | sed -E 's/@sha256:[a-f0-9]{64}//' | sed -E 's/^\+//')
    REMOVED=$(echo "$DIFF" | grep -E '^\-' | grep -v -E '^\+\+\+' | grep -v -E '^\-\-\-' | sed -E 's/@sha256:[a-f0-9]{64}//' | sed -E 's/^\-//')
    if [ "$ADDED" = "$REMOVED" ]; then
        echo "not updating revision since only image digests have changed."
        NEW_REV=$CURRENT_REV
    else
        echo "updating revision"
        NEW_REV=$((CURRENT_REV + 1))
    fi
fi

echo "GIT_TAG=${GIT_PREFIX}-r${NEW_REV}" > $GITHUB_ENV
echo "IMAGE_TAG=${UPSTREAM_VER}-r${NEW_REV}" >> $GITHUB_ENV
echo "VERSION_ALIAS=${UPSTREAM_VER}" >> $GITHUB_ENV

ARGS=$(cat $SETTINGS_ENV | grep -v "^\w*#")
echo "build_args<<EOF" >> $GITHUB_OUTPUT
echo "$ARGS" >> $GITHUB_OUTPUT
echo "EOF" >> $GITHUB_OUTPUT