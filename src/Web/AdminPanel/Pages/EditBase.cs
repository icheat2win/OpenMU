// <copyright file="EditBase.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Web.AdminPanel.Pages;

using System.Reflection;
using System.Threading;
using Blazored.Modal.Services;
using Blazored.Toast.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Rendering;
using Microsoft.AspNetCore.Components.Routing;
using Microsoft.Extensions.Logging;
using Microsoft.JSInterop;
using MUnique.OpenMU.DataModel.Configuration;
using MUnique.OpenMU.Persistence;
using MUnique.OpenMU.Web.AdminPanel;
using MUnique.OpenMU.Web.AdminPanel.Services;

/// <summary>
/// Abstract common base class for an edit page.
/// </summary>
public abstract class EditBase : ComponentBase, IAsyncDisposable
{
    private object? _model;
    private Type? _type;
    private bool _isOwningContext;
    private IContext? _persistenceContext;
    private CancellationTokenSource? _disposeCts;
    private DataLoadingState _loadingState;
    private Task? _loadTask;
    private IDisposable? _modalDisposable;
    private IDisposable? _navigationLockDisposable;

    private enum DataLoadingState
    {
        NotLoadedYet,

        LoadingStarted,

        Loading,

        Loaded,

        NotFound,

        Error,

        Cancelled,
    }

    /// <summary>
    /// Gets or sets the identifier of the object which should be edited.
    /// </summary>
    [Parameter]
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the <see cref="Type.FullName"/> of the object which should be edited.
    /// </summary>
    [Parameter]
    public string TypeString { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the persistence context provider which loads and saves the object.
    /// </summary>
    [Inject]
    public IPersistenceContextProvider PersistenceContextProvider { get; set; } = null!;

    /// <summary>
    /// Gets or sets the modal service.
    /// </summary>
    [Inject]
    public IModalService ModalService { get; set; } = null!;

    /// <summary>
    /// Gets or sets the toast service.
    /// </summary>
    [Inject]
    public IToastService ToastService { get; set; } = null!;

    /// <summary>
    /// Gets or sets the configuration data source.
    /// </summary>
    [Inject]
    public IDataSource<GameConfiguration> ConfigDataSource { get; set; } = null!;

    /// <summary>
    /// Gets or sets the navigation manager.
    /// </summary>
    [Inject]
    public NavigationManager NavigationManager { get; set; } = null!;

    /// <summary>
    /// Gets or sets the navigation history.
    /// </summary>
    [Inject]
    public NavigationHistory NavigationHistory { get; set; } = null!;

    /// <summary>
    /// Gets or sets the java script runtime.
    /// </summary>
    [Inject]
    public IJSRuntime JavaScript { get; set; } = null!;

    /// <summary>
    /// Gets or sets the logger.
    /// </summary>
    [Inject]
    public ILogger<EditBase>? Logger { get; set; }

    /// <summary>
    /// Gets the data source of the type which is edited.
    /// </summary>
    protected virtual IDataSource EditDataSource => this.ConfigDataSource;

    /// <summary>
    /// Gets the model which should be edited.
    /// </summary>
    protected object? Model => this._model;

    /// <summary>
    /// Gets the type.
    /// </summary>
    protected virtual Type? Type => this._type ??= this.DetermineTypeByTypeString();

    /// <inheritdoc />
    public async ValueTask DisposeAsync()
    {
        this._navigationLockDisposable?.Dispose();
        this._navigationLockDisposable = null;

        await (this._disposeCts?.CancelAsync() ?? Task.CompletedTask).ConfigureAwait(false);
        this._disposeCts?.Dispose();
        this._disposeCts = null;

        await (this._loadTask ?? Task.CompletedTask).ConfigureAwait(false);
        await this.EditDataSource.DiscardChangesAsync().ConfigureAwait(true);

        if (this._isOwningContext)
        {
            this._persistenceContext?.Dispose();
        }

        this._persistenceContext = null;
    }

    /// <inheritdoc />
    public override async Task SetParametersAsync(ParameterView parameters)
    {
        this._model = null;
        await (this._disposeCts?.CancelAsync() ?? Task.CompletedTask).ConfigureAwait(false);
        this._disposeCts?.Dispose();
        await (this._loadTask ?? Task.CompletedTask).ConfigureAwait(true);
        await base.SetParametersAsync(parameters).ConfigureAwait(true);
    }

    /// <inheritdoc />
    protected override async Task OnParametersSetAsync()
    {
        this._loadingState = DataLoadingState.LoadingStarted;
        var cts = new CancellationTokenSource();
        this._disposeCts = cts;
        this._type = null;
        this._loadTask = Task.Run(() => this.LoadDataAsync(cts.Token), cts.Token);

        await base.OnParametersSetAsync().ConfigureAwait(true);
    }

    /// <inheritdoc />
    protected override void BuildRenderTree(RenderTreeBuilder builder)
    {
        if (this.Model is null)
        {
            return;
        }

        var downloadMarkup = this.GetDownloadMarkup();
        var editorsMarkup = this.GetEditorsMarkup();

        // Modern Tailwind v4 styled page with gradient background
        var typeName = this.Type?.Name ?? "Configuration";
        var pageHeader = $@"
            <div class=""mb-8 flex flex-col md:flex-row md:items-center md:justify-between gap-4"">
                <div class=""flex items-center gap-4"">
                    <div class=""p-4 bg-gradient-to-br from-blue-500 to-purple-600 rounded-2xl shadow-lg"">
                        <span class=""oi oi-wrench text-white text-3xl"" aria-hidden=""true""></span>
                    </div>
                    <div>
                        <h1 class=""text-4xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600 dark:from-blue-400 dark:to-purple-400 mb-1"">
                            {typeName}
                        </h1>
                        <p class=""text-slate-600 dark:text-slate-400 text-lg"">Configure and manage system settings</p>
                    </div>
                </div>
                <button 
                    onclick=""window.history.back()"" 
                    title=""Go back""
                    class=""inline-flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-slate-600 to-slate-700 hover:from-slate-700 hover:to-slate-800 text-white font-semibold rounded-xl shadow-lg hover:shadow-xl transition-all transform hover:scale-105"">
                    <span class=""oi oi-arrow-left text-xl"" aria-hidden=""true""></span>
                    <span>Back</span>
                </button>
            </div>";
        
        var actionsMarkup = downloadMarkup != null || editorsMarkup != null 
            ? $@"<div class=""mb-8 bg-white dark:bg-slate-800 rounded-xl shadow-lg border border-slate-200 dark:border-slate-700 p-6"">
                    <div class=""flex items-center gap-2 mb-4"">
                        <span class=""text-2xl"">⚡</span>
                        <h2 class=""text-xl font-bold text-slate-900 dark:text-white"">Quick Actions</h2>
                    </div>
                    <div class=""space-y-3"">
                        {downloadMarkup}
                        {editorsMarkup}
                    </div>
                </div>"
            : string.Empty;
        
        builder.AddMarkupContent(10, 
            $@"<div class=""min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-slate-50 dark:from-slate-900 dark:via-slate-800 dark:to-slate-900 py-8 px-4"">
                <div class=""max-w-7xl mx-auto"">
                    {pageHeader}
                    {actionsMarkup}
                    <div class=""bg-white dark:bg-slate-800 rounded-2xl shadow-2xl border border-slate-200 dark:border-slate-700 overflow-hidden"">
                        <div class=""bg-gradient-to-r from-slate-800 to-slate-700 dark:from-slate-700 dark:to-slate-600 p-6 border-b border-slate-600"">
                            <div class=""flex items-center gap-3"">
                                <span class=""text-2xl"">⚙️</span>
                                <h2 class=""text-2xl font-bold text-white"">Configuration Settings</h2>
                            </div>
                        </div>
                        <div class=""p-8"">");
        
        builder.OpenComponent<CascadingValue<IContext>>(11);
        builder.AddAttribute(12, nameof(CascadingValue<IContext>.Value), this._persistenceContext);
        builder.AddAttribute(13, nameof(CascadingValue<IContext>.IsFixed), this._isOwningContext);
        builder.AddAttribute(14, nameof(CascadingValue<IContext>.ChildContent), (RenderFragment)(builder2 =>
        {
            var sequence = 14;
            this.AddFormToRenderTree(builder2, ref sequence);
        }));

        builder.CloseComponent();
        
        // Close all container divs
        builder.AddMarkupContent(15, @"
                        </div>
                    </div>
                </div>
            </div>");
    }

    /// <inheritdoc />
    protected override Task OnInitializedAsync()
    {
        this._navigationLockDisposable = this.NavigationManager.RegisterLocationChangingHandler(this.OnBeforeInternalNavigationAsync);
        return base.OnInitializedAsync();
    }

    /// <summary>
    /// Adds the form to the render tree.
    /// </summary>
    /// <param name="builder">The builder.</param>
    /// <param name="currentSequence">The current sequence.</param>
    protected abstract void AddFormToRenderTree(RenderTreeBuilder builder, ref int currentSequence);

    /// <inheritdoc />
    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        if (this._loadingState is not DataLoadingState.Loading && this._modalDisposable is { } modal)
        {
            modal.Dispose();
            this._modalDisposable = null;
        }

        if (this._loadingState == DataLoadingState.LoadingStarted)
        {
            this._loadingState = DataLoadingState.Loading;

            await this.InvokeAsync(() =>
            {
                if (this._loadingState != DataLoadingState.Loaded)
                {
                    this._modalDisposable = this.ModalService.ShowLoadingIndicator();
                    this.StateHasChanged();
                }
            }).ConfigureAwait(false);
        }

        if (this._loadingState == DataLoadingState.Loaded && this.Model is { } model)
        {
            this.NavigationHistory.AddCurrentPageToHistory(model.GetName());
        }

        await base.OnAfterRenderAsync(firstRender).ConfigureAwait(true);
    }

    /// <summary>
    /// Saves the changes.
    /// </summary>
    protected async Task SaveChangesAsync()
    {
        try
        {
            if (this._persistenceContext is { } context)
            {
                var success = await context.SaveChangesAsync().ConfigureAwait(true);
                var text = success ? "The changes have been saved." : "There were no changes to save.";
                this.ToastService.ShowSuccess(text);
            }
            else
            {
                this.ToastService.ShowError("Failed, context not initialized");
            }
        }
        catch (Exception ex)
        {
            this.Logger?.LogError(ex, $"Error during saving {this.Id}");
            var text = $"An unexpected error occured: {ex.Message}.";
            this.ToastService.ShowError(text);
        }
    }

    /// <summary>
    /// Gets the optional editors markup for the current type.
    /// </summary>
    /// <returns>The optional editors markup for the current type.</returns>
    protected virtual string? GetEditorsMarkup()
    {
        return null;
    }

    /// <summary>
    /// It loads the owner of the <see cref="EditDataSource" />.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    protected virtual async ValueTask LoadOwnerAsync(CancellationToken cancellationToken)
    {
        await this.EditDataSource.GetOwnerAsync(Guid.Empty, cancellationToken).ConfigureAwait(true);
    }

    private async ValueTask OnBeforeInternalNavigationAsync(LocationChangingContext context)
    {
        if (this._persistenceContext?.HasChanges is true)
        {
            var isConfirmed = await this.JavaScript.InvokeAsync<bool>("window.confirm",
                    "There are unsaved changes. Are you sure you want to discard them?")
                .ConfigureAwait(true);

            if (!isConfirmed)
            {
                context.PreventNavigation();
            }
            else if (this._isOwningContext)
            {
                this._persistenceContext.Dispose();
                this._persistenceContext = null;
            }
            else
            {
                await this.EditDataSource.DiscardChangesAsync().ConfigureAwait(true);
            }
        }
    }

    private string? GetDownloadMarkup()
    {
        if (this.Type is not null && GenericControllerFeatureProvider.SupportedTypes.Any(t => t.Item1 == this.Type))
        {
            var uri = $"/download/{this.Type.Name}/{this.Type.Name}_{this.Id}.json";
            return $@"<div class=""flex items-center gap-3 p-4 bg-gradient-to-r from-emerald-50 to-green-50 dark:from-emerald-900/20 dark:to-green-900/20 rounded-lg border border-emerald-200 dark:border-emerald-800"">
                        <span class=""text-2xl"">💾</span>
                        <div class=""flex-1"">
                            <p class=""text-slate-900 dark:text-white font-semibold mb-1"">Download Configuration</p>
                            <p class=""text-slate-600 dark:text-slate-400 text-sm"">Export this configuration as JSON file</p>
                        </div>
                        <a href=""{uri}"" download class=""inline-flex items-center gap-2 px-5 py-2.5 bg-gradient-to-r from-emerald-500 to-green-500 hover:from-emerald-600 hover:to-green-600 text-white font-semibold rounded-xl shadow-lg hover:shadow-xl transition-all transform hover:scale-105"">
                            <span class=""oi oi-data-transfer-download text-lg""></span>
                            <span>Download JSON</span>
                        </a>
                      </div>";
        }

        return null;
    }

    private Type? DetermineTypeByTypeString()
    {
        return AppDomain.CurrentDomain.GetAssemblies().Where(assembly => assembly.FullName?.StartsWith(nameof(MUnique)) ?? false)
            .Select(assembly => assembly.GetType(this.TypeString)).FirstOrDefault(t => t != null);
    }

    private async Task LoadDataAsync(CancellationToken cancellationToken)
    {
        try
        {
            cancellationToken.ThrowIfCancellationRequested();
            if (this.Type is null)
            {
                throw new InvalidOperationException($"Only types of namespace {nameof(MUnique)} can be edited on this page.");
            }

            await this.LoadOwnerAsync(cancellationToken).ConfigureAwait(true);
            cancellationToken.ThrowIfCancellationRequested();
            if (this.EditDataSource.IsSupporting(this.Type))
            {
                this._isOwningContext = false;
                this._persistenceContext = await this.EditDataSource.GetContextAsync(cancellationToken).ConfigureAwait(true);
            }
            else
            {
                this._isOwningContext = true;
                var gameConfiguration = await this.ConfigDataSource.GetOwnerAsync(Guid.Empty, cancellationToken).ConfigureAwait(true);
                this._persistenceContext = this.PersistenceContextProvider.CreateNewTypedContext(this.Type, true, gameConfiguration);
            }

            cancellationToken.ThrowIfCancellationRequested();

            try
            {
                if (this.EditDataSource.IsSupporting(this.Type))
                {
                    this._model = this.Id == default
                        ? this.EditDataSource.GetAll(this.Type).OfType<object>().FirstOrDefault()
                        : this.EditDataSource.Get(this.Id);
                }
                else
                {
                    this._model = this.Id == default
                        ? (await this._persistenceContext.GetAsync(this.Type, cancellationToken).ConfigureAwait(true)).OfType<object>().FirstOrDefault()
                        : await this._persistenceContext.GetByIdAsync(this.Id, this.Type, cancellationToken).ConfigureAwait(true);
                }

                this._loadingState = this.Model is not null
                    ? DataLoadingState.Loaded
                    : DataLoadingState.NotFound;
            }
            catch (OperationCanceledException)
            {
                this._loadingState = DataLoadingState.Cancelled;
                throw;
            }
            catch (Exception ex)
            {
                this._loadingState = DataLoadingState.Error;
                this.Logger?.LogError(ex, $"Could not load {this.Type.FullName} with {this.Id}: {ex.Message}{Environment.NewLine}{ex.StackTrace}");
                await this.InvokeAsync(() => this.ModalService.ShowMessageAsync("Error", "Could not load the data. Check the logs for details.")).ConfigureAwait(false);
            }

            cancellationToken.ThrowIfCancellationRequested();
            await this.InvokeAsync(this.StateHasChanged).ConfigureAwait(true);
        }
        catch (OperationCanceledException)
        {
            // expected when the page is getting disposed.
        }
        catch (TargetInvocationException ex) when (ex.InnerException is ObjectDisposedException)
        {
            // See ObjectDisposedException.
        }
        catch (ObjectDisposedException)
        {
            // Happens when the user navigated away (shouldn't happen with the modal loading indicator, but we check it anyway).
            // It would be great to have an async api with cancellation token support in the persistence layer
            // For the moment, we swallow the exception
        }
        catch (Exception ex)
        {
            this.Logger?.LogError(ex, "Unexpected error when loading data: {ex}", ex);
        }
    }
}