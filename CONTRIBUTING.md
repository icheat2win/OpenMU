# Contributing to OpenMU

Thank you for your interest in contributing to OpenMU! This guide will help you get started with contributing to this open-source MU Online server implementation.

## Contribution Guidelines

Contributions are welcome if they meet the following criteria:

* Language is English.
* Code should be StyleCop compliant - this project uses [StyleCop.Analyzers](https://www.nuget.org/packages/StyleCop.Analyzers/) so you should see issues directly as warnings.
* Coding style (naming, etc.) and quality should fit to the current state.
* **No code copied/converted** from the well-known decompiled source of the original server.

If you want to contribute, please create a new issue for the feature or bug (if the issue doesn't exist yet) so we can see who is working on something and can discuss possible solutions. If it's a small thing, you can also just send a pull request without adding an issue.

Apart from that, contributions from non-developers are welcome as well. You can test the server, submit issues or suggestions, packet descriptions or documentations about the concepts and mechanics of the game itself. Please use markdown files/syntax for this purpose.

If you have questions, don't hesitate to ask in our [discord channel](https://discord.gg/2u5Agkd) or by submitting an issue.

## Table of Contents

- [How to Contribute Code](#how-to-contribute-code)
- [Development Environment Setup](#development-environment-setup)
- [Architecture Overview](#architecture-overview)
- [Coding Standards](#coding-standards)
- [Adding New Features](#adding-new-features)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)

## How to Contribute Code

If you want to contribute code, please do the following steps:

1. Fork this project from the original MUnique OpenMU Project.
2. Create a feature branch from the master branch.
3. Commit your changes to your feature branch.
4. Submit a pull request to the original master branch.
5. Lean back, wait for the code review and merge :)

## Development Environment Setup

### Prerequisites

- **.NET 9.0 SDK** or later
- **Visual Studio 2022** (recommended) or Visual Studio Code
- **PostgreSQL** or **SQL Server** database
- **Git** for version control

### Getting Started

1. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/OpenMU.git
   cd OpenMU
   ```

2. **Configure database**
   - Create a PostgreSQL or SQL Server database
   - Update connection string in `src/Startup/appsettings.json`

3. **Build and run**
   ```bash
   dotnet build
   dotnet test
   cd src/Startup
   dotnet run
   ```

## Architecture Overview

OpenMU follows a **plugin-based architecture** with clean separation of concerns:

### Project Structure

```
OpenMU/
├── src/
│   ├── AdminPanel/          # Web-based administration interface
│   ├── DataModel/           # Core data models and configurations
│   ├── GameLogic/           # Game mechanics and rules
│   ├── GameServer/          # Network layer and client communication
│   │   ├── MessageHandler/  # Packet handlers (200+ plugins)
│   │   └── RemoteView/      # Response serializers (490+ plugins)
│   ├── Persistence/         # Database access and initialization
│   └── Startup/             # Application entry point
└── tests/                   # Unit and integration tests
```

### Key Components

#### Message Handlers (Packet Handlers)

Process incoming client requests:

```csharp
[PlugIn("Item Pick Up Handler", "Handles item pickup requests.")]
[Guid("12345678-1234-1234-1234-123456789ABC")]
public class PickupItemHandlerPlugIn : IPacketHandlerPlugIn
{
    public bool IsEncryptionExpected => false;
    public byte Key => 0x22;  // Packet ID

    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        var itemId = packet.Span[3..5].MakeWord();
        await player.PickupItemAsync(itemId);
    }
}
```

#### Remote Views (Response Plugins)

Send responses back to clients:

```csharp
[PlugIn("Item Picked Up", "Sends item pickup result to client.")]
[Guid("87654321-4321-4321-4321-210987654321")]
public class ItemPickedUpPlugIn : IViewPlugIn
{
    public async ValueTask SendItemPickedUpAsync(Player player, Item item)
    {
        using var writer = player.Connection.StartSafeWrite(0xC3, 10);
        var packet = writer.Span;
        packet[2] = 0x22;  // Packet ID
        // ... fill packet data
        await player.Connection.SendAsync(writer.Memory);
    }
}
```

## Coding Standards

### C# Style Guidelines

We follow **Microsoft's C# Coding Conventions**:

#### Naming Conventions

- **PascalCase**: Classes, methods, properties, namespaces
- **camelCase**: Local variables, parameters
- **_camelCase**: Private fields (underscore prefix optional)

#### Code Organization

```csharp
using System;
using MUnique.OpenMU.GameLogic;

namespace MUnique.OpenMU.GameServer.MessageHandler;

/// <summary>
/// Handles item pickup requests from the client.
/// </summary>
public class PickupItemHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly ILogger _logger;

    public PickupItemHandlerPlugIn(ILogger<PickupItemHandlerPlugIn> logger)
    {
        this._logger = logger;
    }

    public byte Key => 0x22;

    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        // Implementation
    }
}
```

#### Best Practices

1. **Use meaningful names** - Code should be self-documenting
2. **Keep methods small** - One responsibility per method
3. **Use async/await properly** - Avoid blocking calls
4. **Handle exceptions gracefully** - Log and inform user
5. **Use XML documentation** - Document public APIs

### StyleCop Compliance

We use StyleCop for code analysis. Build warnings will appear for violations, but **they don't fail the build**. Please try to fix StyleCop warnings in your code.

Common rules:
- SA1633: File must have header
- SA1101: Prefix local calls with `this`
- SA1600: Elements must be documented

## Adding New Features

### Adding a Packet Handler

1. **Create handler in appropriate folder** - `src/GameServer/MessageHandler/[FeatureArea]/`
2. **Implement IPacketHandlerPlugIn**
3. **Add PlugIn attribute with GUID**
4. **Extract packet data and validate**
5. **Call game logic methods**
6. **Send response via view plugins**

### Adding a Game Mechanic

1. **Add to GameLogic project** - `src/GameLogic/`
2. **Define interfaces** for testability
3. **Implement business logic**
4. **Wire up packet handlers**
5. **Add response plugins**

### Adding Database Entities

1. **Add to DataModel project**
2. **Add DbSet to Context**
3. **Create migration**: `dotnet ef migrations add [Name]`
4. **Test migration**

## Testing

### Unit Tests

Place in `tests/MUnique.OpenMU.Tests/`:

```csharp
[TestFixture]
public class MyFeatureTests
{
    [Test]
    public async Task MyMethod_ValidInput_ReturnsExpected()
    {
        // Arrange
        var sut = new MyFeature();

        // Act
        var result = await sut.MyMethodAsync(input);

        // Assert
        Assert.That(result, Is.EqualTo(expected));
    }
}
```

### Running Tests

```bash
dotnet test                    # Run all tests
dotnet test --filter MyTests   # Run specific tests
```

## Pull Request Process

### Commit Guidelines

Write clear, descriptive commit messages:

```bash
git commit -m "Add item crafting system

- Implemented crafting logic in GameLogic
- Added packet handler for craft requests
- Added response plugin for craft results
- Added unit tests
- Updated documentation"
```

### PR Description Template

```markdown
## Description
Brief description of changes.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update

## Testing
- [ ] Unit tests added
- [ ] Manually tested

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests pass locally
```

### Review Process

1. **Automated checks** - CI builds and runs tests
2. **Maintainer review** - Code quality and design review
3. **Address feedback** - Make requested changes
4. **Approval & merge** - Once approved, PR will be merged

## Additional Resources

- [README.md](README.md) - Project overview
- [PROJECT_STATUS_FINAL.md](PROJECT_STATUS_FINAL.md) - Detailed status and roadmap
- [QuickStart.md](QuickStart.md) - Quick start guide
- [Discord Channel](https://discord.gg/2u5Agkd) - Community support

## Recognition

We value all contributions! Contributors will be credited in release notes and the project's contributors page.

## License

By contributing to OpenMU, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to OpenMU! 🚀
