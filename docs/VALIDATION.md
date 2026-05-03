# Validation matrix (manual)

**Host-only:** install BepInEx + this mod on the **host** machine only. **Clients** under test should be **vanilla** unless you are explicitly checking optional client installs.

Automated multiplayer tests were **not** executed in CI (no game clients / no .NET SDK in the agent sandbox). Run these locally after installing on the **host**.

## Prerequisites

- BepInEx 5.x for **Mono** Unity, on the **host’s** game folder.
- Host: `GwyfUnlimitedPlayers.dll` in `BepInEx/plugins/`.
- Config: `BepInEx/config/agreenbeen.gwyf.unlimited_players.cfg` — set `MaxPlayers` as needed (default **12**, allowed **2–16**).

## Quick solo smoke test (no extra players)

You can confirm the mod is active **without** filling a lobby.

1. **Install on the host only** — `GwyfUnlimitedPlayers.dll` under `BepInEx/plugins/`, BepInEx + Doorstop in the game folder.
2. **Launch the game** and open **`BepInEx/LogOutput.log`** (same folder as the `.exe`, then `BepInEx/`).
3. **Expect a load line** on startup, for example:  
   `GWYF Unlimited Players 1.0.0 loaded. MaxPlayers=…`
4. **Create a lobby** (host flow you normally use to play online). **Expect:**  
   `SteamMatchmaking.CreateLobby: cMaxMembers 6 -> …`  
   where the right-hand number matches your config (**default 12**, or whatever you set under **2–16**).
5. **Expect Mirror alignment** when hosting starts, for example:  
   `NetworkManager.…: maxConnections … -> …`  
   If you do not see that line, set **`VerboseLogging = true`** in  
   `BepInEx/config/agreenbeen.gwyf.unlimited_players.cfg`, restart, host again — you should at least see verbose **`maxConnections already …`** lines when the value already matches.
6. **Config sanity check** — set **`MaxPlayers = 8`**, restart the game, host again; the **`CreateLobby`** log should show **`6 -> 8`** (game still asks for 6; your mod overrides to the configured cap).

Steps 3–4 are enough for a **smoke test**. The table below is for **real** capacity checks with multiple clients.

## Cases

| # | Scenario | Pass criteria |
|---|----------|----------------|
| 1 | Host + 7 vanilla clients join same lobby | All 8 present; no immediate kick |
| 2 | Host + 11 vanilla clients (12 total) | All connected; start a match if game allows |
| 3 | `MaxPlayers=16`, 16 clients | No Steam “lobby full” / Mirror max connection reject |
| 4 | Player leaves and rejoins | Slot freed; rejoin succeeds |
| 5 | Host restarts game with new `MaxPlayers` | New cap reflected on next lobby create |

## Log checks (host `BepInEx/LogOutput.log`)

- `SteamMatchmaking.CreateLobby: cMaxMembers X -> Y`
- `NetworkManager.*: maxConnections X -> Y`
- Optional: enable `VerboseLogging` for extra lines.

## If something fails

1. **Host-only check:** the **host** must have the mod; **vanilla clients** are the expected happy path (repro that before assuming joiners need installs).
2. Open `Assembly-CSharp` in dnSpy and search `CreateLobby`, `maxConnections`, `LobbyManager` for new guards after a game patch.
3. File an issue with log snippets and player count.
