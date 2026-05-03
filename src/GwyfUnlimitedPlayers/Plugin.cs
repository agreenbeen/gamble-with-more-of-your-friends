using System;
using BepInEx;
using BepInEx.Configuration;
using BepInEx.Logging;
using HarmonyLib;

namespace GwyfUnlimitedPlayers;

[BepInPlugin(PluginInfo.PLUGIN_GUID, PluginInfo.PLUGIN_NAME, PluginInfo.PLUGIN_VERSION)]
public sealed class GwyfUnlimitedPlayersPlugin : BaseUnityPlugin
{
    internal static ManualLogSource Log = null!;

    /// <summary>Effective max players (Steam lobby members / Mirror slots). Clamped 2–16.</summary>
    internal static ConfigEntry<int> MaxPlayers = null!;

    internal static ConfigEntry<bool> VerboseLogging = null!;

    private Harmony? _harmony;

    private void Awake()
    {
        Log = Logger;
        MaxPlayers = Config.Bind(
            "General",
            "MaxPlayers",
            12,
            "Maximum players in the same Steam lobby / Mirror server (including host). Range: 2–16. Host must run this mod.");
        VerboseLogging = Config.Bind(
            "General",
            "VerboseLogging",
            false,
            "Log extra diagnostics when applying caps.");

        OnMaxPlayersSettingChanged(MaxPlayers, EventArgs.Empty);

        MaxPlayers.SettingChanged += OnMaxPlayersSettingChanged;

        _harmony = new Harmony(PluginInfo.PLUGIN_GUID);
        _harmony.PatchAll();

        Log.LogInfo($"{PluginInfo.PLUGIN_NAME} {PluginInfo.PLUGIN_VERSION} loaded. MaxPlayers={GetEffectiveMaxPlayers()}");
    }

    private void OnDestroy()
    {
        if (MaxPlayers != null)
            MaxPlayers.SettingChanged -= OnMaxPlayersSettingChanged;
        _harmony?.UnpatchSelf();
        _harmony = null;
    }

    private static void OnMaxPlayersSettingChanged(object sender, EventArgs e)
    {
        if (sender is not ConfigEntry<int> entry) return;
        int clamped = Math.Clamp(entry.Value, 2, 16);
        if (clamped != entry.Value)
        {
            entry.Value = clamped;
            Log.LogWarning($"MaxPlayers was out of range; clamped to {clamped}.");
        }
    }

    internal static int GetEffectiveMaxPlayers()
    {
        int v = MaxPlayers?.Value ?? 12;
        if (v < 2) v = 2;
        if (v > 16) v = 16;
        return v;
    }

    internal static void Verbose(string message)
    {
        if (VerboseLogging is { Value: true })
            Log.LogInfo("[Verbose] " + message);
    }
}

internal static class PluginInfo
{
    public const string PLUGIN_GUID = "agreenbeen.gwyf.unlimited_players";
    public const string PLUGIN_NAME = "GWYF Unlimited Players";
    public const string PLUGIN_VERSION = "1.0.0";
}
