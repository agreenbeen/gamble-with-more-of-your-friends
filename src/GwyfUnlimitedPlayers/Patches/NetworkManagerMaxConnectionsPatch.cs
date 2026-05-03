using HarmonyLib;
using Mirror;

namespace GwyfUnlimitedPlayers.Patches;

/// <summary>
/// Mirror rejects connections when <see cref="NetworkManager.maxConnections"/> is too low.
/// Apply configured cap whenever the game's <see cref="NetworkManager"/> initializes or starts hosting/listening.
/// </summary>
internal static class NetworkManagerMaxConnectionsPatch
{
    [HarmonyPostfix]
    [HarmonyPatch(typeof(NetworkManager), "Awake")]
    private static void AwakePostfix(NetworkManager __instance)
    {
        if (__instance == null) return;
        ApplyMaxConnections(__instance, nameof(AwakePostfix));
    }

    [HarmonyPrefix]
    [HarmonyPatch(typeof(NetworkManager), nameof(NetworkManager.StartHost))]
    private static void StartHostPrefix(NetworkManager __instance)
    {
        if (__instance == null) return;
        ApplyMaxConnections(__instance, nameof(StartHostPrefix));
    }

    [HarmonyPrefix]
    [HarmonyPatch(typeof(NetworkManager), nameof(NetworkManager.StartServer))]
    private static void StartServerPrefix(NetworkManager __instance)
    {
        if (__instance == null) return;
        ApplyMaxConnections(__instance, nameof(StartServerPrefix));
    }

    private static void ApplyMaxConnections(NetworkManager nm, string source)
    {
        int want = GwyfUnlimitedPlayersPlugin.GetEffectiveMaxPlayers();
        int before = nm.maxConnections;
        if (before == want)
        {
            GwyfUnlimitedPlayersPlugin.Verbose($"NetworkManager.{source}: maxConnections already {want}.");
            return;
        }

        nm.maxConnections = want;
        GwyfUnlimitedPlayersPlugin.Log.LogInfo(
            $"NetworkManager.{source}: maxConnections {before} -> {want} ({nm.GetType().FullName})");
    }
}
