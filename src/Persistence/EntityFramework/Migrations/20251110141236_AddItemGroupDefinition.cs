using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MUnique.OpenMU.Persistence.EntityFramework.Migrations
{
    /// <inheritdoc />
    public partial class AddItemGroupDefinition : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "ItemGroupId",
                schema: "config",
                table: "ItemDefinition",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "ItemGroupDefinition",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Number = table.Column<byte>(type: "smallint", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    GameConfigurationId = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ItemGroupDefinition", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ItemGroupDefinition_GameConfiguration_GameConfigurationId",
                        column: x => x.GameConfigurationId,
                        principalSchema: "config",
                        principalTable: "GameConfiguration",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_ItemDefinition_ItemGroupId",
                schema: "config",
                table: "ItemDefinition",
                column: "ItemGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_ItemGroupDefinition_GameConfigurationId",
                table: "ItemGroupDefinition",
                column: "GameConfigurationId");

            migrationBuilder.AddForeignKey(
                name: "FK_ItemDefinition_ItemGroupDefinition_ItemGroupId",
                schema: "config",
                table: "ItemDefinition",
                column: "ItemGroupId",
                principalTable: "ItemGroupDefinition",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ItemDefinition_ItemGroupDefinition_ItemGroupId",
                schema: "config",
                table: "ItemDefinition");

            migrationBuilder.DropTable(
                name: "ItemGroupDefinition");

            migrationBuilder.DropIndex(
                name: "IX_ItemDefinition_ItemGroupId",
                schema: "config",
                table: "ItemDefinition");

            migrationBuilder.DropColumn(
                name: "ItemGroupId",
                schema: "config",
                table: "ItemDefinition");
        }
    }
}
