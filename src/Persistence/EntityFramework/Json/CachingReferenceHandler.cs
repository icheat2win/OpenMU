// <copyright file="CachingReferenceHandler.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Persistence.EntityFramework.Json;

using System.Text.Json.Serialization;
using MUnique.OpenMU.Persistence.Json;

/// <summary>
/// A reference handler which considers cached configuration objects.
/// This is basically needed when loading account data. They can have references
/// to configuration.
/// </summary>
public class CachingReferenceHandler : ReferenceHandler, IIdReferenceHandler
{
    private readonly ConfigurationIdReferenceResolver? _configResolver;

    /// <summary>
    /// Initializes a new instance of the <see cref="CachingReferenceHandler"/> class.
    /// Uses the singleton instance of <see cref="ConfigurationIdReferenceResolver"/> for backward compatibility.
    /// </summary>
    public CachingReferenceHandler()
        : this(null)
    {
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="CachingReferenceHandler"/> class.
    /// </summary>
    /// <param name="configResolver">The configuration resolver. If null, uses the singleton instance.</param>
    public CachingReferenceHandler(ConfigurationIdReferenceResolver? configResolver)
    {
        this._configResolver = configResolver;
    }

    /// <summary>
    /// Gets the currently used resolver.
    /// </summary>
    public ReferenceResolver? Current { get; private set; }

    /// <inheritdoc />
    public override ReferenceResolver CreateResolver()
    {
        var resolver = this._configResolver ?? ConfigurationIdReferenceResolver.Instance;
        return this.Current ??= new MultipleSourceReferenceResolver(new IdReferenceResolver(), resolver);
    }
}