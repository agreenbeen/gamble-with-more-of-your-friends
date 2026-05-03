# Changelog

## 1.0.0 (pre-release)

**Pre-release software** — expect rough edges; game updates can break patches. **Please report issues** on the repo with `BepInEx/LogOutput.log` snippets and steps to reproduce.

### What’s in the box

This drop bundles **Doorstop + BepInEx 5.4.x** next to the mod so you can **copy the whole archive contents into the game folder** (same place as `Gamble With Your Friends.exe`) without hunting separate BepInEx installs. Upstream BepInEx remains **LGPL-2.1**; see `INSTALL.md` in the bundle.

**Mod plugin:** `BepInEx/plugins/GwyfUnlimitedPlayers.dll` — host installs this tree; clients don’t need the mod for the host’s higher lobby cap.

### What it does

Raises **Steam lobby member limit** and **Mirror `NetworkManager.maxConnections`** on the host (default **12** players, configurable **2–16** via `BepInEx/config/agreenbeen.gwyf.unlimited_players.cfg` after first run).

---

*Steady as she goes — mind the rocks, and we’ll patch the hull if ye holler.*
