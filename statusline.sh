#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
DIR_NAME="${DIR##*/}"
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
RATE5=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
RATE7=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
SESSION=$(echo "$input" | jq -r '.session_name // .session_id' | cut -c1-8)

COST_FMT=$(printf '$%.4f' "$COST")
DURATION_SEC=$((DURATION_MS / 1000))
MINS=$((DURATION_SEC / 60))
SECS=$((DURATION_SEC % 60))

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

if [ "$PCT" -ge 66 ]; then
    BAR_COLOR=$RED
elif [ "$PCT" -ge 36 ]; then
    BAR_COLOR=$YELLOW
else
    BAR_COLOR=$GREEN
fi

BAR_WIDTH=17
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /▓}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"
BAR="${BAR_COLOR}${BAR}${RESET}"

# Line 1: dir, git branch, model, ctx, cost
if git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)
    echo "📁 $DIR_NAME | 🌿 $BRANCH | [$MODEL] | 💰 $COST_FMT | ⏱️ ${MINS}m ${SECS}s | 🔑 $SESSION"
else
    echo "📁 $DIR_NAME | [$MODEL] | 💰 $COST_FMT | ⏱️ ${MINS}m ${SECS}s | 🔑 $SESSION"
fi
# Line 2: rate limits, ctx
PARTS=()
[ -n "$RATE5" ] && PARTS+=("⚡ 5hr limit: ${RATE5%.*}%")
[ -n "$RATE7" ] && PARTS+=("📅 weekly limit: ${RATE7%.*}%")
PARTS+=("ctx: $BAR ${PCT}%")
LINE2=$(IFS='|'; echo "${PARTS[*]}" | sed 's/|/ | /g')
echo -e "$LINE2"
