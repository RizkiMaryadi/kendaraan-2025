#!/bin/bash
set -euo pipefail

ZSHRC_FILE="/root/.zshrc"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

touch "$ZSHRC_FILE"

echo "🔗 Updating functions and aliases in $ZSHRC_FILE..."

# === Remove previously added block ===
sed -i '/# === START ===/,/# === END ===/d' "$ZSHRC_FILE"

# === Append updated block ===
cat <<EOF >> "$ZSHRC_FILE"
# === START ===

start() {
  if [ -z "\$1" ]; then
    echo "❌ Usage: start <project-name>"
    return 1
  fi
  bash "$SCRIPT_DIR/start.sh" "\$1"
}

dcr() {
  local NAME="\$1"
  if [ -z "\$NAME" ]; then
    echo "❌ Usage: dcr <ModelName>"
    return 1
  fi
  local CONTAINER=\$(docker ps --format "{{.Names}}" | grep -Ei 'php|app' | head -n 1)
  if [ -z "\$CONTAINER" ]; then
    echo "❌ No PHP container found."
    return 1
  fi
  local NAME_SNAKE=\$(echo "\$NAME" | sed -E 's/([a-z])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]')
  local NAME_PLURAL="\${NAME_SNAKE}s"
  echo "🗑 Removing \$NAME files in container: \$CONTAINER"
  docker exec "\$CONTAINER" bash -c "rm -f app/Models/\$NAME.php"
  docker exec "\$CONTAINER" bash -c "rm -f app/Http/Controllers/\${NAME}Controller.php"
  docker exec "\$CONTAINER" bash -c "rm -f database/seeders/\${NAME}Seeder.php"
  docker exec "\$CONTAINER" bash -c "find database/migrations -type f -name '*create_\${NAME_PLURAL}_table*.php' -delete"
  echo "✅ Done removing: \$NAME"
}

dcm() {
  if [ -z "\$1" ]; then
    echo "❌ Usage: dcm <ModelName>"
    return 1
  fi
  docker exec -it \$(docker ps --filter "name=_php" --format "{{.Names}}" | head -n 1) art make:model "\$1" -msc
}

dcv() {
  if [ -z "\$1" ]; then
    echo "❌ Usage: dcv <ModelName>"
    return 1
  fi
  docker exec -it \$(docker ps --filter "name=_php" --format "{{.Names}}" | head -n 1) art make:filament-resource "\$1" --generate
}

dcp() {
  if [ \$# -eq 0 ]; then
    echo "❌ Usage: dcp your commit message"
    return 1
  fi
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "⚠️ Warning: You have uncommitted changes."
  fi
  git add .
  git commit -m "\$*"
  git push -u origin main
  echo "✅ Changes pushed to origin/main."
}

dcd() {
  PROJECT=\$(docker ps --format "{{.Names}}" | grep _php | cut -d"_" -f1)
  if [ -n "\$PROJECT" ]; then
    echo "🔻 Stopping containers for \$PROJECT..."
    docker compose -p "\$PROJECT" down
  else
    echo "❌ Could not detect project name."
  fi
}

alias dcu='docker compose up -d'
alias dci='docker exec -it \$(docker ps --filter "name=_php" --format "{{.Names}}" | head -n 1) art project:init'

# === END ===
EOF

# === Reload Zsh Config ===
if [ -n "${ZSH_VERSION:-}" ]; then
  echo "🔄 Sourcing $ZSHRC_FILE in Zsh shell..."
  source "$ZSHRC_FILE"
else
  if command -v zsh >/dev/null 2>&1; then
    echo "🔁 Not in Zsh. Starting Zsh to apply changes..."
    exec zsh
  else
    echo "⚠️ Zsh is not installed. Please install Zsh or restart your terminal manually."
  fi
fi
