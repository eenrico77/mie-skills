#!/usr/bin/env bash
# Installa tutte le skill di questo repo in Claude Code.
#
# Uso:
#   ./setup.sh            # scope UTENTE: ~/.claude/skills (tutte le sessioni del container)
#   ./setup.sh .          # scope PROGETTO: ./.claude/skills (solo questo progetto)
#   ./setup.sh /path/dir  # link dentro <dir>/.claude/skills
#
# Le skill vengono collegate (symlink) a questo repo: è l'unica fonte di verità.
# Modifichi qui, e tutte le sessioni vedono subito la modifica.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TARGET="${1:-$HOME}"
if [ "$TARGET" = "." ]; then TARGET="$(pwd)"; fi
DEST="$TARGET/.claude/skills"

mkdir -p "$DEST"

for d in "$REPO_DIR"/skills/*/; do
  name="$(basename "${d%/}")"
  rm -rf "${DEST:?}/$name"
  ln -s "${d%/}" "$DEST/$name"
  echo "  linked  $DEST/$name  ->  ${d%/}"
done

echo
echo "Fatto. Collegate $(ls -1 "$REPO_DIR"/skills | wc -l | tr -d ' ') skill in $DEST"
echo "Avvia una NUOVA sessione Claude Code per caricarle."
