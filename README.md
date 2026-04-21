# KnockKnock

Sends an iMessage every time this Mac is unlocked. A self-contained Swift daemon with no third-party dependencies — just a binary and a launchd plist.

## Design decisions

| Topic | Decision |
|---|---|
| Build | Swift Package Manager — `swift build` only, no Xcode project |
| Unlock hook | `com.apple.screenIsUnlocked` via `DistributedNotificationCenter` |
| Send mechanism | `osascript` shell-out to Messages |
| Config | `~/.config/knockknock/config.json` — edit without recompiling |
| Binary | `~/bin/knockknock` |
| LaunchAgent | `~/Library/LaunchAgents/com.ettienne.knockknock.plist` |
| Logging | `~/Library/Logs/knockknock/knockknock.log` (stdout + stderr) |
| Code signing | Ad-hoc (`codesign --sign -`) — personal machine only |
| Debounce | 5-second cooldown; guards against duplicate unlock events |
| Concurrency | `@MainActor` throughout; notifications arrive on main thread |

## Config

Create `~/.config/knockknock/config.json` before running:

```json
{
  "recipient": "+YYXXXXXXXXX",
  "cooldownSeconds": 5
}
```

`cooldownSeconds` is optional (default: `5`). The message is generated at runtime and includes the machine name and unlock time.

## Usage

```bash
# First time
make install

# Verify it's running
make status

# Fire a test notification (no lock screen needed)
make test-fire

# Watch logs
make logs

# Reload after plist changes
make reload

# Full removal (leaves config and logs)
make uninstall
```

## Automation permission

On first send, macOS will prompt "knockknock wants to control Messages." Click Allow. The permission is stored in the TCC database and never asked again.
