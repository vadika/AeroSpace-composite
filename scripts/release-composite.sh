#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_FILE="${CONFIG_FILE:-$ROOT_DIR/composite.env}"
WORK_DIR="${WORK_DIR:-$ROOT_DIR/.state/work}"

if ! test -f "$CONFIG_FILE"; then
    echo "Missing config file: $CONFIG_FILE" >&2
    echo "Copy composite.env.example to composite.env first." >&2
    exit 1
fi

source "$CONFIG_FILE"

: "${UPSTREAM_REPO:?UPSTREAM_REPO is required}"
: "${UPSTREAM_BRANCH:?UPSTREAM_BRANCH is required}"
: "${RELEASE_PREFIX:?RELEASE_PREFIX is required}"
: "${CASK_NAME:?CASK_NAME is required}"
: "${GITHUB_REPOSITORY:?GITHUB_REPOSITORY is required}"

# Empty bash arrays and `set -u` are not portable enough across environments.
set +u

mkdir -p "$WORK_DIR"
rm -rf "$WORK_DIR/source" "$WORK_DIR/out"

git clone --filter=blob:none --branch "$UPSTREAM_BRANCH" "$UPSTREAM_REPO" "$WORK_DIR/source"

cd "$WORK_DIR/source"

git config user.name "AeroSpace Composite Bot"
git config user.email "actions@users.noreply.github.com"

main_sha="$(git rev-parse HEAD)"
main_short="$(git rev-parse --short=12 HEAD)"

declare -a selected_prs=()
if declare -p SELECTED_PRS >/dev/null 2>&1; then
    selected_prs=("${SELECTED_PRS[@]}")
fi
declare -a pr_states=()
declare -a pr_notes=()

for pr in "${selected_prs[@]}"; do
    git fetch origin "pull/$pr/head:refs/remotes/origin/pr/$pr"
    pr_sha="$(git rev-parse "refs/remotes/origin/pr/$pr")"
    pr_short="$(git rev-parse --short=12 "$pr_sha")"
    pr_states+=("pr${pr}-${pr_short}")
    pr_notes+=("PR #$pr @ $pr_sha")

    if ! git merge --no-edit --no-ff "refs/remotes/origin/pr/$pr"; then
        echo "Failed to merge PR #$pr into composite build state." >&2
        echo "The PR may no longer apply cleanly on top of the current composite state." >&2
        exit 1
    fi
done

state_parts=("main-${main_short}")
if test "${#pr_states[@]}" -gt 0; then
    state_parts+=("${pr_states[@]}")
fi

state_id="$(printf '%s\n' "${state_parts[@]}" | shasum -a 256 | awk '{print substr($1, 1, 12)}')"
build_version="0.0.0-SNAPSHOT-${state_id}"
release_tag="${RELEASE_PREFIX}-${state_id}"

if gh release view "$release_tag" --repo "$GITHUB_REPOSITORY" >/dev/null 2>&1; then
    echo "Release $release_tag already exists for this composite state."
    exit 0
fi

./build-release.sh --build-version "$build_version" --codesign-identity -

mkdir -p "$WORK_DIR/out"

zip_name="AeroSpace-v${build_version}.zip"
zip_path="$WORK_DIR/source/.release/$zip_name"
asset_url="https://github.com/${GITHUB_REPOSITORY}/releases/download/${release_tag}/${zip_name}"

"$ROOT_DIR/scripts/build-cask.sh" \
    --zip-path "$zip_path" \
    --asset-url "$asset_url" \
    --cask-name "$CASK_NAME" \
    --build-version "$build_version" \
    > "$WORK_DIR/out/${CASK_NAME}.rb"

selected_prs_json=''
if test "${#selected_prs[@]}" -gt 0; then
    selected_prs_json="$(printf '"%s"\n' "${selected_prs[@]}" | paste -sd, -)"
fi

cat > "$WORK_DIR/out/metadata.json" <<EOF
{
  "upstream_repo": "$UPSTREAM_REPO",
  "upstream_branch": "$UPSTREAM_BRANCH",
  "upstream_main_sha": "$main_sha",
  "composite_sha": "$(git rev-parse HEAD)",
  "release_tag": "$release_tag",
  "build_version": "$build_version",
  "selected_prs": [$selected_prs_json]
}
EOF

cat > "$WORK_DIR/out/release-notes.md" <<EOF
# AeroSpace composite build

- Upstream: \`$UPSTREAM_REPO\`
- Branch: \`$UPSTREAM_BRANCH\`
- Upstream main: \`$main_sha\`
- Composite commit: \`$(git rev-parse HEAD)\`
- Build version: \`$build_version\`

Included PR heads:
EOF

if test "${#pr_notes[@]}" -eq 0; then
    printf '%s\n' '- none' >> "$WORK_DIR/out/release-notes.md"
else
    for note in "${pr_notes[@]}"; do
        printf '%s\n' "- $note" >> "$WORK_DIR/out/release-notes.md"
    done
fi

gh release create "$release_tag" \
    "$zip_path" \
    "$WORK_DIR/out/${CASK_NAME}.rb" \
    "$WORK_DIR/out/metadata.json" \
    --repo "$GITHUB_REPOSITORY" \
    --title "AeroSpace composite ${state_id}" \
    --notes-file "$WORK_DIR/out/release-notes.md"

if test -n "${GITHUB_OUTPUT:-}"; then
    printf 'release_tag=%s\n' "$release_tag" >> "$GITHUB_OUTPUT"
    printf 'build_version=%s\n' "$build_version" >> "$GITHUB_OUTPUT"
fi
