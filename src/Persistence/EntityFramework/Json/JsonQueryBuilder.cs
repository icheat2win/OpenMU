// <copyright file="JsonQueryBuilder.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Persistence.EntityFramework.Json;

using System.Diagnostics;
using System.Globalization;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

/// <summary>
/// A query builder which creates a query to return a whole object graph as json by using postgres json functions.
/// </summary>
public class JsonQueryBuilder
{
    private const int IndentSize = 2;

    /// <summary>
    /// Builds the json query for the given entity type.
    /// </summary>
    /// <remarks>
    /// It creates a query like this (e.g. for GameConfiguration):
    /// select result."Id" "$id", result."Id", row_to_json(result) as GameConfiguration
    /// from (
    ///     select a."Id", a.*, (
    ///       -- additional subqueries which return json
    ///       ...)
    ///     from config."GameConfiguration" a
    /// ) result;.
    /// </remarks>
    /// <param name="entityType">Type of the entity.</param>
    /// <returns>The query which returns the objects of the given type as json string.</returns>
    public string BuildJsonQueryForEntity(IEntityType entityType)
    {
        //Debug.WriteLine($"Building the json query for {entityType.Name}.");
        var stringBuilder = new StringBuilder();
        this.AppendLine(stringBuilder, $"select result.\"Id\" \"$id\", result.\"Id\" id, row_to_json(result) as {entityType.GetTableName()}", 0);
        this.AppendLine(stringBuilder, "from (", 0);
        this.AddTypeToQuery(entityType, stringBuilder, "a", 1);
        this.AppendLine(stringBuilder, ") result", 0);
        var result = stringBuilder.ToString();
        //Debug.WriteLine("Finished building the json query for {0}. Result: {1}", entityType.Name, result);

        return result;
    }

    /// <summary>
    /// Gets the navigations of the entity type, automatically sorted by dependencies.
    /// </summary>
    /// <param name="entityType">Type of the entity.</param>
    /// <returns>The navigations of the entity type, sorted so that dependencies come before dependents.</returns>
    /// <remarks>
    /// Navigations are automatically sorted using topological sort based on foreign key relationships.
    /// This ensures that entities are serialized in the correct order for deserialization.
    /// Can be overwritten to apply custom sorting if needed.
    /// </remarks>
    protected virtual IEnumerable<INavigation> GetNavigations(IEntityType entityType)
    {
        var navigations = entityType.GetNavigations().ToList();
        if (navigations.Count <= 1)
        {
            return navigations;
        }

        try
        {
            return this.SortNavigationsByDependencies(navigations);
        }
        catch (InvalidOperationException)
        {
            // If circular dependencies detected, return original order
            return navigations;
        }
    }

    /// <summary>
    /// Sorts navigations using topological sort based on foreign key dependencies.
    /// </summary>
    /// <param name="navigations">The navigations to sort.</param>
    /// <returns>Sorted navigations with dependencies before dependents.</returns>
    private IEnumerable<INavigation> SortNavigationsByDependencies(IList<INavigation> navigations)
    {
        var navigationMap = navigations.ToDictionary(n => n.Name);
        var dependencies = new Dictionary<string, HashSet<string>>();
        var inDegree = new Dictionary<string, int>();

        // Initialize dependency tracking
        foreach (var nav in navigations)
        {
            dependencies[nav.Name] = new HashSet<string>();
            inDegree[nav.Name] = 0;
        }

        // Build dependency graph by analyzing foreign keys
        foreach (var nav in navigations)
        {
            var targetType = nav.TargetEntityType;

            // Check if the target entity has foreign keys pointing to other navigations
            foreach (var foreignKey in targetType.GetForeignKeys())
            {
                var principalType = foreignKey.PrincipalEntityType;

                // Find if this principal type is referenced by another navigation in our list
                foreach (var otherNav in navigations)
                {
                    if (otherNav.Name == nav.Name)
                    {
                        continue;
                    }

                    // If the other navigation's target is the principal type,
                    // then current nav depends on other nav
                    if (otherNav.TargetEntityType == principalType ||
                        otherNav.TargetEntityType.ClrType == principalType.ClrType)
                    {
                        if (dependencies[nav.Name].Add(otherNav.Name))
                        {
                            inDegree[nav.Name]++;
                        }
                    }
                }
            }
        }

        // Topological sort using Kahn's algorithm
        var result = new List<INavigation>();
        var queue = new Queue<string>();

        // Start with navigations that have no dependencies
        foreach (var nav in navigations)
        {
            if (inDegree[nav.Name] == 0)
            {
                queue.Enqueue(nav.Name);
            }
        }

        while (queue.Count > 0)
        {
            var current = queue.Dequeue();
            result.Add(navigationMap[current]);

            // Reduce in-degree for all navigations that depend on current
            foreach (var nav in navigations)
            {
                if (dependencies[nav.Name].Contains(current))
                {
                    inDegree[nav.Name]--;
                    if (inDegree[nav.Name] == 0)
                    {
                        queue.Enqueue(nav.Name);
                    }
                }
            }
        }

        // Check for circular dependencies
        if (result.Count != navigations.Count)
        {
            // Circular dependency detected, throw exception to use fallback
            throw new InvalidOperationException($"Circular dependency detected in navigation properties for {navigations[0].DeclaringEntityType.Name}");
        }

        return result;
    }

    private void AppendLine(StringBuilder stringBuilder, string text, int indentLevel)
    {
        if (indentLevel > 0)
        {
            stringBuilder.Append(' ', indentLevel * IndentSize);
        }

        stringBuilder.AppendLine(text);
    }

    private void Append(StringBuilder stringBuilder, string text, int indentLevel)
    {
        if (indentLevel > 0)
        {
            stringBuilder.Append(' ', indentLevel * IndentSize);
        }

        stringBuilder.Append(text);
    }

    private void AddTypeToQuery(IEntityType entityType, StringBuilder stringBuilder, string alias, int indentLevel)
    {
        this.Append(stringBuilder, $"select {alias}.\"Id\" as \"$id\", {alias}.*", indentLevel);
        this.AddNavigationsToQuery(entityType, stringBuilder, alias, indentLevel);
        this.AppendLine(stringBuilder, $" from {entityType.GetSchema()}.\"{entityType.GetTableName()}\" {alias}", 0);
    }

    private void AddNavigationsToQuery(IEntityType entityType, StringBuilder stringBuilder, string parentAlias, int indentLevel)
    {
        var navigationAlias = this.GetNextAlias(parentAlias);
        if (navigationAlias == "i")
        {
            // stopping circular reference
            // Debug.Fail($"Stopping circular reference at entity type {entityType.Name}");
            return;
        }

        var navigations = this.GetNavigations(entityType);

        foreach (var navigation in navigations)
        {
            if (navigation.IsCollection)
            {
                this.AddCollection(navigation, entityType, stringBuilder, parentAlias, indentLevel);
            }
            else //// it's a foreign key
            {
                this.AddNavigation(navigation, stringBuilder, parentAlias, indentLevel);
            }
        }
    }

    private string GetNextAlias(string parentAlias)
    {
        return ((char)(parentAlias[0] + 1)).ToString(CultureInfo.InvariantCulture);
    }

    private void AddNavigation(INavigation navigation, StringBuilder stringBuilder, string parentAlias, int indentLevel)
    {
        if (navigation.ForeignKey.DeclaringEntityType != navigation.DeclaringEntityType)
        {
            // inverse property, no data required
            Debug.WriteLine("Inverse property {0}", navigation.Name);
            return;
        }

        var navigationAlias = this.GetNextAlias(parentAlias);
        var targetType = navigation.TargetEntityType;
        var foreignKey = navigation.ForeignKey.Properties[0];
        if (foreignKey.IsShadowProperty())
        {
            // We assume that every important foreign key is mapped to a "real" property
            Debug.WriteLine("Shadow property {0}", navigation.Name);
            return;
        }

        var isBackReference = navigation.ForeignKey.PrincipalToDependent?.IsCollection ?? false;
        if (isBackReference)
        {
            // It's a back reference of a collection - we just have to create a reference json object
            Debug.WriteLine("Back Reference property {0}", navigation.Name);
        }

        stringBuilder.Append(", (");
        if (!navigation.IsMemberOfAggregate() || isBackReference)
        {
            stringBuilder
                .Append($"case when {parentAlias}.\"{foreignKey.Name}\" is null then null else ")
                .Append("json_build_object('$ref', ").Append(parentAlias).Append(".\"").Append(foreignKey.Name).Append("\") end");
        }
        else
        {
            stringBuilder.AppendLine();
            this.AppendLine(stringBuilder, $"select row_to_json({navigationAlias}) from (", indentLevel + 1);
            this.AddTypeToQuery(targetType, stringBuilder, navigationAlias, indentLevel + 2);
            this.Append(stringBuilder, $") {navigationAlias} where {navigationAlias}.\"{targetType.GetPrimaryKeyColumnName()}\" = {parentAlias}.\"{foreignKey.Name}\"", indentLevel + 1);
        }

        stringBuilder.AppendLine();
        this.Append(stringBuilder, $") as \"{navigation.Name}\"", 0);
    }

    private void AddCollection(INavigation navigation, IEntityType entityType, StringBuilder stringBuilder, string parentAlias, int indentLevel)
    {
        var keyProperty = navigation.ForeignKey.Properties[0];
        var navigationType = (IEntityType)keyProperty.DeclaringType;
#pragma warning disable EF1001 // Internal EF Core API usage.
        if (navigationType.FindDeclaredPrimaryKey() is not { } primaryKey)
        {
            return;
        }
#pragma warning restore EF1001 // Internal EF Core API usage.

        if (primaryKey.Properties.Count > 1)
        {
            this.AddManyToManyCollection(navigationType, entityType, stringBuilder, parentAlias, keyProperty, indentLevel);
        }
        else
        {
            this.AddOneToManyCollection(navigation, navigationType, stringBuilder, parentAlias, keyProperty, indentLevel);
        }

        stringBuilder.AppendLine();
        this.Append(stringBuilder, $") as \"{navigation.Name.Replace("Joined", string.Empty)}\"", 0);
    }

    private void AddOneToManyCollection(INavigation navigation, IEntityType navigationType, StringBuilder stringBuilder, string parentAlias, IProperty keyProperty, int indentLevel)
    {
        var primaryKeyName = navigationType.GetDeclaredPrimaryKeyColumnName();

        var navigationAlias = this.GetNextAlias(parentAlias);

        stringBuilder.AppendLine(", (");
        this.AppendLine(stringBuilder, $"select array_to_json(array_agg(row_to_json({navigationAlias}))) from (", indentLevel + 1);

        if (navigation.IsMemberOfAggregate())
        {
            this.AddTypeToQuery(navigationType, stringBuilder, navigationAlias, indentLevel + 2);
            this.AppendLine(stringBuilder, $") {navigationAlias}", indentLevel + 1);
            this.Append(stringBuilder, $"where {navigationAlias}.\"{keyProperty.Name}\" = {parentAlias}.\"{primaryKeyName}\"", indentLevel + 1);
        }
        else
        {
            var primaryKeyColumnName = navigationType.GetPrimaryKeyColumnName(); // It's always one property, usually called "Id"
            this.AppendLine(stringBuilder, $"select \"{primaryKeyColumnName}\" as \"$ref\"", indentLevel + 2);
            this.AppendLine(stringBuilder, $"from {navigationType.GetSchema()}.\"{navigationType.GetTableName()}\"", indentLevel + 2);
            this.AppendLine(stringBuilder, $"where \"{keyProperty.Name}\" = {parentAlias}.\"{primaryKeyName}\"", indentLevel + 2);
            this.Append(stringBuilder, $") as {navigationAlias}", indentLevel + 1);
        }
    }

    /// <summary>
    /// Adds the many to many collection to the query.
    /// We assume that every many to many join entity only consists of the both foreign keys.
    /// Additionally we assume that every target entity is referencable.
    /// Therefore we just select the target entities as reference.
    /// When adding an object of the target type, our Ef-Core entity classes would automatically create join entities
    /// with the right keys, because they use <see cref="ManyToManyCollectionAdapter{T,TJoin}"/>s.
    /// </summary>
    /// <param name="navigationType">Type of the navigation, the join entity type.</param>
    /// <param name="entityType">Type of the entity which is currently getting processed. It holds the collection which is about to be added.</param>
    /// <param name="stringBuilder">The string builder which is used to create the query string.</param>
    /// <param name="parentAlias">The parent alias, required to reference the primary key of the <paramref name="entityType"/>.</param>
    /// <param name="keyProperty">The key property.</param>
    /// <param name="indentLevel">The current indentation level.</param>
    private void AddManyToManyCollection(IEntityType navigationType, IEntityType entityType, StringBuilder stringBuilder, string parentAlias, IProperty keyProperty, int indentLevel)
    {
        var navigationAlias = this.GetNextAlias(parentAlias);
        var entityTypePrimaryKeyName = entityType.GetPrimaryKeyColumnName(); // usually "Id"
        var otherEntityTypeForeignKey = navigationType.GetForeignKeys().FirstOrDefault(fk => fk.PrincipalEntityType != entityType);
        var otherEntityTypeKey = navigationType.GetKeys().FirstOrDefault(fk => fk.DeclaringEntityType != entityType);
        var referenceColumnToOtherEntity = otherEntityTypeForeignKey?.GetColumnName() ?? otherEntityTypeKey?.GetColumnName()
            ?? throw new InvalidOperationException("No reference column available.");

        stringBuilder.AppendLine(", (");
        this.AppendLine(stringBuilder, $"select array_to_json(array_agg(row_to_json({navigationAlias}))) from (", indentLevel + 1);

        this.AppendLine(stringBuilder, $"select \"{referenceColumnToOtherEntity}\" as \"$ref\"", indentLevel + 2);
        this.AppendLine(stringBuilder, $"from {navigationType.GetSchema()}.\"{navigationType.GetTableName()}\"", indentLevel + 2);
        this.AppendLine(stringBuilder, $"where \"{keyProperty.Name}\" = {parentAlias}.\"{entityTypePrimaryKeyName}\"", indentLevel + 2);
        this.Append(stringBuilder, $") as {navigationAlias}", indentLevel + 1);
    }
}