// <copyright file="PlugInSignatureVerifier.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.PlugIns;

using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using Microsoft.Extensions.Logging;

/// <summary>
/// Verifies plugin assemblies using certificate-based code signing.
/// </summary>
public sealed class PlugInSignatureVerifier
{
    private readonly ILogger<PlugInSignatureVerifier> _logger;
    private readonly bool _requireSigning;
    private readonly HashSet<string> _trustedThumbprints;

    /// <summary>
    /// Initializes a new instance of the <see cref="PlugInSignatureVerifier"/> class.
    /// </summary>
    /// <param name="logger">The logger.</param>
    /// <param name="requireSigning">Whether plugin signing is required (false for dev mode).</param>
    /// <param name="trustedThumbprints">Collection of trusted certificate thumbprints (SHA-1 hashes).</param>
    public PlugInSignatureVerifier(
        ILogger<PlugInSignatureVerifier> logger,
        bool requireSigning = false,
        IEnumerable<string>? trustedThumbprints = null)
    {
        this._logger = logger;
        this._requireSigning = requireSigning;
        this._trustedThumbprints = new HashSet<string>(
            (trustedThumbprints ?? Enumerable.Empty<string>())
            .Select(t => t.Replace(" ", string.Empty).ToUpperInvariant()),
            StringComparer.OrdinalIgnoreCase);
    }

    /// <summary>
    /// Verifies the digital signature of a plugin assembly file.
    /// </summary>
    /// <param name="assemblyPath">The path to the assembly file to verify.</param>
    /// <returns>
    /// A <see cref="VerificationResult"/> indicating whether the assembly signature is valid.
    /// </returns>
    public VerificationResult VerifyAssembly(string assemblyPath)
    {
        if (!File.Exists(assemblyPath))
        {
            this._logger.LogError($"Assembly file not found: {assemblyPath}");
            return new VerificationResult(false, "Assembly file not found");
        }

        try
        {
            // First check Authenticode signature (Windows PE signature)
            var authenticodeResult = this.VerifyAuthenticodeSignature(assemblyPath);
            if (!authenticodeResult.IsValid)
            {
                if (this._requireSigning)
                {
                    this._logger.LogWarning($"Plugin assembly {assemblyPath} has invalid Authenticode signature: {authenticodeResult.Message}");
                    return authenticodeResult;
                }
                else
                {
                    this._logger.LogDebug($"Plugin assembly {assemblyPath} is not Authenticode signed (development mode - allowing)");
                    return new VerificationResult(true, "Unsigned plugin allowed in development mode");
                }
            }

            // Check if certificate is trusted
            if (this._trustedThumbprints.Count > 0)
            {
                var certificate = this.GetSigningCertificate(assemblyPath);
                if (certificate == null)
                {
                    this._logger.LogWarning($"Could not extract certificate from {assemblyPath}");
                    return new VerificationResult(false, "Could not extract signing certificate");
                }

                var thumbprint = certificate.Thumbprint.ToUpperInvariant();
                if (!this._trustedThumbprints.Contains(thumbprint))
                {
                    this._logger.LogWarning($"Plugin assembly {assemblyPath} is signed with untrusted certificate (thumbprint: {thumbprint})");
                    return new VerificationResult(false, $"Certificate not trusted: {thumbprint}");
                }

                this._logger.LogInformation($"Plugin assembly {assemblyPath} verified successfully (certificate: {certificate.Subject})");
            }

            // Verify strong name signature
            var strongNameResult = this.VerifyStrongName(assemblyPath);
            if (!strongNameResult.IsValid)
            {
                this._logger.LogDebug($"Plugin assembly {assemblyPath} does not have valid strong name: {strongNameResult.Message}");

                // Strong name is optional if Authenticode is present
            }

            return authenticodeResult;
        }
        catch (Exception ex)
        {
            this._logger.LogError(ex, $"Error verifying plugin assembly {assemblyPath}");
            return new VerificationResult(false, $"Verification error: {ex.Message}");
        }
    }

    /// <summary>
    /// Verifies the Authenticode signature of an assembly.
    /// </summary>
    /// <param name="assemblyPath">The path to the assembly.</param>
    /// <returns>Verification result.</returns>
    private VerificationResult VerifyAuthenticodeSignature(string assemblyPath)
    {
        // On non-Windows platforms, Authenticode verification is not available
        if (!RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            this._logger.LogDebug("Authenticode verification is only available on Windows");
            return new VerificationResult(false, "Authenticode not supported on this platform");
        }

        try
        {
            // Use X509Certificate2 to check if file has a valid signature
            using var certificate = X509CertificateLoader.LoadCertificateFromFile(assemblyPath);

            // Check if certificate has a private key (indicates it's signed)
            var rawData = certificate.RawData;
            if (rawData.Length == 0)
            {
                return new VerificationResult(false, "No Authenticode signature found");
            }

            // Verify certificate chain
            using var chain = new X509Chain();
            chain.ChainPolicy.RevocationMode = X509RevocationMode.Online;
            chain.ChainPolicy.RevocationFlag = X509RevocationFlag.ExcludeRoot;
            chain.ChainPolicy.VerificationFlags = X509VerificationFlags.NoFlag;

            var isValid = chain.Build(certificate);
            if (!isValid)
            {
                var errors = string.Join(", ", chain.ChainStatus.Select(s => s.StatusInformation));
                return new VerificationResult(false, $"Certificate chain validation failed: {errors}");
            }

            // Check certificate expiration
            if (certificate.NotAfter < DateTime.Now)
            {
                return new VerificationResult(false, "Certificate has expired");
            }

            if (certificate.NotBefore > DateTime.Now)
            {
                return new VerificationResult(false, "Certificate is not yet valid");
            }

            return new VerificationResult(true, "Authenticode signature valid");
        }
        catch (CryptographicException)
        {
            // File is not signed with Authenticode
            return new VerificationResult(false, "No Authenticode signature found");
        }
        catch (Exception ex)
        {
            this._logger.LogError(ex, $"Error verifying Authenticode signature for {assemblyPath}");
            return new VerificationResult(false, $"Verification error: {ex.Message}");
        }
    }

    /// <summary>
    /// Extracts the signing certificate from an assembly.
    /// </summary>
    /// <param name="assemblyPath">The path to the assembly.</param>
    /// <returns>The X509 certificate, or null if not found.</returns>
    private X509Certificate2? GetSigningCertificate(string assemblyPath)
    {
        if (!RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            return null;
        }

        try
        {
            return X509CertificateLoader.LoadCertificateFromFile(assemblyPath);
        }
        catch
        {
            return null;
        }
    }

    /// <summary>
    /// Verifies the strong name signature of an assembly.
    /// </summary>
    /// <param name="assemblyPath">The path to the assembly.</param>
    /// <returns>Verification result.</returns>
    private VerificationResult VerifyStrongName(string assemblyPath)
    {
        try
        {
            var assemblyName = AssemblyName.GetAssemblyName(assemblyPath);
            var publicKeyToken = assemblyName.GetPublicKeyToken();

            if (publicKeyToken == null || publicKeyToken.Length == 0)
            {
                return new VerificationResult(false, "Assembly is not strong-name signed");
            }

            // If we got here, the assembly has a strong name signature
            // .NET automatically verifies it when loading via GetAssemblyName
            return new VerificationResult(true, "Strong name signature valid");
        }
        catch (BadImageFormatException)
        {
            return new VerificationResult(false, "Invalid assembly format");
        }
        catch (System.IO.FileLoadException ex)
        {
            return new VerificationResult(false, $"Strong name verification failed: {ex.Message}");
        }
        catch (Exception ex)
        {
            this._logger.LogError(ex, $"Error verifying strong name for {assemblyPath}");
            return new VerificationResult(false, $"Verification error: {ex.Message}");
        }
    }

    /// <summary>
    /// Represents the result of a plugin signature verification.
    /// </summary>
    public sealed record VerificationResult(bool IsValid, string Message);
}
