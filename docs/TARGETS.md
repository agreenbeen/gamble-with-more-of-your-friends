# Patch target map (Gamble With Your Friends)

Reverse engineering used **ASCII string extraction** from the game’s managed assemblies plus `ScriptingAssemblies.json` / `RuntimeInitializeOnLoads.json`. No dnSpy run in-repo; validate signatures locally if a game update breaks patches.

## Stack

| Assembly | Role |
|----------|------|
| `Assembly-CSharp.dll` | `LobbyManager`, `GoOnlineClient`, `CustomNetworkManager`, Steam lobby callbacks (`LobbyCreated_t`, `LobbyEnter_t`), `GetLobbyMemberLimit` symbol |
| `Mirror.dll` | `NetworkManager`, `maxConnections` |
| `com.rlabrecque.steamworks.net.dll` | `Steamworks.SteamMatchmaking.CreateLobby`, `SetLobbyMemberLimit` |
| `FizzySteamworks.dll` | Steam ↔ Mirror transport; references `maxConnections` |

## Implemented Harmony targets (v1)

1. **`Mirror.NetworkManager`**
   - Postfix **`Awake`**: set `maxConnections` to configured cap so transports see the raised limit early.
   - Prefix **`StartHost`** / **`StartServer`**: set again before listen (defensive).

2. **`Steamworks.SteamMatchmaking.CreateLobby(ELobbyType, int)`**
   - Prefix: replace `cMaxMembers` with configured cap (Steam lobby size).

3. **`Steamworks.SteamMatchmaking.SetLobbyMemberLimit(CSteamID, int)`**
   - Prefix: replace `cMaxMembers` with configured cap if the game adjusts the limit after creation.

## Game-specific symbols (for future patches)

Strings in `Assembly-CSharp.dll` point to these scripts; use them if v1 is insufficient (UI slots, invite limits, Dissonance, etc.):

- `Assets/00_Content/SetupScene/LobbyManager.cs`
- `Assets/00_Content/SetupScene/GoOnlineClient.cs`
- `Assets/00_Content/SetupScene/CustomNetworkManager.cs`
- `Assets/ThirdParty/GameSettingsManager/Scripts/LobbySettings.cs`

If joins still fail at N players, inspect **`GoOnlineClient`** / **`LobbyManager`** for extra guards (e.g. hardcoded slot UI count) and add targeted Harmony patches.
