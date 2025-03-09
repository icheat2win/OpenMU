// <copyright file="GetMasterLevelChatCommandPlugIn.cs" company="MUnique">
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
/// A chat command plugin to get a character's master level.
/// </summary>
[Guid("B8E35F57-2ED4-4BAD-9F95-9C88E1B92B1D")]
[PlugIn("Get master level command", "Gets master level of a player.")]
[ChatCommandHelp(Command, "Gets master level of a player. Usage: /getmasterlevel <optional:character>", null)]
public class GetMasterLevelChatCommandPlugIn : ChatCommandPlugInBase<GetMasterLevelChatCommandPlugIn.Arguments>, IDisabledByDefault
{
    private const string Command = "/getmasterlevel";
    private const CharacterStatus MinimumStatus = CharacterStatus.GameMaster;
    private const string CharacterNotFoundMessage = "Character '{0}' not found.";
    private const string MasterLevelGetMessage = "Master level of '{0}': {1}.";

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

        await this.ShowMessageToAsync(player, string.Format(MasterLevelGetMessage, targetPlayer.SelectedCharacter.Name, targetPlayer.Attributes![Stats.MasterLevel])).ConfigureAwait(false);
    }

    /// <summary>
    /// Arguments for the Get Master Level chat command.
    /// </summary>
    public class Arguments : ArgumentsBase
    {
        /// <summary>
        /// Gets or sets the character name to get master level for.
        /// </summary>
        public string? CharacterName { get; set; }
    }
}