// <copyright file="EditAccount.razor.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Web.AdminPanel.Pages;

using System.Collections;
using System.Threading;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Rendering;
using MUnique.OpenMU.DataModel.Entities;
using MUnique.OpenMU.Persistence;
using MUnique.OpenMU.Web.AdminPanel.Components.AccountEdit;
using MUnique.OpenMU.Web.AdminPanel.Components.CharacterEdit;
using MUnique.OpenMU.Web.AdminPanel.Components.Form;
using MUnique.OpenMU.Web.AdminPanel.Components.ItemEdit;

/// <summary>
/// The edit page for account data.
/// </summary>
[Route("/edit-account/{accountId:guid}/{typeString}/{id:guid}")]
public partial class EditAccount : EditBase
{
    private AccountDataSourceWrapper? _dataSourceWrapper;

    /// <summary>
    /// Gets or sets the identifier of the account which should be edited.
    /// </summary>
    [Parameter]
    public Guid AccountId { get; set; }

    /// <summary>
    /// Gets or sets the data source for account data.
    /// </summary>
    [Inject]
    public IDataSource<Account> AccountData { get; set; } = null!;

    /// <inheritdoc />
    protected override IDataSource EditDataSource => this._dataSourceWrapper ??= new AccountDataSourceWrapper(this.AccountData, this.AccountId);

    /// <inheritdoc />
    public override async Task SetParametersAsync(ParameterView parameters)
    {
        // Reset the data source wrapper when parameters change to force fresh data load
        this._dataSourceWrapper = null;
        
        // Force the underlying AccountData source to discard cached data and reload from database
        await this.AccountData.DiscardChangesAsync().ConfigureAwait(true);
        
        await base.SetParametersAsync(parameters).ConfigureAwait(true);
    }

    /// <inheritdoc />
    protected override async ValueTask LoadOwnerAsync(CancellationToken cancellationToken)
    {
        await this.AccountData.GetOwnerAsync(this.AccountId, cancellationToken).ConfigureAwait(true);
    }

    /// <inheritdoc />
    protected override void AddFormToRenderTree(RenderTreeBuilder builder, ref int currentSequence)
    {
        if (this.Type == typeof(Item))
        {
            builder.OpenComponent(++currentSequence, typeof(ItemEdit));
            builder.AddAttribute(++currentSequence, nameof(ItemEdit.Item), this.Model);
            builder.AddAttribute(++currentSequence, nameof(ItemEdit.OnValidSubmit), EventCallback.Factory.Create(this, this.SaveChangesAsync));
            builder.CloseComponent();
        }
        else if (this.Type == typeof(Account))
        {
            builder.OpenComponent(++currentSequence, typeof(AccountEdit));
            builder.AddAttribute(++currentSequence, nameof(AccountEdit.Account), this.Model);
            builder.AddAttribute(++currentSequence, nameof(AccountEdit.OnValidSubmit), EventCallback.Factory.Create(this, this.SaveChangesAsync));
            builder.CloseComponent();
        }
        else if (this.Type == typeof(Character))
        {
            // Get the Account to pass to CharacterEdit for vault access
            var account = this.AccountData.Get(this.AccountId) as Account;
            
            builder.OpenComponent(++currentSequence, typeof(CharacterEdit));
            builder.AddAttribute(++currentSequence, nameof(CharacterEdit.Character), this.Model);
            builder.AddAttribute(++currentSequence, nameof(CharacterEdit.Account), account);
            builder.AddAttribute(++currentSequence, nameof(CharacterEdit.OnValidSubmit), EventCallback.Factory.Create(this, this.SaveChangesAsync));
            builder.CloseComponent();
        }
        else
        {
            builder.OpenComponent(++currentSequence, typeof(AutoForm<>).MakeGenericType(this.Type!));
            builder.AddAttribute(++currentSequence, nameof(AutoForm<object>.Model), this.Model);
            builder.AddAttribute(++currentSequence, nameof(AutoForm<object>.OnValidSubmit), EventCallback.Factory.Create(this, this.SaveChangesAsync));
            builder.CloseComponent();
        }
    }

    /// <summary>
    /// Wrapper for AccountData that also supports Character and Item types by loading them from the Account.
    /// </summary>
    private class AccountDataSourceWrapper : IDataSource
    {
        private readonly IDataSource<Account> _accountData;
        private readonly Guid _accountId;

        public AccountDataSourceWrapper(IDataSource<Account> accountData, Guid accountId)
        {
            this._accountData = accountData;
            this._accountId = accountId;
        }

        public bool IsSupporting(Type type) =>
            type == typeof(Account) || type == typeof(Character) || type == typeof(Item);

        public IIdentifiable? Get(Guid id)
        {
            var account = this._accountData.Get(this._accountId) as Account;
            if (account is null)
            {
                return null;
            }

            // Check if the requested ID is the account itself
            if (account.GetId() == id)
            {
                return account as IIdentifiable;
            }

            // Try to find a character with this ID
            var character = account.Characters.FirstOrDefault(c => c.GetId() == id);
            if (character is not null)
            {
                return character as IIdentifiable;
            }

            // Try to find an item with this ID
            var item = account.Vault?.Items.FirstOrDefault(i => i.GetId() == id);
            return item as IIdentifiable;
        }

        public IEnumerable<T> GetAll<T>()
        {
            if (typeof(T) == typeof(Account))
            {
                return this._accountData.GetAll<T>();
            }

            var account = this._accountData.Get(this._accountId) as Account;
            if (account is null)
            {
                return Array.Empty<T>();
            }

            if (typeof(T) == typeof(Character))
            {
                return account.Characters.OfType<T>();
            }

            if (typeof(T) == typeof(Item) && account.Vault is not null)
            {
                return account.Vault.Items.OfType<T>();
            }

            return Array.Empty<T>();
        }

        public IEnumerable GetAll(Type type)
        {
            if (type == typeof(Account))
            {
                return this._accountData.GetAll(type);
            }

            var account = this._accountData.Get(this._accountId) as Account;
            if (account is null)
            {
                return Array.Empty<object>();
            }

            if (type == typeof(Character))
            {
                return account.Characters;
            }

            if (type == typeof(Item) && account.Vault is not null)
            {
                return account.Vault.Items;
            }

            return Array.Empty<object>();
        }

        public async ValueTask<IContext> GetContextAsync(CancellationToken cancellationToken = default)
        {
            return await this._accountData.GetContextAsync(cancellationToken).ConfigureAwait(false);
        }

        public async ValueTask<object> GetOwnerAsync(Guid ownerId = default, CancellationToken cancellationToken = default)
        {
            return (await this._accountData.GetOwnerAsync(ownerId, cancellationToken).ConfigureAwait(false))!;
        }

        public async ValueTask DiscardChangesAsync()
        {
            await this._accountData.DiscardChangesAsync().ConfigureAwait(false);
        }

        public void Dispose()
        {
            // The underlying account data source is managed by DI, so we don't dispose it here
        }
    }
}
