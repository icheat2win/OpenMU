using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MUnique.OpenMU.Persistence.EntityFramework.Migrations
{
    /// <inheritdoc />
    public partial class AddCashShopCategoryTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "BlessJewelDropCount",
                schema: "config",
                table: "MiniGameDefinition",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "SoulJewelDropCount",
                schema: "config",
                table: "MiniGameDefinition",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<Guid>(
                name: "LearnableSkillId",
                schema: "config",
                table: "ItemDefinition",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "PetLeadershipFormula",
                schema: "config",
                table: "ItemDefinition",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "WearableSkillId",
                schema: "config",
                table: "ItemDefinition",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "GiftMessage",
                schema: "data",
                table: "Item",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Description",
                schema: "config",
                table: "GameServerConfiguration",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<bool>(
                name: "DisablePartySummon",
                schema: "config",
                table: "GameMapDefinition",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<Guid>(
                name: "CashShopStorageId",
                schema: "data",
                table: "Character",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "MinimumValuePerItemLevel",
                schema: "config",
                table: "AttributeRequirement",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "GoblinPoints",
                schema: "data",
                table: "Account",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "WCoinC",
                schema: "data",
                table: "Account",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "WCoinP",
                schema: "data",
                table: "Account",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "CashShopCategory",
                schema: "config",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    GameConfigurationId = table.Column<Guid>(type: "uuid", nullable: true),
                    CategoryId = table.Column<int>(type: "integer", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    IconId = table.Column<string>(type: "text", nullable: true),
                    DisplayOrder = table.Column<int>(type: "integer", nullable: false),
                    IsVisible = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CashShopCategory", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CashShopCategory_GameConfiguration_GameConfigurationId",
                        column: x => x.GameConfigurationId,
                        principalSchema: "config",
                        principalTable: "GameConfiguration",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "CashShopTransaction",
                schema: "data",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AccountId = table.Column<Guid>(type: "uuid", nullable: true),
                    AccountId1 = table.Column<Guid>(type: "uuid", nullable: true),
                    ProductId = table.Column<int>(type: "integer", nullable: false),
                    Amount = table.Column<int>(type: "integer", nullable: false),
                    CoinType = table.Column<byte>(type: "smallint", nullable: false),
                    Timestamp = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    TransactionType = table.Column<int>(type: "integer", nullable: false),
                    CharacterName = table.Column<string>(type: "text", nullable: false),
                    ReceiverName = table.Column<string>(type: "text", nullable: true),
                    Success = table.Column<bool>(type: "boolean", nullable: false),
                    Notes = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CashShopTransaction", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CashShopTransaction_Account_AccountId",
                        column: x => x.AccountId,
                        principalSchema: "data",
                        principalTable: "Account",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CashShopTransaction_Account_AccountId1",
                        column: x => x.AccountId1,
                        principalSchema: "data",
                        principalTable: "Account",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "CashShopProduct",
                schema: "config",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    ItemId = table.Column<Guid>(type: "uuid", nullable: true),
                    CategoryObjectId = table.Column<Guid>(type: "uuid", nullable: true),
                    GameConfigurationId = table.Column<Guid>(type: "uuid", nullable: true),
                    ProductId = table.Column<int>(type: "integer", nullable: false),
                    PriceWCoinC = table.Column<int>(type: "integer", nullable: false),
                    PriceWCoinP = table.Column<int>(type: "integer", nullable: false),
                    PriceGoblinPoints = table.Column<int>(type: "integer", nullable: false),
                    Quantity = table.Column<byte>(type: "smallint", nullable: false),
                    ItemLevel = table.Column<byte>(type: "smallint", nullable: false),
                    ItemOptionLevel = table.Column<byte>(type: "smallint", nullable: false),
                    Durability = table.Column<byte>(type: "smallint", nullable: false),
                    IsAvailable = table.Column<bool>(type: "boolean", nullable: false),
                    AvailableFrom = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    AvailableUntil = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    IsEventItem = table.Column<bool>(type: "boolean", nullable: false),
                    Category = table.Column<string>(type: "text", nullable: false),
                    DisplayName = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CashShopProduct", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CashShopProduct_CashShopCategory_CategoryObjectId",
                        column: x => x.CategoryObjectId,
                        principalSchema: "config",
                        principalTable: "CashShopCategory",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CashShopProduct_GameConfiguration_GameConfigurationId",
                        column: x => x.GameConfigurationId,
                        principalSchema: "config",
                        principalTable: "GameConfiguration",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CashShopProduct_ItemDefinition_ItemId",
                        column: x => x.ItemId,
                        principalSchema: "config",
                        principalTable: "ItemDefinition",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_ItemDefinition_LearnableSkillId",
                schema: "config",
                table: "ItemDefinition",
                column: "LearnableSkillId");

            migrationBuilder.CreateIndex(
                name: "IX_ItemDefinition_WearableSkillId",
                schema: "config",
                table: "ItemDefinition",
                column: "WearableSkillId");

            migrationBuilder.CreateIndex(
                name: "IX_Character_CashShopStorageId",
                schema: "data",
                table: "Character",
                column: "CashShopStorageId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_CashShopCategory_GameConfigurationId",
                schema: "config",
                table: "CashShopCategory",
                column: "GameConfigurationId");

            migrationBuilder.CreateIndex(
                name: "IX_CashShopProduct_CategoryObjectId",
                schema: "config",
                table: "CashShopProduct",
                column: "CategoryObjectId");

            migrationBuilder.CreateIndex(
                name: "IX_CashShopProduct_GameConfigurationId",
                schema: "config",
                table: "CashShopProduct",
                column: "GameConfigurationId");

            migrationBuilder.CreateIndex(
                name: "IX_CashShopProduct_ItemId",
                schema: "config",
                table: "CashShopProduct",
                column: "ItemId");

            migrationBuilder.CreateIndex(
                name: "IX_CashShopTransaction_AccountId",
                schema: "data",
                table: "CashShopTransaction",
                column: "AccountId");

            migrationBuilder.CreateIndex(
                name: "IX_CashShopTransaction_AccountId1",
                schema: "data",
                table: "CashShopTransaction",
                column: "AccountId1");

            migrationBuilder.AddForeignKey(
                name: "FK_Character_ItemStorage_CashShopStorageId",
                schema: "data",
                table: "Character",
                column: "CashShopStorageId",
                principalSchema: "data",
                principalTable: "ItemStorage",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_ItemDefinition_Skill_LearnableSkillId",
                schema: "config",
                table: "ItemDefinition",
                column: "LearnableSkillId",
                principalSchema: "config",
                principalTable: "Skill",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ItemDefinition_Skill_WearableSkillId",
                schema: "config",
                table: "ItemDefinition",
                column: "WearableSkillId",
                principalSchema: "config",
                principalTable: "Skill",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Character_ItemStorage_CashShopStorageId",
                schema: "data",
                table: "Character");

            migrationBuilder.DropForeignKey(
                name: "FK_ItemDefinition_Skill_LearnableSkillId",
                schema: "config",
                table: "ItemDefinition");

            migrationBuilder.DropForeignKey(
                name: "FK_ItemDefinition_Skill_WearableSkillId",
                schema: "config",
                table: "ItemDefinition");

            migrationBuilder.DropTable(
                name: "CashShopProduct",
                schema: "config");

            migrationBuilder.DropTable(
                name: "CashShopTransaction",
                schema: "data");

            migrationBuilder.DropTable(
                name: "CashShopCategory",
                schema: "config");

            migrationBuilder.DropIndex(
                name: "IX_ItemDefinition_LearnableSkillId",
                schema: "config",
                table: "ItemDefinition");

            migrationBuilder.DropIndex(
                name: "IX_ItemDefinition_WearableSkillId",
                schema: "config",
                table: "ItemDefinition");

            migrationBuilder.DropIndex(
                name: "IX_Character_CashShopStorageId",
                schema: "data",
                table: "Character");

            migrationBuilder.DropColumn(
                name: "BlessJewelDropCount",
                schema: "config",
                table: "MiniGameDefinition");

            migrationBuilder.DropColumn(
                name: "SoulJewelDropCount",
                schema: "config",
                table: "MiniGameDefinition");

            migrationBuilder.DropColumn(
                name: "LearnableSkillId",
                schema: "config",
                table: "ItemDefinition");

            migrationBuilder.DropColumn(
                name: "PetLeadershipFormula",
                schema: "config",
                table: "ItemDefinition");

            migrationBuilder.DropColumn(
                name: "WearableSkillId",
                schema: "config",
                table: "ItemDefinition");

            migrationBuilder.DropColumn(
                name: "GiftMessage",
                schema: "data",
                table: "Item");

            migrationBuilder.DropColumn(
                name: "Description",
                schema: "config",
                table: "GameServerConfiguration");

            migrationBuilder.DropColumn(
                name: "DisablePartySummon",
                schema: "config",
                table: "GameMapDefinition");

            migrationBuilder.DropColumn(
                name: "CashShopStorageId",
                schema: "data",
                table: "Character");

            migrationBuilder.DropColumn(
                name: "MinimumValuePerItemLevel",
                schema: "config",
                table: "AttributeRequirement");

            migrationBuilder.DropColumn(
                name: "GoblinPoints",
                schema: "data",
                table: "Account");

            migrationBuilder.DropColumn(
                name: "WCoinC",
                schema: "data",
                table: "Account");

            migrationBuilder.DropColumn(
                name: "WCoinP",
                schema: "data",
                table: "Account");
        }
    }
}
