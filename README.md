# Claude Sounds Config

Get real-time audio notifications for every Claude Code event — session start, permission requests, errors, and more.

## Features

🔊 **Complete Sound Coverage:**
- **Session Start** — Claude Code initialized
- **Stop** — Claude finished responding
- **Permission Request** — Waiting for tool approval
- **Elicitation** — MCP server needs input
- **Tool Failure** — Tool call failed/errored
- **Context Compacting** — Context window being compacted
- **Subagent Events** — Subagent starting/stopping

## Installation

```bash
bash <(curl -s https://raw.githubusercontent.com/UlisesTame/claude_hooks_sound_experiences/main/install.sh)
```

That's it! Restart Claude Code and you'll hear sounds for every event.

## What It Does

The installer:
1. Creates `~/.claude/sounds/` directory
2. Copies all `.wav` sound files
3. Merges hook configuration into `~/.claude/settings.json`

Your existing settings are preserved — only hooks are merged.

## Customization

Edit `~/.claude/settings.json` to:
- Change sound file paths
- Adjust volume with `-v` flag (0.0-1.0)
- Enable/disable specific hooks
- Add your own sounds

Example to change volume:
```json
"command": "afplay -v 0.3 ~/.claude/sounds/start_claude_sound.wav"
```

## Sound Files

| File | Event |
|------|-------|
| `start_claude_sound.wav` | Session initialized |
| `claude_finished_task_01.wav` | Claude finished responding (variant 1) |
| `claude_finished_task_02.wav` | Claude finished responding (variant 2) |
| `claude_finished_task:03.wav` | Claude finished responding (variant 3) |
| `notification_user_input.wav` | Waiting for user input/approval |
| `tool_call_failed.wav` | Tool execution failed |
| `error.wav` | Error occurred |
| `compact_claude_session.wav` | Context being compacted |
| `sub-starts.wav` | Subagent spawned |
| `sub-ready.wav` | Subagent finished |
| `session_end.wav` | Session ended |

## Troubleshooting

**No sound in terminal?**
- Sounds play through system audio, not terminal output
- Check system volume settings
- Test: `afplay ~/.claude/sounds/start_claude_sound.wav`

**Sounds not playing?**
- Verify files exist: `ls ~/.claude/sounds/`
- Check settings.json syntax: `cat ~/.claude/settings.json | python -m json.tool`
- Restart Claude Code

## License

MIT
