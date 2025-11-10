// <copyright file="BotPlayerIntelligence.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameLogic.AI;

using System.Threading;
using Microsoft.Extensions.Logging;
using MUnique.OpenMU.GameLogic.Attributes;
using MUnique.OpenMU.GameLogic.NPC;
using MUnique.OpenMU.Pathfinding;

/// <summary>
/// AI intelligence for bot players that makes them behave like real players.
/// </summary>
public class BotPlayerIntelligence : INpcIntelligence, IDisposable
{
    private readonly ILogger<BotPlayerIntelligence> _logger;
    private readonly Random _random = new();
    private Timer? _aiTimer;
    private Monster? _botPlayer;
    private BotBehaviorMode _currentBehavior;
    private DateTime _nextActionTime;
    private IAttackable? _currentTarget;

    /// <summary>
    /// Initializes a new instance of the <see cref="BotPlayerIntelligence"/> class.
    /// </summary>
    /// <param name="logger">The logger.</param>
    /// <param name="behavior">The initial behavior mode.</param>
    public BotPlayerIntelligence(ILogger<BotPlayerIntelligence> logger, BotBehaviorMode behavior = BotBehaviorMode.Explorer)
    {
        this._logger = logger;
        this._currentBehavior = behavior;
        this._nextActionTime = DateTime.UtcNow;
    }

    /// <summary>
    /// Bot behavior modes.
    /// </summary>
    public enum BotBehaviorMode
    {
        /// <summary>
        /// Bot walks around the map randomly.
        /// </summary>
        Explorer,

        /// <summary>
        /// Bot hunts monsters for experience.
        /// </summary>
        Hunter,

        /// <summary>
        /// Bot stays mostly idle with occasional movement.
        /// </summary>
        Idle,

        /// <summary>
        /// Bot patrols between specific waypoints.
        /// </summary>
        Patrol,

        /// <summary>
        /// Bot follows other players around.
        /// </summary>
        Social,
    }

    /// <inheritdoc/>
    public NonPlayerCharacter Npc
    {
        get => this.BotPlayer;
        set => this.BotPlayer = (Monster)value;
    }

    /// <summary>
    /// Gets or sets the bot player (as a Monster).
    /// </summary>
    public Monster BotPlayer
    {
        get => this._botPlayer ?? throw new InvalidOperationException("Bot player not initialized");
        set => this._botPlayer = value;
    }

    /// <inheritdoc/>
    public bool CanWalkOnSafezone => true;

    /// <summary>
    /// Gets or sets the current behavior mode.
    /// </summary>
    public BotBehaviorMode CurrentBehavior
    {
        get => this._currentBehavior;
        set => this._currentBehavior = value;
    }

    /// <summary>
    /// Starts the AI behavior.
    /// </summary>
    public void Start()
    {
        this._logger.LogDebug("Starting bot intelligence for {BotName}", this._botPlayer?.Definition.Designation);
        var tickInterval = TimeSpan.FromMilliseconds(1000 + this._random.Next(0, 500)); // Randomize to avoid all bots acting simultaneously
        this._aiTimer ??= new Timer(_ => this.SafeTick(), null, tickInterval, tickInterval);
    }

    /// <summary>
    /// Pauses the AI behavior.
    /// </summary>
    public void Pause()
    {
        this._logger.LogDebug("Pausing bot intelligence for {BotName}", this._botPlayer?.Definition.Designation);
        this._aiTimer?.Dispose();
        this._aiTimer = null;
    }

    /// <inheritdoc/>
    public void RegisterHit(IAttacker attacker)
    {
        if (this._currentTarget is null && attacker is IAttackable attackable)
        {
            this._currentTarget = attackable;
            this._logger.LogDebug("Bot {BotName} registered hit from {Attacker}", this._botPlayer?.Definition.Designation, attackable);
        }
    }

    /// <inheritdoc/>
    public bool CanWalkOn(Point target)
    {
        if (this._botPlayer?.CurrentMap is not { } map)
        {
            return false;
        }

        if (target.X >= map.Terrain.WalkMap.GetLength(0) || target.Y >= map.Terrain.WalkMap.GetLength(1))
        {
            return false;
        }

        return map.Terrain.WalkMap[target.X, target.Y];
    }

    /// <inheritdoc/>
    public void Dispose()
    {
        this.Dispose(true);
        GC.SuppressFinalize(this);
    }

    /// <summary>
    /// Releases resources.
    /// </summary>
    /// <param name="disposing">Whether disposing managed resources.</param>
    protected virtual void Dispose(bool disposing)
    {
        if (disposing)
        {
            this._aiTimer?.Dispose();
            this._aiTimer = null;
        }
    }

    private void SafeTick()
    {
        try
        {
            _ = this.TickAsync();
        }
        catch (Exception ex)
        {
            this._logger.LogError(ex, "Error in bot intelligence tick for {BotName}", this._botPlayer?.Definition.Designation);
        }
    }

    private async Task TickAsync()
    {
        if (this._botPlayer is not { IsAlive: true, CurrentMap: not null })
        {
            return;
        }

        if (DateTime.UtcNow < this._nextActionTime)
        {
            return;
        }

        switch (this._currentBehavior)
        {
            case BotBehaviorMode.Explorer:
                await this.ExploreAsync().ConfigureAwait(false);
                break;
            case BotBehaviorMode.Hunter:
                await this.HuntAsync().ConfigureAwait(false);
                break;
            case BotBehaviorMode.Idle:
                await this.IdleAsync().ConfigureAwait(false);
                break;
            case BotBehaviorMode.Patrol:
                await this.PatrolAsync().ConfigureAwait(false);
                break;
            case BotBehaviorMode.Social:
                await this.SocialAsync().ConfigureAwait(false);
                break;
        }

        // Random delay between actions to make bot behavior more natural
        this._nextActionTime = DateTime.UtcNow.AddSeconds(this._random.Next(2, 8));
    }

    private async Task ExploreAsync()
    {
        // Pick a random destination and walk there
        if (this._botPlayer?.CurrentMap is not { } map)
        {
            return;
        }

        if (this._botPlayer.IsWalking)
        {
            return; // Already walking
        }

        var maxX = map.Terrain.WalkMap.GetLength(0);
        var maxY = map.Terrain.WalkMap.GetLength(1);

        // Try to find a walkable destination
        for (int attempts = 0; attempts < 10; attempts++)
        {
            var targetX = (byte)this._random.Next(0, maxX);
            var targetY = (byte)this._random.Next(0, maxY);
            var target = new Point(targetX, targetY);

            if (this.CanWalkOn(target))
            {
                this._logger.LogDebug("Bot {BotName} exploring to {Target}", this._botPlayer.Definition.Designation, target);
                await this._botPlayer.WalkToAsync(target).ConfigureAwait(false);
                break;
            }
        }
    }

    private async Task HuntAsync()
    {
        // Look for nearby monsters and attack them
        if (this._botPlayer?.CurrentMap is not { } map)
        {
            return;
        }

        // Find nearest monster
        var nearbyMonsters = map.GetAttackablesInRange(this._botPlayer.Position, 10)
            .OfType<Monster>()
            .Where(m => m.IsAlive && !m.IsAtSafezone())
            .OrderBy(m => m.GetDistanceTo(this._botPlayer))
            .ToList();

        if (nearbyMonsters.Count > 0)
        {
            var target = nearbyMonsters.First();
            this._currentTarget = target;

            // Walk to monster if too far
            if (target.GetDistanceTo(this._botPlayer) > 3)
            {
                this._logger.LogDebug("Bot {BotName} walking to monster {Monster}", this._botPlayer.Definition.Designation, target.Definition.Designation);
                await this._botPlayer.WalkToAsync(target.Position).ConfigureAwait(false);
            }
            else
            {
                // Attack the monster
                this._logger.LogDebug("Bot {BotName} attacking monster {Monster}", this._botPlayer.Definition.Designation, target.Definition.Designation);
                await this._botPlayer.AttackAsync(target).ConfigureAwait(false);
            }
        }
        else
        {
            // No monsters nearby, explore
            await this.ExploreAsync().ConfigureAwait(false);
        }
    }

    private async Task IdleAsync()
    {
        // Occasionally walk a short distance
        if (this._random.Next(0, 10) > 7)
        {
            if (this._botPlayer?.CurrentMap is { } map)
            {
                var currentPos = this._botPlayer.Position;
                var targetX = (byte)Math.Clamp(currentPos.X + this._random.Next(-3, 4), 0, map.Terrain.WalkMap.GetLength(0) - 1);
                var targetY = (byte)Math.Clamp(currentPos.Y + this._random.Next(-3, 4), 0, map.Terrain.WalkMap.GetLength(1) - 1);
                var target = new Point(targetX, targetY);

                if (this.CanWalkOn(target))
                {
                    this._logger.LogDebug("Bot {BotName} idle walking to {Target}", this._botPlayer.Definition.Designation, target);
                    await this._botPlayer.WalkToAsync(target).ConfigureAwait(false);
                }
            }
        }
    }

    private async Task PatrolAsync()
    {
        // Similar to explore but with defined waypoints
        // For now, just use explore behavior
        await this.ExploreAsync().ConfigureAwait(false);
    }

    private async Task SocialAsync()
    {
        // Find nearby players and follow them
        if (this._botPlayer?.CurrentMap is not { } map)
        {
            return;
        }

        var nearbyPlayers = map.GetAttackablesInRange(this._botPlayer.Position, 15)
            .OfType<Player>()
            .Where(p => p.IsAlive)
            .OrderBy(p => p.GetDistanceTo(this._botPlayer))
            .ToList();

        if (nearbyPlayers.Count > 0 && this._random.Next(0, 10) > 5)
        {
            var targetPlayer = nearbyPlayers.First();
            var distance = targetPlayer.GetDistanceTo(this._botPlayer);

            if (distance > 3 && distance < 10)
            {
                this._logger.LogDebug("Bot {BotName} following player {Player}", this._botPlayer.Definition.Designation, targetPlayer.SelectedCharacter?.Name);
                await this._botPlayer.WalkToAsync(targetPlayer.Position).ConfigureAwait(false);
            }
        }
        else
        {
            // No players nearby, explore
            await this.ExploreAsync().ConfigureAwait(false);
        }
    }
}
