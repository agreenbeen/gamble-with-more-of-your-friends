# Changelog

## 1.0.0 (pre-release)

**Pre-release software** — expect rough edges; game updates can break patches. **Please report issues** on the repo with `BepInEx/LogOutput.log` snippets and steps to reproduce.

### Headline: host-only

**Only the lobby host installs this mod.** Friends who **only join** can use a **stock Steam install** — no BepInEx, no DLL, no config — and still play in a larger lobby **as long as the host** has merged this bundle. That keeps rollout simple: one person’s game folder, not the whole friend group.

### What’s in the box

This drop bundles **Doorstop + BepInEx 5.4.x** next to the mod so the host can **copy the whole archive into the game folder** (next to `Gamble With Your Friends.exe`) without a separate BepInEx hunt. Upstream BepInEx stays **LGPL-2.1**; see `INSTALL.md` in the bundle.

**Mod plugin (host machine):** `BepInEx/plugins/GwyfUnlimitedPlayers.dll`.

### What it does

On the **host**, raises **Steam lobby member limit** and **Mirror `NetworkManager.maxConnections`** (default **12** players, **2–16** in `BepInEx/config/agreenbeen.gwyf.unlimited_players.cfg` after first run).

---

*Steady as she goes — mind the rocks, and we’ll patch the hull if ye holler.*
