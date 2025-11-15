#!/bin/sh
set -e

# Ensure logs directory has correct permissions
if [ -d "/logs" ]; then
    # Check if running as root
    if [ "$(id -u)" = "0" ]; then
        chown -R app:app /logs
        chmod -R 755 /logs
        # Switch to app user and run the application
        exec su-exec app dotnet MUnique.OpenMU.Startup.dll "$@"
    else
        # Already running as app user, just fix permissions if possible
        chmod -R 755 /logs 2>/dev/null || true
    fi
fi

# Start the application
exec dotnet MUnique.OpenMU.Startup.dll "$@"
