using System;
using HarmonyLib;
using Steamworks;

namespace GwyfUnlimitedPlayers.Patches;

/// <summary>
/// If the game adjusts the lobby member limit after creation, keep it aligned with the configured cap.
/// </summary>
[HarmonyPatch(typeof(SteamMatchmaking), nameof(SteamMatchmaking.SetLobbyMemberLimit), new[] { typeof(CSteamID), typeof(int) })]
internal static class SteamSetLobbyMemberLimitPatch
{
    [HarmonyPrefix]
    private static void Prefix(CSteamID steamIDLobby, ref int cMaxMembers)
    {
        try
        {
            int want = GwyfUnlimitedPlayersPlugin.GetEffectiveMaxPlayers();
            int before = cMaxMembers;
            if (before != want)
            {
                cMaxMembers = want;
                GwyfUnlimitedPlayersPlugin.Log.LogInfo(
                    $"SteamMatchmaking.SetLobbyMemberLimit: cMaxMembers {before} -> {want}");
            }
            else
            {
                GwyfUnlimitedPlayersPlugin.Verbose("SteamMatchmaking.SetLobbyMemberLimit: already at configured cap.");
            }
        }
        catch (Exception ex)
        {
            GwyfUnlimitedPlayersPlugin.Log.LogError("SteamSetLobbyMemberLimitPatch failed: " + ex);
        }
    }
}
