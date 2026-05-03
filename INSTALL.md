# Install guide — GWYF Unlimited Players

This mod raises the **Steam lobby member limit** and **Mirror connection cap** in *Gamble With Your Friends* so the **host** can have more than the default lobby size (configurable **2–16** players, default **12**).

## Who needs what

| Role | Install this mod? |
|------|-------------------|
| **Host** (creates the lobby) | **Yes** — required for the higher cap. |
| **Clients** (join only) | **No** for the cap to apply; optional if you want identical tooling. |

## Prerequisites

1. **Steam** copy of *Gamble With Your Friends* (Unity **Mono** build).
2. **[BepInEx 5.4](https://github.com/BepInEx/BepInEx/releases)** for **Windows x64** (e.g. `BepInEx_win_x64_5.4.23.x.zip`) **unless** you use the **full `dist/`** drop from this repo’s Release build (see below): that folder can include the same upstream files (**LGPL-2.1**).
3. This mod’s **`GwyfUnlimitedPlayers.dll`** (from `build\` after compile, or from **`dist\BepInEx\plugins\`** after a Release build — see repo `README.md`).

## Option A — Full `dist/` bundle (Doorstop + BepInEx + mod)

If your **`dist/`** folder contains **`winhttp.dll`** and **`doorstop_config.ini`** next to the docs (from **`scripts/Pack-Dist.ps1`** or **`scripts/Sync-BepInExRuntimePack.ps1`** + Release build), treat **`dist/`** as a **complete** overlay:

1. Copy **everything** inside **`dist/`** into the game directory (same folder as **`Gamble With Your Friends.exe`**), merge / overwrite.
2. Launch the game once, then continue with **Step 3** (config) if you want to change **`MaxPlayers`**.

You can skip **Step 1** and **Step 2** below when using this layout.

## Step 1 — Install BepInEx (once per game folder)

**Where BepInEx comes from:** always the **official BepInEx 5** build (same bytes as [GitHub releases](https://github.com/BepInEx/BepInEx/releases)). The maintainer build can **copy those files into `dist/`** for convenience; redistributing that drop still means you are shipping upstream BepInEx under its **LGPL-2.1** license.

1. Open **[BepInEx releases on GitHub](https://github.com/BepInEx/BepInEx/releases)** and download the latest **v5.4.x** zip for **64‑bit Windows / Unity Mono**, asset name like **`BepInEx_win_x64_5.4.23.x.zip`**. (Do not use random mirrors; if you use a mod manager later, it should still install this same upstream package.)
2. In Steam: **Library** → right‑click *Gamble With Your Friends* → **Manage** → **Browse local files** (this is the folder that contains the game `.exe`).
3. Extract **everything** from that zip **into that same folder** (merge / overwrite when prompted). You should end up with:
   - **`winhttp.dll`** (Doorstop) **next to** the game `.exe`
   - **`BepInEx\`** with **`core\`**, **`plugins\`**, **`config\`**, etc.
4. Launch the game **once**, then quit. This creates `BepInEx\config\` and confirms BepInEx loads (`BepInEx\LogOutput.log` should grow and mention BepInEx).
5. If nothing happens, use the official guide: **[BepInEx — installation](https://docs.bepinex.dev/articles/user_guide/installation/index.html)** (Unity / Mono / Windows paths and troubleshooting).

## Step 2 — Install the mod DLL

Skip if you already merged **Option A** (the DLL is under **`dist\BepInEx\plugins\`**).

1. Copy **`GwyfUnlimitedPlayers.dll`** into:

   `Gamble With Your Friends\BepInEx\plugins\` (full path: same folder as the game `.exe`, then `BepInEx\plugins\`)

   Do **not** put it under `BepInEx/core/` (that is for BepInEx itself).

2. Optional: keep each mod in its own subfolder (BepInEx loads DLLs from subfolders too):

   `BepInEx\plugins\GwyfUnlimitedPlayers\GwyfUnlimitedPlayers.dll`

## Step 3 — Configure (optional)

1. Start the game again (host). A config file is created on first run:

   `BepInEx\config\agreenbeen.gwyf.unlimited_players.cfg`

2. Edit **`[General]`** → **`MaxPlayers`** (default `12`, allowed **2–16**). Set **`VerboseLogging = true`** if you want extra lines in the log.

3. Restart the game after changing settings so the next lobby uses the new values.

## Step 4 — Verify it loaded and is doing work

All of this goes through **BepInEx** into the same log file (next to your game folder):

`BepInEx\LogOutput.log`

### A) Plugin initialized (every game start)

Search the log for:

`GWYF Unlimited Players 1.0.0 loaded. MaxPlayers=`

The number at the end is the effective cap (default **12**, clamped **2–16**). If this line is **missing**, the DLL is not loading (wrong folder, wrong game, crash before plugins, etc.). Earlier in the same file, BepInEx usually lists loaded plugins; you should see **`GWYF Unlimited Players`** / GUID **`agreenbeen.gwyf.unlimited_players`** in that list.

### B) Patches ran when you host (lobby / networking)

These lines only appear when the game actually hits Steam / Mirror code paths (e.g. **host** creating or running a lobby / server):

| What to search for | Meaning |
|--------------------|--------|
| `SteamMatchmaking.CreateLobby: cMaxMembers` | Steam lobby size was raised from the game’s requested value to your configured cap. |
| `SteamMatchmaking.SetLobbyMemberLimit: cMaxMembers` | The game tried to set a lobby member limit; the mod aligned it to your cap. |
| `NetworkManager.` and `maxConnections` and `->` | Mirror’s connection cap was set to your configured value (may log on **Awake**, **StartHost**, or **StartServer** depending on flow). |

If **`before` and `want` are the same**, the mod may skip the info line; turn on **`VerboseLogging`** in `BepInEx\config\agreenbeen.gwyf.unlimited_players.cfg` (`[General]` → `VerboseLogging = true`) and restart; you should then see **`[Verbose]`** lines when values were already at the cap.

### C) Something went wrong

- **`SteamCreateLobbyPatch failed:`** or **`SteamSetLobbyMemberLimitPatch failed:`** — Steam API or Harmony mismatch after a game update; grab that stack trace from the log.
- **Harmony / patch errors** right after the plugin line — note the exception type and message; a game update may have renamed methods the patches target.

## BepInEx not creating `LogOutput.log` (or “no logs” in the game folder)

BepInEx’s main log is **not** in the game folder root by itself. It should appear here after a successful launch:

`…\Gamble With Your Friends\BepInEx\LogOutput.log` (same folder tree as the game `.exe`)

(The `…` prefix is your Steam library path; use **Browse local files** from Steam if unsure.)

### Checklist

1. **`BepInEx` folder exists** next to the game `.exe` (same folder as `Gamble With Your Friends.exe`). If there is no `BepInEx` directory at all, the BepInEx zip was extracted to the wrong place or never installed.

2. **Doorstop files in the game root** (next to the `.exe`), from the **same** BepInEx zip you used:
   - **`winhttp.dll`**
   - **`doorstop_config.ini`**
   - (Do not mix `winhttp.dll` from an old BepInEx with a newer `BepInEx` folder, or the reverse.)

3. **Correct BepInEx build** for this game: **Unity Mono, Windows x64** (`BepInEx_win_x64_5.4.x.zip`). An IL2CPP or wrong-arch zip will not wire up correctly.

4. **Doorstop debug log in the game root** — some installs leave a file named like **`doorstop_*.log`** next to the `.exe`. If you see **“Could not find target assembly”** or Doorstop disabled, `doorstop_config.ini` / missing `BepInEx\core\BepInEx.Preloader.dll` is usually the cause; reinstall BepInEx and overwrite all files.

5. **Unity’s own log** (errors even before BepInEx runs):

   `%USERPROFILE%\AppData\LocalLow\TENSTACK\Gamble With Your Friends\Player.log`

   (`TENSTACK` is the publisher name shipped with this title.)

6. **Steam “Verify integrity”** can remove or replace **`winhttp.dll`**. If logs stopped after a verify, reinstall BepInEx into the game folder again.

7. **Antivirus / Controlled Folder Access** sometimes blocks **`winhttp.dll`** or writing under `BepInEx\`. Temporarily allow the game folder or check Windows Security history.

## Uninstall

1. Delete **`BepInEx\plugins\GwyfUnlimitedPlayers.dll`** (or the whole `plugins\GwyfUnlimitedPlayers` folder if you used one).
2. Optionally delete **`BepInEx\config\agreenbeen.gwyf.unlimited_players.cfg`**.

Removing the entire `BepInEx` folder uninstalls all BepInEx mods for this game.

## Troubleshooting

| Symptom | Things to check |
|---------|------------------|
| No `BepInEx` folder after launch | BepInEx not extracted to the **same** folder as the game exe; wrong zip (use **x64** Mono build). |
| No **`BepInEx\LogOutput.log`** | Log lives under **`BepInEx\`**, not loose in the game root. Example shape: `…\Gamble With Your Friends\BepInEx\LogOutput.log`. See **“BepInEx not creating LogOutput.log”** above. |
| Mod not in log | DLL not under `BepInEx\plugins\`; typo in filename; game crashed before Chainloader (read full log). |
| Still capped at 6 players | Confirm the **host** has the mod; check log for CreateLobby / maxConnections lines; game update may need new patches (see **`TARGETS.md`** next to this guide in `dist/`, or repo `docs/TARGETS.md`). |
| Build from source | See [`README.md`](README.md). **`GameManaged`** must be the real `...\Gamble With Your Friends_Data\Managed` path (not `…\`). After a successful Release build, use **`dist/`** for a test drop. |

## Disclaimer

Do not report mod-related bugs to the game’s developers without reproducing on a **vanilla** install. Mods can break after game updates.
