# GWYF Unlimited Players

A **BepInEx** mod for *Gamble With Your Friends* (Steam, **Unity Mono**) so the **host** can run lobbies with **more than the default player cap** (default **12**, configurable **2–16**). It raises the **Steam lobby limit** and **Mirror** `NetworkManager.maxConnections`. Friends who only **join** do **not** need the mod for the higher cap to apply.

**Repository:** [github.com/agreenbeen/gamble-with-more-of-your-friends](https://github.com/agreenbeen/gamble-with-more-of-your-friends)

---

## Install (players)

### 1. Get the files

Download from **[Releases](https://github.com/agreenbeen/gamble-with-more-of-your-friends/releases)** (or **[latest release](https://github.com/agreenbeen/gamble-with-more-of-your-friends/releases/latest)**). Pick the zip or archive you published: a **full** drop includes **BepInEx** plus the mod; a **plugin-only** drop is just the mod DLL.

If the release bundle was built as a full **`dist/`** layout, it should contain things like **`winhttp.dll`**, **`doorstop_config.ini`**, a **`BepInEx`** folder (with **`plugins`** and **`core`**), **`GwyfUnlimitedPlayers.dll`** under **`BepInEx\plugins\`**, and copies of **`INSTALL.md`** / **`QUICKSTART.txt`**. That is the easiest path: one folder to merge into the game.

### 2. Put them in the game folder

1. In **Steam**: *Gamble With Your Friends* → **Manage** → **Browse local files**.  
   You want the folder that contains **`Gamble With Your Friends.exe`**.
2. **Extract or copy** the contents of the release so they land **in that same folder** (merge / overwrite when prompted).  
   After a **full** bundle you should see **`winhttp.dll`** next to the `.exe` and a **`BepInEx`** folder.
3. **Launch the game once**, then quit. That checks that BepInEx starts (see logs under **`BepInEx\`**).

### 3. Optional — change the player cap

After first run, BepInEx creates a config folder. Edit:

`BepInEx\config\agreenbeen.gwyf.unlimited_players.cfg`

| Setting | Default | What it does |
|--------|---------|----------------|
| `MaxPlayers` | `12` | Lobby / server cap (**2–16**). |
| `VerboseLogging` | `false` | Extra lines in **`BepInEx\LogOutput.log`**. |

### 4. If something goes wrong

Use the copy of **[`INSTALL.md`](INSTALL.md)** bundled with the release (same folder as **`QUICKSTART.txt`**) for **troubleshooting**, log paths, uninstall, and **manual BepInEx** install if you did not use a full bundle.

---

## More detail (everyone)

- **Full install / BepInEx-only / logs:** [`INSTALL.md`](INSTALL.md)  
- **How to sanity-check multiplayer:** [`docs/VALIDATION.md`](docs/VALIDATION.md)  
- **What the mod patches (technical):** [`docs/TARGETS.md`](docs/TARGETS.md)  

**Disclaimer:** Mods can break after game updates. Do not report mod issues to the game’s developers unless you can reproduce the problem on a **vanilla** install.

---

## For developers (build from source)

You need the [.NET SDK](https://dotnet.microsoft.com/download) (6+ or **8+**) and a local install of the game so MSBuild can reference **`Gamble With Your Friends_Data\Managed`** (`Mirror.dll`, Unity assemblies, Steamworks.NET, etc.).

1. **Compile reference:** ensure [`lib/BepInEx/BepInEx.dll`](lib/BepInEx/BepInEx.dll) exists (see [`lib/README.md`](lib/README.md)). If missing, run [`scripts/FetchBepInExLibs.ps1`](scripts/FetchBepInExLibs.ps1).
2. **Point the project at the game’s Managed folder** (no path is committed). Either:
   - `$env:GWYF_MANAGED = (.\scripts\Find-GwyfManaged.ps1)` then [`build.ps1`](build.ps1), or  
   - `dotnet build .\GwyfUnlimitedPlayers.sln -c Release -p:GameManaged="FULL_PATH_TO_...\Gamble With Your Friends_Data\Managed"`, or  
   - Copy [`Directory.Build.props.example`](Directory.Build.props.example) to **`Directory.Build.props`** (gitignored) and set **`GameManaged`** there.

   Example path shape (only if your game is actually there):

   ```powershell
   dotnet build .\GwyfUnlimitedPlayers.sln -c Release -p:GameManaged="C:\Program Files (x86)\Steam\steamapps\common\Gamble With Your Friends\Gamble With Your Friends_Data\Managed"
   ```

3. **Output:** `build\GwyfUnlimitedPlayers.dll`.

### Full install drop for Releases (`dist/`)

To produce the same **overlay** you attach to **[GitHub Releases](https://github.com/agreenbeen/gamble-with-more-of-your-friends/releases)**, run [`scripts/Pack-Dist.ps1`](scripts/Pack-Dist.ps1) (with **`GWYF_MANAGED`** set as above). That refreshes **`dist/`** (gitignored): Doorstop + upstream **BepInEx 5.4.x** (when the runtime pack is present), the plugin under **`dist\BepInEx\plugins\`**, and docs **`INSTALL.md`**, **`VALIDATION.md`**, **`TARGETS.md`**, **`QUICKSTART.txt`**, **`thunderstore/manifest.json`**, etc. Zip **`dist/`** contents (or the whole tree) for upload.

| `dist/` area | Contents |
|--------------|----------|
| Root (`winhttp.dll`, `doorstop_config.ini`, …) | Upstream **BepInEx 5.4.23.5** (LGPL-2.1) when the runtime pack was synced |
| `BepInEx/plugins/GwyfUnlimitedPlayers.dll` | This mod |
| Docs next to the game layout | **`INSTALL.md`**, **`QUICKSTART.txt`**, **`VALIDATION.md`**, **`TARGETS.md`**, **`thunderstore/`** |

Without the runtime pack, **`scripts/Sync-BepInExRuntimePack.ps1`** (or Pack-Dist, which can call it) populates **`packaging/bepinex-runtime/`** from the official BepInEx zip before build.

---

## License

MIT — see [LICENSE](LICENSE). Release bundles that include **BepInEx** also ship upstream files under **LGPL-2.1**; see [`lib/README.md`](lib/README.md) and [`INSTALL.md`](INSTALL.md).
