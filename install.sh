#!/bin/bash

set -e

echo "🎵 Installing Claude Sounds Config..."

# Create sounds directory
mkdir -p ~/.claude/sounds

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy sound files
echo "📁 Copying sound files..."
cp "$SCRIPT_DIR"/*.wav ~/.claude/sounds/

# Merge hooks into settings.json
echo "⚙️  Merging hook configuration..."

SETTINGS_FILE=~/.claude/settings.json
HOOKS_FILE="$SCRIPT_DIR/hooks.json"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
  echo "{}" > "$SETTINGS_FILE"
fi

# Merge hooks using Python (more reliable than jq)
python3 << 'PYTHON_SCRIPT'
import json
import sys
import os

settings_file = os.path.expanduser("~/.claude/settings.json")
hooks_file = sys.argv[1]

# Read existing settings
with open(settings_file, 'r') as f:
  settings = json.load(f)

# Read new hooks
with open(hooks_file, 'r') as f:
  new_config = json.load(f)

# Merge hooks
if "hooks" not in settings:
  settings["hooks"] = {}

settings["hooks"].update(new_config["hooks"])

# Write back
with open(settings_file, 'w') as f:
  json.dump(settings, f, indent=2)

print("✅ Hooks merged successfully")
PYTHON_SCRIPT

echo ""
echo "✨ Installation complete!"
echo "🔊 Restart Claude Code to hear your new sounds."
