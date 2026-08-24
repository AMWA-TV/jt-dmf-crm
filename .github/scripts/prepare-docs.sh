#!/usr/bin/env bash
#
# Prepare the docs/ tree for the published site build.
#
# The docs/ Markdown sources use repo-relative links (e.g. `../lib/tests/foo.cpp`,
# `../.devcontainer/Dockerfile`) so they resolve correctly when browsing the
# source on GitHub. Those links don't exist in the published documentation
# tree, so for the site build we rewrite them in-place to absolute GitHub URLs.
#
# This script:
#   1. Generates docs/index.md from README.md (the single source of truth for
#      the landing page), rewriting README's docs/-prefixed and repo-root
#      links so they resolve from inside docs/.
#   2. Rewrites any link in docs/*.md that escapes the docs/ tree (i.e. starts
#      with `../`) to an absolute github.com/.../<ref>/... URLR
#   3. Removes lines relevant to Jekyll ToC processing
#
# Intended to run in CI on a fresh checkout; the in-place edits to docs/*.md
# are not meant to be committed.

set -euo pipefail

REPO_SLUG="${GITHUB_REPOSITORY:-AMWA-TV/in-template}"
# Use BUILD_REF if the workflow set one (covers dispatch with an input ref),
# else the ref the run was triggered on, else fall back to main.
REF="${BUILD_REF:-${GITHUB_REF_NAME:-main}}"
REPO_URL="https://github.com/${REPO_SLUG}/blob/${REF}"

if [[ ! -f README.md ]]; then
    echo "error: README.md not found (run from repo root)" >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# 1. Landing page: README.md -> docs/index.md
# ---------------------------------------------------------------------------
sed -E \
    -e "s#\]\(docs/([^)]+)\)#](\1)#g" \
    -e "s#\]\(\./?LICENSE\.txt\)#](${REPO_URL}/LICENSE.txt)#g" \
    -e "s#\]\(LICENSE\.txt\)#](${REPO_URL}/LICENSE.txt)#g" \
    -e "s#\]\(CONTRIBUTING\.md\)#](${REPO_URL}/CONTRIBUTING.md)#g" \
    -e "s#\]\(SECURITY\.md\)#](${REPO_URL}/SECURITY.md)#g" \
    -e "s#\]\(examples/([^)]+)\)#](${REPO_URL}/examples/\1)#g" \
    -e "s#https://github.com/${REPO_SLUG}/blob/[0-9a-f]+/docs/([^)\" ]+)#\1#g" \
    README.md > docs/index.md

echo "Generated docs/index.md from README.md"

# ---------------------------------------------------------------------------
# 2. Rewrite docs/*.md links that escape the docs/ tree to absolute GitHub URLs
#
# Matches Markdown link targets of the form `](../<path>)`. The captured path
# may contain further `../` segments (collapsed by the URL itself).
#
# 3. Remove lines relevant to Jekyll ToC processing
# ---------------------------------------------------------------------------
shopt -s nullglob
for f in docs/*.md; do
    [[ "${f}" == "docs/index.md" ]] && continue
    sed -i -E \
        -e "s#\]\(\.\./([^)]+)\)#](${REPO_URL}/\1)#g" \
        -e "/^\{:\.no_toc\}/,/^[[:space:]]*\{:toc\}/d" \
        "${f}"
done

echo "Rewrote ../ links in docs/*.md to ${REPO_URL}/... and removed any Jekyll ToC processing lines"
