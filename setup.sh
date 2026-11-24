#!/usr/bin/env bash
# Installa le skill in Claude Code — modalità IBRIDA.
#
#   VENDORED (in ./skills/, collegate via symlink a questo repo):
#     - markitdown            (versione ripulita, senza upsell)
#     - campaign-launcher-oss
#   ESTERNE (fresche dagli autori ogni volta, via `npx skills`):
#     - grill-me, grilling    (mattpocock/skills)
#     - find-skills           (vercel-labs/skills)
#
# Uso:
#   ./setup.sh                   # scope UTENTE: ~/.claude/skills (consigliato)
#   ./setup.sh .                 # scope PROGETTO: ./.claude/skills
#   ./setup.sh /path/dir         # dentro <dir>/.claude/skills
#   SKIP_EXTERNAL=1 ./setup.sh   # solo le vendored (offline / senza rete)

set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TARGET="${1:-$HOME}"
if [ "$TARGET" = "." ]; then TARGET="$(pwd)"; fi
DEST="$TARGET/.claude/skills"
mkdir -p "$DEST"

# --- 1. Vendored: symlink al repo (fonte di verità unica) ---
for d in "$REPO_DIR"/skills/*/; do
  name="$(basename "${d%/}")"
  rm -rf "${DEST:?}/$name"
  ln -s "${d%/}" "$DEST/$name"
  echo "  vendored  $name"
done

# --- 2. Esterne: installate fresche dagli autori ---
if [ "${SKIP_EXTERNAL:-0}" = "1" ]; then
  echo "  (esterne saltate: SKIP_EXTERNAL=1)"
else
  if [ "$TARGET" = "$HOME" ]; then G="-g"; CWD="$HOME"; else G=""; CWD="$TARGET"; fi
  ( cd "$CWD" \
    && npx --yes skills add mattpocock/skills --skill=grill-me --skill=grilling $G -y \
    && npx --yes skills add vercel-labs/skills@find-skills $G -y )
  echo "  external  grill-me, grilling, find-skills (fresche dagli autori)"
fi

echo
echo "Fatto in $DEST. Avvia una NUOVA sessione Claude Code per caricare le skill."
