# Third-party build references

## `BepInEx/BepInEx.dll`

- **Source:** [BepInEx v5.4.23.5](https://github.com/BepInEx/BepInEx/releases/tag/v5.4.23.5) (`BepInEx_win_x64_5.4.23.5.zip`, path `BepInEx/core/BepInEx.dll`).
- **License:** [LGPL-2.1](https://github.com/BepInEx/BepInEx/blob/master/LICENSE) (BepInEx project).
- **Purpose:** Compile-time reference only. At runtime the game loads its own BepInEx from the installation’s `BepInEx` folder.

To refresh this file, extract the zip (or run `scripts/FetchBepInExLibs.ps1` if present) and copy `BepInEx/core/BepInEx.dll` here.

For a **complete** BepInEx Doorstop + `BepInEx\core` tree used when building **`dist/`** (not just the compile ref), run **`scripts/Sync-BepInExRuntimePack.ps1`** (same upstream zip/version). **`scripts/Pack-Dist.ps1`** runs that automatically when `packaging\bepinex-runtime\` is missing.
