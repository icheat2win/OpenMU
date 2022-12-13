﻿// <copyright file="GameConfigurationContext.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Persistence.EntityFramework;

using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using MUnique.OpenMU.Persistence.EntityFramework.Model;

/// <summary>
/// Persistence context which is used to access the <see cref="GameConfiguration"/>.
/// </summary>
internal class GameConfigurationContext : CachingEntityFrameworkContext, IConfigurationContext
{
    /// <summary>
    /// Initializes a new instance of the <see cref="GameConfigurationContext"/> class.
    /// </summary>
    /// <param name="repositoryManager">The repository manager.</param>
    /// <param name="logger">The logger.</param>
    public GameConfigurationContext(RepositoryManager repositoryManager, ILogger<GameConfigurationContext> logger)
        : base(new ConfigurationContext(), repositoryManager, logger)
    {
    }

    /// <inheritdoc />
    public async ValueTask<Guid?> GetDefaultGameConfigurationIdAsync()
    {
        return await this.Context.Set<GameConfiguration>().Select(g => g.Id).FirstOrDefaultAsync().ConfigureAwait(false);
    }
}