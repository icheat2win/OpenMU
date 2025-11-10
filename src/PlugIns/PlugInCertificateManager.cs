// <copyright file="PlugInCertificateManager.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.PlugIns;

using System.Collections.ObjectModel;
using System.IO;
using System.Security.Cryptography.X509Certificates;
using Microsoft.Extensions.Logging;

/// <summary>
/// Manages trusted certificates for plugin code signing verification.
/// </summary>
public sealed class PlugInCertificateManager
{
    private readonly ILogger<PlugInCertificateManager> _logger;
    private readonly HashSet<string> _trustedThumbprints;
    private readonly object _lock = new();

    /// <summary>
    /// Initializes a new instance of the <see cref="PlugInCertificateManager"/> class.
    /// </summary>
    /// <param name="logger">The logger.</param>
    public PlugInCertificateManager(ILogger<PlugInCertificateManager> logger)
    {
        this._logger = logger;
        this._trustedThumbprints = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
    }

    /// <summary>
    /// Gets the collection of trusted certificate thumbprints.
    /// </summary>
    public IReadOnlyCollection<string> TrustedThumbprints
    {
        get
        {
            lock (this._lock)
            {
                return new ReadOnlyCollection<string>(this._trustedThumbprints.ToList());
            }
        }
    }

    /// <summary>
    /// Adds a trusted certificate by its thumbprint.
    /// </summary>
    /// <param name="thumbprint">The certificate thumbprint (SHA-1 hash).</param>
    /// <returns>True if the thumbprint was added; false if it was already present.</returns>
    public bool AddTrustedCertificate(string thumbprint)
    {
        if (string.IsNullOrWhiteSpace(thumbprint))
        {
            throw new ArgumentException("Thumbprint cannot be null or empty", nameof(thumbprint));
        }

        var normalizedThumbprint = thumbprint.Replace(" ", string.Empty).ToUpperInvariant();

        lock (this._lock)
        {
            var added = this._trustedThumbprints.Add(normalizedThumbprint);
            if (added)
            {
                this._logger.LogInformation($"Added trusted certificate: {normalizedThumbprint}");
            }

            return added;
        }
    }

    /// <summary>
    /// Adds a trusted certificate from a certificate file.
    /// </summary>
    /// <param name="certificatePath">The path to the certificate file (.cer, .crt, .pem).</param>
    /// <returns>The thumbprint of the added certificate.</returns>
    public string AddTrustedCertificateFromFile(string certificatePath)
    {
        if (!File.Exists(certificatePath))
        {
            throw new FileNotFoundException("Certificate file not found", certificatePath);
        }

        try
        {
            using var certificate = X509CertificateLoader.LoadCertificateFromFile(certificatePath);
            var thumbprint = certificate.Thumbprint;

            this.AddTrustedCertificate(thumbprint);

            this._logger.LogInformation($"Loaded certificate from {certificatePath}: {certificate.Subject} (thumbprint: {thumbprint})");

            return thumbprint;
        }
        catch (Exception ex)
        {
            this._logger.LogError(ex, $"Failed to load certificate from {certificatePath}");
            throw;
        }
    }

    /// <summary>
    /// Removes a trusted certificate by its thumbprint.
    /// </summary>
    /// <param name="thumbprint">The certificate thumbprint to remove.</param>
    /// <returns>True if the thumbprint was removed; false if it was not present.</returns>
    public bool RemoveTrustedCertificate(string thumbprint)
    {
        if (string.IsNullOrWhiteSpace(thumbprint))
        {
            throw new ArgumentException("Thumbprint cannot be null or empty", nameof(thumbprint));
        }

        var normalizedThumbprint = thumbprint.Replace(" ", string.Empty).ToUpperInvariant();

        lock (this._lock)
        {
            var removed = this._trustedThumbprints.Remove(normalizedThumbprint);
            if (removed)
            {
                this._logger.LogInformation($"Removed trusted certificate: {normalizedThumbprint}");
            }

            return removed;
        }
    }

    /// <summary>
    /// Checks if a certificate thumbprint is trusted.
    /// </summary>
    /// <param name="thumbprint">The certificate thumbprint to check.</param>
    /// <returns>True if the certificate is trusted; otherwise false.</returns>
    public bool IsCertificateTrusted(string thumbprint)
    {
        if (string.IsNullOrWhiteSpace(thumbprint))
        {
            return false;
        }

        var normalizedThumbprint = thumbprint.Replace(" ", string.Empty).ToUpperInvariant();

        lock (this._lock)
        {
            return this._trustedThumbprints.Contains(normalizedThumbprint);
        }
    }

    /// <summary>
    /// Clears all trusted certificates.
    /// </summary>
    public void ClearTrustedCertificates()
    {
        lock (this._lock)
        {
            var count = this._trustedThumbprints.Count;
            this._trustedThumbprints.Clear();
            this._logger.LogInformation($"Cleared {count} trusted certificates");
        }
    }

    /// <summary>
    /// Loads trusted certificates from a configuration file.
    /// </summary>
    /// <param name="configPath">The path to the configuration file containing thumbprints (one per line).</param>
    /// <returns>The number of certificates loaded.</returns>
    public int LoadTrustedCertificatesFromConfig(string configPath)
    {
        if (!File.Exists(configPath))
        {
            this._logger.LogWarning($"Certificate configuration file not found: {configPath}");
            return 0;
        }

        try
        {
            var lines = File.ReadAllLines(configPath);
            var count = 0;

            foreach (var line in lines)
            {
                var trimmed = line.Trim();
                if (string.IsNullOrEmpty(trimmed) || trimmed.StartsWith('#'))
                {
                    continue; // Skip empty lines and comments
                }

                if (this.AddTrustedCertificate(trimmed))
                {
                    count++;
                }
            }

            this._logger.LogInformation($"Loaded {count} trusted certificates from {configPath}");
            return count;
        }
        catch (Exception ex)
        {
            this._logger.LogError(ex, $"Failed to load trusted certificates from {configPath}");
            throw;
        }
    }

    /// <summary>
    /// Saves trusted certificates to a configuration file.
    /// </summary>
    /// <param name="configPath">The path to save the configuration file.</param>
    public void SaveTrustedCertificatesToConfig(string configPath)
    {
        try
        {
            lock (this._lock)
            {
                var lines = new List<string>
                {
                    "# Trusted certificate thumbprints for plugin code signing",
                    "# One thumbprint per line. Lines starting with # are comments.",
                    string.Empty,
                };

                lines.AddRange(this._trustedThumbprints.OrderBy(t => t));

                File.WriteAllLines(configPath, lines);

                this._logger.LogInformation($"Saved {this._trustedThumbprints.Count} trusted certificates to {configPath}");
            }
        }
        catch (Exception ex)
        {
            this._logger.LogError(ex, $"Failed to save trusted certificates to {configPath}");
            throw;
        }
    }
}
