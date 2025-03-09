// <copyright file="SetMasterLevelChatCommandPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameLogic.PlugIns.ChatCommands;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.Attributes;
using MUnique.OpenMU.GameLogic.Views.Character;
using MUnique.OpenMU.Interfaces;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// A chat command plugin which sets a character's master level.
/// </summary>
[Guid("B8E35F57-2ED4-4BAD-9F95-9C88E1B92B1B")]
[PlugIn("Set master level command", "Sets master level of a player.")]
[ChatCommandHelp(Command, "Sets master level of a player. Usage: /setmasterlevel <level> <optional:character>", null)]
public class SetMasterLevelChatCommandPlugIn : ChatCommandPlugInBase<SetMasterLevelChatCommandPlugIn.Arguments>, IDisabledByDefault
{
    private const string Command = "/setmasterlevel";
    private const CharacterStatus MinimumStatus = CharacterStatus.GameMaster;
    private const string CharacterNotFoundMessage = "Character '{0}' not found.";
    private const string InvalidLevelMessage = "Invalid level - must be between 1 and {0}.";
    private const string MasterLevelSetMessage = "Master level set to {0}.";

    /// <inheritdoc />
    public override string Key => Command;

    /// <inheritdoc />
    public override CharacterStatus MinCharacterStatusRequirement => MinimumStatus;

    /// <inheritdoc />
    protected override async ValueTask DoHandleCommandAsync(Player player, Arguments arguments)
    {
        var targetPlayer = player;
        if (arguments?.CharacterName is { } characterName)
        {
            targetPlayer = player.GameContext.GetPlayerByCharacterName(characterName);
            if (targetPlayer?.SelectedCharacter is null ||
                !targetPlayer.SelectedCharacter.Name.Equals(characterName, StringComparison.OrdinalIgnoreCase))
            {
                await this.ShowMessageToAsync(player, string.Format(CharacterNotFoundMessage, characterName)).ConfigureAwait(false);
                return;
            }
        }

        if (targetPlayer.SelectedCharacter is null)
        {
            return;
        }

        if (arguments is null || arguments.MasterLevel < 1 || arguments.MasterLevel > targetPlayer.GameContext.Configuration.MaximumMasterLevel)
        {
            await this.ShowMessageToAsync(player, string.Format(InvalidLevelMessage, targetPlayer.GameContext.Configuration.MaximumMasterLevel)).ConfigureAwait(false);
            return;
        }

        targetPlayer.Attributes![Stats.MasterLevel] = checked(arguments.MasterLevel);
        await targetPlayer.InvokeViewPlugInAsync<IUpdateLevelPlugIn>(p => p.UpdateMasterLevelAsync()).ConfigureAwait(false);
        await targetPlayer.ForEachWorldObserverAsync<IShowEffectPlugIn>(p => p.ShowEffectAsync(targetPlayer, IShowEffectPlugIn.EffectType.LevelUp), true).ConfigureAwait(false);
        await this.ShowMessageToAsync(player, string.Format(MasterLevelSetMessage, arguments.MasterLevel)).ConfigureAwait(false);
    }

    /// <summary>
    /// Arguments for the Set Master Level chat command.
    /// </summary>
    public class Arguments : ArgumentsBase
    {
        /// <summary>
        /// Gets or sets the master level to set.
        /// </summary>
        public int MasterLevel { get; set; }

        /// <summary>
        /// Gets or sets the character name to set master level for.
        /// </summary>
        public string? CharacterName { get; set; }
    }
}