# Claude Code Config

My portable Claude Code setup — carry the same environment to any machine with one command.

Two components today:

- 🔊 **Sounds** — audio notifications for every Claude Code event
- 📊 **Status line** — a two-line bottom bar with model, cost, timing, rate limits, and context usage

## Installation

```bash
bash <(curl -s https://raw.githubusercontent.com/UlisesTame/claude_hooks_sound_experiences/main/install.sh)
```

Restart Claude Code and you're set.

Install just one component:

```bash
bash <(curl -s .../install.sh) --sounds-only
bash <(curl -s .../install.sh) --statusline-only
```

Your existing settings are preserved — the installer only merges in the keys it owns.

## Status Line

```
📁 my-project | 🌿 main | [Opus 5 (1M context)] | 💰 $0.2344 | ⏱️ 0m 21s | 🔑 my-sess
⚡ 5hr limit: 0% | 📅 weekly limit: 1% | ctx: ▓▓▓▓▓▓▓░░░░░░░░░░ 42%
```

**Line 1** — directory, git branch (omitted outside a repo), model, session cost, elapsed time, session name.

**Line 2** — rate limit usage (shown only when the data is available) and a context-window bar that shifts green → yellow (36%) → red (66%).

Requires [`jq`](https://jqlang.github.io/jq/) (`brew install jq`).

The script lives at `~/.claude/statusline.sh` — edit it freely to change the segments, bar width, or color thresholds. See the [status line docs](https://code.claude.com/docs/en/statusline).

## Sounds

| File | Event |
|------|-------|
| `start_claude_sound.wav` | Session initialized |
| `claude_finished_task_01.wav` | Claude finished responding (variant 1) |
| `claude_finished_task_02.wav` | Claude finished responding (variant 2) |
| `claude_finished_task_03.wav` | Claude finished responding (variant 3) |
| `notification_user_input.wav` | Waiting for user input/approval |
| `tool_call_failed.wav` | Tool execution failed |
| `error.wav` | Error occurred |
| `compact_claude_session.wav` | Context being compacted |
| `sub-starts.wav` | Subagent spawned |
| `sub-ready.wav` | Subagent finished |
| `session_end.wav` | Session ended |

Sound files are copied to `~/.claude/sounds/` and wired up as hooks. Edit `~/.claude/settings.json` to change paths, swap in your own sounds, adjust volume with the `-v` flag (0.0–1.0), or disable individual hooks:

```json
"command": "afplay -v 0.3 ~/.claude/sounds/start_claude_sound.wav"
```

See the [hooks docs](https://code.claude.com/docs/en/hooks) for the full event list.

## Troubleshooting

**No sound?**
- Sounds play through system audio, not terminal output — check system volume
- Verify files exist: `ls ~/.claude/sounds/`
- Test directly: `afplay ~/.claude/sounds/start_claude_sound.wav`

**Status line blank or broken?**
- Confirm `jq` is installed: `command -v jq`
- Test it directly: `echo '{}' | ~/.claude/statusline.sh`
- Make sure it's executable: `chmod +x ~/.claude/statusline.sh`

**Either not applying?**
- Check settings syntax: `python3 -m json.tool ~/.claude/settings.json`
- Restart Claude Code

## Platform

macOS. Sounds use `afplay`; swap in `paplay`/`aplay` (Linux) to port them. The status line is portable.

## License

MIT
