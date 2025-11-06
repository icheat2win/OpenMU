// <copyright file="Program.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Network.Analyzer;

using System.Windows.Forms;

/// <summary>
/// The class of the main entry point.
/// </summary>
internal static class Program
{
    /// <summary>
    /// The main entry point for the application.
    /// </summary>
    [STAThread]
    internal static void Main()
    {
        AppDomain.CurrentDomain.UnhandledException += OnUnhandledException;
        Application.EnableVisualStyles();
        Application.SetCompatibleTextRenderingDefault(false);
        Application.Run(new MainForm());
    }

    private static void OnUnhandledException(object sender, UnhandledExceptionEventArgs e)
    {
        var exception = e.ExceptionObject as Exception;
        var message = exception?.ToString() ?? e.ExceptionObject?.ToString() ?? "Unknown error";
        
        MessageBox.Show(
            $"An unhandled exception occurred:\n\n{message}",
            "Network Analyzer - Fatal Error",
            MessageBoxButtons.OK,
            MessageBoxIcon.Error);
    }
}