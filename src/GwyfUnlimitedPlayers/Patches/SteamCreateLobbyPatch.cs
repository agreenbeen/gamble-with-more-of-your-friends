using System;
using HarmonyLib;
using Steamworks;

namespace GwyfUnlimitedPlayers.Patches;

/// <summary>
/// Steam lobby member limit is set at <see cref="SteamMatchmaking.CreateLobby"/> time.
/// Prefix the requested cap so the host advertises a higher lobby size.
/// </summary>
[HarmonyPatch(typeof(SteamMatchmaking), nameof(SteamMatchmaking.CreateLobby), new[] { typeof(ELobbyType), typeof(int) })]
internal static class SteamCreateLobbyPatch
{
    [HarmonyPrefix]
    private static void Prefix(ELobbyType eLobbyType, ref int cMaxMembers)
    {
        try
        {
            int want = GwyfUnlimitedPlayersPlugin.GetEffectiveMaxPlayers();
            int before = cMaxMembers;
            if (before != want)
            {
                cMaxMembers = want;
                GwyfUnlimitedPlayersPlugin.Log.LogInfo(
                    $"SteamMatchmaking.CreateLobby: cMaxMembers {before} -> {want} (lobbyType unchanged)");
            }
            else
            {
                GwyfUnlimitedPlayersPlugin.Verbose($"SteamMatchmaking.CreateLobby: cMaxMembers already {want}.");
            }
        }
        catch (Exception ex)
        {
            GwyfUnlimitedPlayersPlugin.Log.LogError("SteamCreateLobbyPatch failed: " + ex);
        }
    }
}
