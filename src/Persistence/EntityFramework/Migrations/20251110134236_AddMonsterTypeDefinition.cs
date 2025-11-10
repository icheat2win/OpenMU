using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MUnique.OpenMU.Persistence.EntityFramework.Migrations
{
    /// <inheritdoc />
    public partial class AddMonsterTypeDefinition : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "MonsterTypeId",
                schema: "config",
                table: "MonsterDefinition",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "MonsterTypeDefinition",
                schema: "config",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    GameConfigurationId = table.Column<Guid>(type: "uuid", nullable: true),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    BehaviorType = table.Column<int>(type: "integer", nullable: false),
                    MovementPattern = table.Column<int>(type: "integer", nullable: false),
                    AttackPattern = table.Column<int>(type: "integer", nullable: false),
                    IsAggressive = table.Column<bool>(type: "boolean", nullable: false),
                    CanRespawn = table.Column<bool>(type: "boolean", nullable: false),
                    IsTargetable = table.Column<bool>(type: "boolean", nullable: false),
                    AggroMultiplier = table.Column<float>(type: "real", nullable: false),
                    ExperienceMultiplier = table.Column<float>(type: "real", nullable: false),
                    DropRateMultiplier = table.Column<float>(type: "real", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MonsterTypeDefinition", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MonsterTypeDefinition_GameConfiguration_GameConfigurationId",
                        column: x => x.GameConfigurationId,
                        principalSchema: "config",
                        principalTable: "GameConfiguration",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_MonsterDefinition_MonsterTypeId",
                schema: "config",
                table: "MonsterDefinition",
                column: "MonsterTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_MonsterTypeDefinition_GameConfigurationId",
                schema: "config",
                table: "MonsterTypeDefinition",
                column: "GameConfigurationId");

            migrationBuilder.AddForeignKey(
                name: "FK_MonsterDefinition_MonsterTypeDefinition_MonsterTypeId",
                schema: "config",
                table: "MonsterDefinition",
                column: "MonsterTypeId",
                principalSchema: "config",
                principalTable: "MonsterTypeDefinition",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_MonsterDefinition_MonsterTypeDefinition_MonsterTypeId",
                schema: "config",
                table: "MonsterDefinition");

            migrationBuilder.DropTable(
                name: "MonsterTypeDefinition",
                schema: "config");

            migrationBuilder.DropIndex(
                name: "IX_MonsterDefinition_MonsterTypeId",
                schema: "config",
                table: "MonsterDefinition");

            migrationBuilder.DropColumn(
                name: "MonsterTypeId",
                schema: "config",
                table: "MonsterDefinition");
        }
    }
}
