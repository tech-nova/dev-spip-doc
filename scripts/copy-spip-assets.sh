#!/usr/bin/env bash
# Copie les assets SPIP (CSS, JS, polices) une fois sous public/assets/.
# Les pages référencent /assets/... via overrides/main.html (mutualisation langues / versions).
# Les extra_css Zensical sont relatifs à docs_dir et seraient dupliqués par build — on évite.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PUBLIC_ROOT="${1:?usage: copy-spip-assets.sh <répertoire public, ex. public>}"
SRC="docs/assets"
DEST="$PUBLIC_ROOT/assets"
mkdir -p "$DEST/stylesheets" "$DEST/javascripts" "$DEST/webfonts/montserrat"
cp -f "$SRC/stylesheets/spip-theme.css" "$DEST/stylesheets/"
cp -f "$SRC/javascripts/spip-nav.js" "$DEST/javascripts/"
cp -R "$SRC/webfonts/montserrat/." "$DEST/webfonts/montserrat/"
