CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
);

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
        IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'data') THEN
            CREATE SCHEMA data;
        END IF;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
        DO
        $do$
        BEGIN
           IF EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'account') THEN 
              RAISE NOTICE 'Role "account" already exists. Skipping.';
           ELSE
              CREATE ROLE account WITH LOGIN PASSWORD 'account';
           END IF;
        END
        $do$;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA data TO GROUP account;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER DEFAULT PRIVILEGES IN SCHEMA data GRANT ALL ON TABLES TO account;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT USAGE ON SCHEMA data TO GROUP account;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
        IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'config') THEN
            CREATE SCHEMA config;
        END IF;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
        DO
        $do$
        BEGIN
           IF EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'config') THEN 
              RAISE NOTICE 'Role "config" already exists. Skipping.';
           ELSE
              CREATE ROLE config WITH LOGIN PASSWORD 'config';
           END IF;
        END
        $do$;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA config TO GROUP config;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER DEFAULT PRIVILEGES IN SCHEMA config GRANT ALL ON TABLES TO config;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT USAGE ON SCHEMA config TO GROUP config;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
        IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'friend') THEN
            CREATE SCHEMA friend;
        END IF;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
        DO
        $do$
        BEGIN
           IF EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'friend') THEN 
              RAISE NOTICE 'Role "friend" already exists. Skipping.';
           ELSE
              CREATE ROLE friend WITH LOGIN PASSWORD 'friend';
           END IF;
        END
        $do$;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA friend TO GROUP friend;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER DEFAULT PRIVILEGES IN SCHEMA friend GRANT ALL ON TABLES TO friend;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT USAGE ON SCHEMA friend TO GROUP friend;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
        IF NOT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'guild') THEN
            CREATE SCHEMA guild;
        END IF;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
        DO
        $do$
        BEGIN
           IF EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'guild') THEN 
              RAISE NOTICE 'Role "guild" already exists. Skipping.';
           ELSE
              CREATE ROLE guild WITH LOGIN PASSWORD 'guild';
           END IF;
        END
        $do$;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA guild TO GROUP guild;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER DEFAULT PRIVILEGES IN SCHEMA guild GRANT ALL ON TABLES TO guild;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT USAGE ON SCHEMA guild TO GROUP guild;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ChatServerDefinition" (
        "Id" uuid NOT NULL,
        "ServerId" smallint NOT NULL,
        "Description" text NOT NULL,
        "MaximumConnections" integer NOT NULL,
        "ClientTimeout" interval NOT NULL,
        "ClientCleanUpInterval" interval NOT NULL,
        "RoomCleanUpInterval" interval NOT NULL,
        CONSTRAINT "PK_ChatServerDefinition" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE friend."Friend" (
        "Id" uuid NOT NULL,
        "CharacterId" uuid NOT NULL,
        "FriendId" uuid NOT NULL,
        "Accepted" boolean NOT NULL,
        "RequestOpen" boolean NOT NULL,
        CONSTRAINT "PK_Friend" PRIMARY KEY ("Id"),
        CONSTRAINT "AK_Friend_CharacterId_FriendId" UNIQUE ("CharacterId", "FriendId")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."GameClientDefinition" (
        "Id" uuid NOT NULL,
        "Season" smallint NOT NULL,
        "Episode" smallint NOT NULL,
        "Language" integer NOT NULL,
        "Version" bytea,
        "Serial" bytea,
        "Description" text NOT NULL,
        CONSTRAINT "PK_GameClientDefinition" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."GameConfiguration" (
        "Id" uuid NOT NULL,
        "MaximumLevel" smallint NOT NULL,
        "MaximumMasterLevel" smallint NOT NULL,
        "ExperienceRate" real NOT NULL,
        "MinimumMonsterLevelForMasterExperience" smallint NOT NULL,
        "InfoRange" smallint NOT NULL,
        "AreaSkillHitsPlayer" boolean NOT NULL,
        "MaximumInventoryMoney" integer NOT NULL,
        "MaximumVaultMoney" integer NOT NULL,
        "RecoveryInterval" integer NOT NULL,
        "MaximumLetters" integer NOT NULL,
        "LetterSendPrice" integer NOT NULL,
        "MaximumCharactersPerAccount" smallint NOT NULL,
        "CharacterNameRegex" text,
        "MaximumPasswordLength" integer NOT NULL,
        "MaximumPartySize" smallint NOT NULL,
        "ShouldDropMoney" boolean NOT NULL,
        "DamagePerOneItemDurability" double precision NOT NULL,
        "DamagePerOnePetDurability" double precision NOT NULL,
        "HitsPerOneItemDurability" double precision NOT NULL,
        CONSTRAINT "PK_GameConfiguration" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."GameServerConfiguration" (
        "Id" uuid NOT NULL,
        "MaximumPlayers" smallint NOT NULL,
        CONSTRAINT "PK_GameServerConfiguration" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE guild."Guild" (
        "Id" uuid NOT NULL,
        "HostilityId" uuid,
        "AllianceGuildId" uuid,
        "Name" character varying(8) NOT NULL,
        "Logo" bytea,
        "Score" integer NOT NULL,
        "Notice" text,
        CONSTRAINT "PK_Guild" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Guild_Guild_AllianceGuildId" FOREIGN KEY ("AllianceGuildId") REFERENCES guild."Guild" ("Id"),
        CONSTRAINT "FK_Guild_Guild_HostilityId" FOREIGN KEY ("HostilityId") REFERENCES guild."Guild" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."ItemStorage" (
        "Id" uuid NOT NULL,
        "Money" integer NOT NULL,
        CONSTRAINT "PK_ItemStorage" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT SELECT ON TABLE data."ItemStorage" TO GROUP config;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT USAGE ON SCHEMA data TO GROUP config;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."PowerUpDefinitionValue" (
        "Id" uuid NOT NULL,
        "Value" real NOT NULL,
        "AggregateType" integer NOT NULL,
        CONSTRAINT "PK_PowerUpDefinitionValue" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."Rectangle" (
        "Id" uuid NOT NULL,
        "X1" smallint NOT NULL,
        "Y1" smallint NOT NULL,
        "X2" smallint NOT NULL,
        "Y2" smallint NOT NULL,
        CONSTRAINT "PK_Rectangle" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."SimpleCraftingSettings" (
        "Id" uuid NOT NULL,
        "Money" integer NOT NULL,
        "MoneyPerFinalSuccessPercentage" integer NOT NULL,
        "SuccessPercent" smallint NOT NULL,
        "MaximumSuccessPercent" smallint NOT NULL,
        "MultipleAllowed" boolean NOT NULL,
        "ResultItemSelect" integer NOT NULL,
        "SuccessPercentageAdditionForLuck" integer NOT NULL,
        "SuccessPercentageAdditionForExcellentItem" integer NOT NULL,
        "SuccessPercentageAdditionForAncientItem" integer NOT NULL,
        "SuccessPercentageAdditionForSocketItem" integer NOT NULL,
        "ResultItemLuckOptionChance" smallint NOT NULL,
        "ResultItemSkillChance" smallint NOT NULL,
        "ResultItemExcellentOptionChance" smallint NOT NULL,
        "ResultItemMaxExcOptionCount" smallint NOT NULL,
        CONSTRAINT "PK_SimpleCraftingSettings" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ChatServerEndpoint" (
        "Id" uuid NOT NULL,
        "ClientId" uuid,
        "ChatServerDefinitionId" uuid,
        "NetworkPort" integer NOT NULL,
        CONSTRAINT "PK_ChatServerEndpoint" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ChatServerEndpoint_ChatServerDefinition_ChatServerDefinitio~" FOREIGN KEY ("ChatServerDefinitionId") REFERENCES config."ChatServerDefinition" ("Id"),
        CONSTRAINT "FK_ChatServerEndpoint_GameClientDefinition_ClientId" FOREIGN KEY ("ClientId") REFERENCES config."GameClientDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ConnectServerDefinition" (
        "Id" uuid NOT NULL,
        "ClientId" uuid,
        "ServerId" smallint NOT NULL,
        "Description" text NOT NULL,
        "DisconnectOnUnknownPacket" boolean NOT NULL,
        "MaximumReceiveSize" smallint NOT NULL,
        "ClientListenerPort" integer NOT NULL,
        "Timeout" interval NOT NULL,
        "CurrentPatchVersion" bytea,
        "PatchAddress" text NOT NULL,
        "MaxConnectionsPerAddress" integer NOT NULL,
        "CheckMaxConnectionsPerAddress" boolean NOT NULL,
        "MaxConnections" integer NOT NULL,
        "ListenerBacklog" integer NOT NULL,
        "MaxFtpRequests" integer NOT NULL,
        "MaxIpRequests" integer NOT NULL,
        "MaxServerListRequests" integer NOT NULL,
        CONSTRAINT "PK_ConnectServerDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ConnectServerDefinition_GameClientDefinition_ClientId" FOREIGN KEY ("ClientId") REFERENCES config."GameClientDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."AttributeDefinition" (
        "Id" uuid NOT NULL,
        "GameConfigurationId" uuid,
        "Designation" text,
        "Description" text,
        CONSTRAINT "PK_AttributeDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AttributeDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemLevelBonusTable" (
        "Id" uuid NOT NULL,
        "GameConfigurationId" uuid,
        "Name" text NOT NULL,
        "Description" text NOT NULL,
        CONSTRAINT "PK_ItemLevelBonusTable" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemLevelBonusTable_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemOptionDefinition" (
        "Id" uuid NOT NULL,
        "GameConfigurationId" uuid,
        "Name" text NOT NULL,
        "AddsRandomly" boolean NOT NULL,
        "AddChance" real NOT NULL,
        "MaximumOptionsPerItem" integer NOT NULL,
        CONSTRAINT "PK_ItemOptionDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemOptionDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemOptionType" (
        "Id" uuid NOT NULL,
        "GameConfigurationId" uuid,
        "Name" text NOT NULL,
        "Description" text NOT NULL,
        "IsVisible" boolean NOT NULL,
        CONSTRAINT "PK_ItemOptionType" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemOptionType_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemSetGroup" (
        "Id" uuid NOT NULL,
        "GameConfigurationId" uuid,
        "Name" text NOT NULL,
        "AlwaysApplies" boolean NOT NULL,
        "CountDistinct" boolean NOT NULL,
        "MinimumItemCount" integer NOT NULL,
        "SetLevel" integer NOT NULL,
        CONSTRAINT "PK_ItemSetGroup" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemSetGroup_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemSlotType" (
        "Id" uuid NOT NULL,
        "ItemSlots" text,
        "GameConfigurationId" uuid,
        "Description" text NOT NULL,
        CONSTRAINT "PK_ItemSlotType" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemSlotType_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MasterSkillRoot" (
        "Id" uuid NOT NULL,
        "GameConfigurationId" uuid,
        "Name" text NOT NULL,
        CONSTRAINT "PK_MasterSkillRoot" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MasterSkillRoot_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."PlugInConfiguration" (
        "Id" uuid NOT NULL,
        "GameConfigurationId" uuid,
        "TypeId" uuid NOT NULL,
        "IsActive" boolean NOT NULL,
        "CustomPlugInSource" text,
        "ExternalAssemblyName" text,
        "CustomConfiguration" text,
        CONSTRAINT "PK_PlugInConfiguration" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_PlugInConfiguration_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."GameServerDefinition" (
        "Id" uuid NOT NULL,
        "ServerConfigurationId" uuid,
        "GameConfigurationId" uuid,
        "ServerID" smallint NOT NULL,
        "Description" text NOT NULL,
        "ExperienceRate" real NOT NULL,
        CONSTRAINT "PK_GameServerDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_GameServerDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id"),
        CONSTRAINT "FK_GameServerDefinition_GameServerConfiguration_ServerConfigur~" FOREIGN KEY ("ServerConfigurationId") REFERENCES config."GameServerConfiguration" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."Account" (
        "Id" uuid NOT NULL,
        "VaultId" uuid,
        "LoginName" character varying(10) NOT NULL,
        "PasswordHash" text NOT NULL,
        "SecurityCode" text NOT NULL,
        "EMail" text NOT NULL,
        "RegistrationDate" timestamp with time zone NOT NULL,
        "State" integer NOT NULL,
        "TimeZone" smallint NOT NULL,
        "VaultPassword" text NOT NULL,
        "IsVaultExtended" boolean NOT NULL,
        CONSTRAINT "PK_Account" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Account_ItemStorage_VaultId" FOREIGN KEY ("VaultId") REFERENCES data."ItemStorage" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MagicEffectDefinition" (
        "Id" uuid NOT NULL,
        "DurationId" uuid,
        "GameConfigurationId" uuid,
        "Number" smallint NOT NULL,
        "Name" text NOT NULL,
        "SubType" smallint NOT NULL,
        "InformObservers" boolean NOT NULL,
        "StopByDeath" boolean NOT NULL,
        "SendDuration" boolean NOT NULL,
        CONSTRAINT "PK_MagicEffectDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MagicEffectDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id"),
        CONSTRAINT "FK_MagicEffectDefinition_PowerUpDefinitionValue_DurationId" FOREIGN KEY ("DurationId") REFERENCES config."PowerUpDefinitionValue" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."BattleZoneDefinition" (
        "Id" uuid NOT NULL,
        "GroundId" uuid,
        "LeftGoalId" uuid,
        "RightGoalId" uuid,
        "Type" integer NOT NULL,
        "LeftTeamSpawnPointX" smallint,
        "LeftTeamSpawnPointY" smallint NOT NULL,
        "RightTeamSpawnPointX" smallint,
        "RightTeamSpawnPointY" smallint NOT NULL,
        CONSTRAINT "PK_BattleZoneDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_BattleZoneDefinition_Rectangle_GroundId" FOREIGN KEY ("GroundId") REFERENCES config."Rectangle" ("Id"),
        CONSTRAINT "FK_BattleZoneDefinition_Rectangle_LeftGoalId" FOREIGN KEY ("LeftGoalId") REFERENCES config."Rectangle" ("Id"),
        CONSTRAINT "FK_BattleZoneDefinition_Rectangle_RightGoalId" FOREIGN KEY ("RightGoalId") REFERENCES config."Rectangle" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemCraftingRequiredItem" (
        "Id" uuid NOT NULL,
        "SimpleCraftingSettingsId" uuid,
        "MinimumItemLevel" smallint NOT NULL,
        "MaximumItemLevel" smallint NOT NULL,
        "MinimumAmount" smallint NOT NULL,
        "MaximumAmount" smallint NOT NULL,
        "SuccessResult" integer NOT NULL,
        "FailResult" integer NOT NULL,
        "NpcPriceDivisor" integer NOT NULL,
        "AddPercentage" smallint NOT NULL,
        "Reference" smallint NOT NULL,
        CONSTRAINT "PK_ItemCraftingRequiredItem" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemCraftingRequiredItem_SimpleCraftingSettings_SimpleCraft~" FOREIGN KEY ("SimpleCraftingSettingsId") REFERENCES config."SimpleCraftingSettings" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."LevelBonus" (
        "Id" uuid NOT NULL,
        "ItemLevelBonusTableId" uuid,
        "Level" integer NOT NULL,
        "AdditionalValue" real NOT NULL,
        CONSTRAINT "PK_LevelBonus" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_LevelBonus_ItemLevelBonusTable_ItemLevelBonusTableId" FOREIGN KEY ("ItemLevelBonusTableId") REFERENCES config."ItemLevelBonusTable" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."GameServerEndpoint" (
        "Id" uuid NOT NULL,
        "ClientId" uuid,
        "GameServerDefinitionId" uuid,
        "NetworkPort" integer NOT NULL,
        "AlternativePublishedPort" integer NOT NULL,
        CONSTRAINT "PK_GameServerEndpoint" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_GameServerEndpoint_GameClientDefinition_ClientId" FOREIGN KEY ("ClientId") REFERENCES config."GameClientDefinition" ("Id"),
        CONSTRAINT "FK_GameServerEndpoint_GameServerDefinition_GameServerDefinitio~" FOREIGN KEY ("GameServerDefinitionId") REFERENCES config."GameServerDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."PowerUpDefinition" (
        "Id" uuid NOT NULL,
        "TargetAttributeId" uuid,
        "BoostId" uuid,
        "MagicEffectDefinitionId" uuid,
        CONSTRAINT "PK_PowerUpDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_PowerUpDefinition_AttributeDefinition_TargetAttributeId" FOREIGN KEY ("TargetAttributeId") REFERENCES config."AttributeDefinition" ("Id"),
        CONSTRAINT "FK_PowerUpDefinition_MagicEffectDefinition_MagicEffectDefiniti~" FOREIGN KEY ("MagicEffectDefinitionId") REFERENCES config."MagicEffectDefinition" ("Id"),
        CONSTRAINT "FK_PowerUpDefinition_PowerUpDefinitionValue_BoostId" FOREIGN KEY ("BoostId") REFERENCES config."PowerUpDefinitionValue" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."GameMapDefinition" (
        "Id" uuid NOT NULL,
        "SafezoneMapId" uuid,
        "BattleZoneId" uuid,
        "GameConfigurationId" uuid,
        "Number" smallint NOT NULL,
        "Name" text NOT NULL,
        "TerrainData" bytea,
        "ExpMultiplier" double precision NOT NULL,
        "Discriminator" integer NOT NULL,
        CONSTRAINT "PK_GameMapDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_GameMapDefinition_BattleZoneDefinition_BattleZoneId" FOREIGN KEY ("BattleZoneId") REFERENCES config."BattleZoneDefinition" ("Id"),
        CONSTRAINT "FK_GameMapDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id"),
        CONSTRAINT "FK_GameMapDefinition_GameMapDefinition_SafezoneMapId" FOREIGN KEY ("SafezoneMapId") REFERENCES config."GameMapDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemCraftingRequiredItemItemOptionType" (
        "ItemCraftingRequiredItemId" uuid NOT NULL,
        "ItemOptionTypeId" uuid NOT NULL,
        CONSTRAINT "PK_ItemCraftingRequiredItemItemOptionType" PRIMARY KEY ("ItemCraftingRequiredItemId", "ItemOptionTypeId"),
        CONSTRAINT "FK_ItemCraftingRequiredItemItemOptionType_ItemCraftingRequired~" FOREIGN KEY ("ItemCraftingRequiredItemId") REFERENCES config."ItemCraftingRequiredItem" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_ItemCraftingRequiredItemItemOptionType_ItemOptionType_ItemO~" FOREIGN KEY ("ItemOptionTypeId") REFERENCES config."ItemOptionType" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."IncreasableItemOption" (
        "Id" uuid NOT NULL,
        "OptionTypeId" uuid,
        "PowerUpDefinitionId" uuid,
        "ItemOptionDefinitionId" uuid,
        "ItemSetGroupId" uuid,
        "Number" integer NOT NULL,
        "SubOptionType" integer NOT NULL,
        "LevelType" integer NOT NULL,
        CONSTRAINT "PK_IncreasableItemOption" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_IncreasableItemOption_ItemOptionDefinition_ItemOptionDefini~" FOREIGN KEY ("ItemOptionDefinitionId") REFERENCES config."ItemOptionDefinition" ("Id"),
        CONSTRAINT "FK_IncreasableItemOption_ItemOptionType_OptionTypeId" FOREIGN KEY ("OptionTypeId") REFERENCES config."ItemOptionType" ("Id"),
        CONSTRAINT "FK_IncreasableItemOption_ItemSetGroup_ItemSetGroupId" FOREIGN KEY ("ItemSetGroupId") REFERENCES config."ItemSetGroup" ("Id"),
        CONSTRAINT "FK_IncreasableItemOption_PowerUpDefinition_PowerUpDefinitionId" FOREIGN KEY ("PowerUpDefinitionId") REFERENCES config."PowerUpDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemOptionCombinationBonus" (
        "Id" uuid NOT NULL,
        "BonusId" uuid,
        "GameConfigurationId" uuid,
        "Description" text NOT NULL,
        "Number" integer NOT NULL,
        "AppliesMultipleTimes" boolean NOT NULL,
        CONSTRAINT "PK_ItemOptionCombinationBonus" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemOptionCombinationBonus_GameConfiguration_GameConfigurat~" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id"),
        CONSTRAINT "FK_ItemOptionCombinationBonus_PowerUpDefinition_BonusId" FOREIGN KEY ("BonusId") REFERENCES config."PowerUpDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."CharacterClass" (
        "Id" uuid NOT NULL,
        "NextGenerationClassId" uuid,
        "HomeMapId" uuid,
        "GameConfigurationId" uuid,
        "Number" smallint NOT NULL,
        "Name" text NOT NULL,
        "CanGetCreated" boolean NOT NULL,
        "LevelRequirementByCreation" smallint NOT NULL,
        "CreationAllowedFlag" smallint NOT NULL,
        "IsMasterClass" boolean NOT NULL,
        "LevelWarpRequirementReductionPercent" integer NOT NULL,
        "FruitCalculation" integer NOT NULL,
        CONSTRAINT "PK_CharacterClass" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_CharacterClass_CharacterClass_NextGenerationClassId" FOREIGN KEY ("NextGenerationClassId") REFERENCES config."CharacterClass" ("Id"),
        CONSTRAINT "FK_CharacterClass_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id"),
        CONSTRAINT "FK_CharacterClass_GameMapDefinition_HomeMapId" FOREIGN KEY ("HomeMapId") REFERENCES config."GameMapDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ExitGate" (
        "Id" uuid NOT NULL,
        "MapId" uuid,
        "X1" smallint NOT NULL,
        "Y1" smallint NOT NULL,
        "X2" smallint NOT NULL,
        "Y2" smallint NOT NULL,
        "Direction" integer NOT NULL,
        "IsSpawnGate" boolean NOT NULL,
        CONSTRAINT "PK_ExitGate" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ExitGate_GameMapDefinition_MapId" FOREIGN KEY ("MapId") REFERENCES config."GameMapDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."GameServerConfigurationGameMapDefinition" (
        "GameServerConfigurationId" uuid NOT NULL,
        "GameMapDefinitionId" uuid NOT NULL,
        CONSTRAINT "PK_GameServerConfigurationGameMapDefinition" PRIMARY KEY ("GameServerConfigurationId", "GameMapDefinitionId"),
        CONSTRAINT "FK_GameServerConfigurationGameMapDefinition_GameMapDefinition_~" FOREIGN KEY ("GameMapDefinitionId") REFERENCES config."GameMapDefinition" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_GameServerConfigurationGameMapDefinition_GameServerConfigur~" FOREIGN KEY ("GameServerConfigurationId") REFERENCES config."GameServerConfiguration" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemOptionOfLevel" (
        "Id" uuid NOT NULL,
        "PowerUpDefinitionId" uuid,
        "IncreasableItemOptionId" uuid,
        "Level" integer NOT NULL,
        "RequiredItemLevel" integer NOT NULL,
        CONSTRAINT "PK_ItemOptionOfLevel" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemOptionOfLevel_IncreasableItemOption_IncreasableItemOpti~" FOREIGN KEY ("IncreasableItemOptionId") REFERENCES config."IncreasableItemOption" ("Id"),
        CONSTRAINT "FK_ItemOptionOfLevel_PowerUpDefinition_PowerUpDefinitionId" FOREIGN KEY ("PowerUpDefinitionId") REFERENCES config."PowerUpDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."CombinationBonusRequirement" (
        "Id" uuid NOT NULL,
        "OptionTypeId" uuid,
        "ItemOptionCombinationBonusId" uuid,
        "SubOptionType" integer NOT NULL,
        "MinimumCount" integer NOT NULL,
        CONSTRAINT "PK_CombinationBonusRequirement" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_CombinationBonusRequirement_ItemOptionCombinationBonus_Item~" FOREIGN KEY ("ItemOptionCombinationBonusId") REFERENCES config."ItemOptionCombinationBonus" ("Id"),
        CONSTRAINT "FK_CombinationBonusRequirement_ItemOptionType_OptionTypeId" FOREIGN KEY ("OptionTypeId") REFERENCES config."ItemOptionType" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."AccountCharacterClass" (
        "AccountId" uuid NOT NULL,
        "CharacterClassId" uuid NOT NULL,
        CONSTRAINT "PK_AccountCharacterClass" PRIMARY KEY ("AccountId", "CharacterClassId"),
        CONSTRAINT "FK_AccountCharacterClass_Account_AccountId" FOREIGN KEY ("AccountId") REFERENCES data."Account" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_AccountCharacterClass_CharacterClass_CharacterClassId" FOREIGN KEY ("CharacterClassId") REFERENCES config."CharacterClass" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."AppearanceData" (
        "Id" uuid NOT NULL,
        "CharacterClassId" uuid,
        "Pose" smallint NOT NULL,
        "FullAncientSetEquipped" boolean NOT NULL,
        CONSTRAINT "PK_AppearanceData" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AppearanceData_CharacterClass_CharacterClassId" FOREIGN KEY ("CharacterClassId") REFERENCES config."CharacterClass" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."AttributeRelationship" (
        "Id" uuid NOT NULL,
        "TargetAttributeId" uuid,
        "InputAttributeId" uuid,
        "CharacterClassId" uuid,
        "PowerUpDefinitionValueId" uuid,
        "InputOperator" integer NOT NULL,
        "InputOperand" real NOT NULL,
        CONSTRAINT "PK_AttributeRelationship" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AttributeRelationship_AttributeDefinition_InputAttributeId" FOREIGN KEY ("InputAttributeId") REFERENCES config."AttributeDefinition" ("Id"),
        CONSTRAINT "FK_AttributeRelationship_AttributeDefinition_TargetAttributeId" FOREIGN KEY ("TargetAttributeId") REFERENCES config."AttributeDefinition" ("Id"),
        CONSTRAINT "FK_AttributeRelationship_CharacterClass_CharacterClassId" FOREIGN KEY ("CharacterClassId") REFERENCES config."CharacterClass" ("Id"),
        CONSTRAINT "FK_AttributeRelationship_PowerUpDefinitionValue_PowerUpDefinit~" FOREIGN KEY ("PowerUpDefinitionValueId") REFERENCES config."PowerUpDefinitionValue" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."Character" (
        "Id" uuid NOT NULL,
        "CharacterClassId" uuid NOT NULL,
        "CurrentMapId" uuid,
        "InventoryId" uuid,
        "AccountId" uuid,
        "Name" character varying(10) NOT NULL,
        "CharacterSlot" smallint NOT NULL,
        "CreateDate" timestamp with time zone NOT NULL,
        "Experience" bigint NOT NULL,
        "MasterExperience" bigint NOT NULL,
        "LevelUpPoints" integer NOT NULL,
        "MasterLevelUpPoints" integer NOT NULL,
        "PositionX" smallint NOT NULL,
        "PositionY" smallint NOT NULL,
        "PlayerKillCount" integer NOT NULL,
        "StateRemainingSeconds" integer NOT NULL,
        "State" integer NOT NULL,
        "CharacterStatus" integer NOT NULL,
        "Pose" smallint NOT NULL,
        "UsedFruitPoints" integer NOT NULL,
        "UsedNegFruitPoints" integer NOT NULL,
        "InventoryExtensions" integer NOT NULL,
        "KeyConfiguration" bytea,
        CONSTRAINT "PK_Character" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Character_Account_AccountId" FOREIGN KEY ("AccountId") REFERENCES data."Account" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_Character_CharacterClass_CharacterClassId" FOREIGN KEY ("CharacterClassId") REFERENCES config."CharacterClass" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_Character_GameMapDefinition_CurrentMapId" FOREIGN KEY ("CurrentMapId") REFERENCES config."GameMapDefinition" ("Id"),
        CONSTRAINT "FK_Character_ItemStorage_InventoryId" FOREIGN KEY ("InventoryId") REFERENCES data."ItemStorage" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT SELECT ON TABLE data."Character" TO GROUP guild;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT USAGE ON SCHEMA data TO GROUP guild;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT SELECT ON TABLE data."Character" TO GROUP friend;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT USAGE ON SCHEMA data TO GROUP friend;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ConstValueAttribute" (
        "Id" uuid NOT NULL,
        "DefinitionId" uuid,
        "CharacterClassId" uuid NOT NULL,
        "Value" real NOT NULL,
        CONSTRAINT "PK_ConstValueAttribute" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ConstValueAttribute_AttributeDefinition_DefinitionId" FOREIGN KEY ("DefinitionId") REFERENCES config."AttributeDefinition" ("Id"),
        CONSTRAINT "FK_ConstValueAttribute_CharacterClass_CharacterClassId" FOREIGN KEY ("CharacterClassId") REFERENCES config."CharacterClass" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."StatAttributeDefinition" (
        "Id" uuid NOT NULL,
        "AttributeId" uuid,
        "CharacterClassId" uuid,
        "BaseValue" real NOT NULL,
        "IncreasableByPlayer" boolean NOT NULL,
        CONSTRAINT "PK_StatAttributeDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_StatAttributeDefinition_AttributeDefinition_AttributeId" FOREIGN KEY ("AttributeId") REFERENCES config."AttributeDefinition" ("Id"),
        CONSTRAINT "FK_StatAttributeDefinition_CharacterClass_CharacterClassId" FOREIGN KEY ("CharacterClassId") REFERENCES config."CharacterClass" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."EnterGate" (
        "Id" uuid NOT NULL,
        "TargetGateId" uuid,
        "GameMapDefinitionId" uuid,
        "X1" smallint NOT NULL,
        "Y1" smallint NOT NULL,
        "X2" smallint NOT NULL,
        "Y2" smallint NOT NULL,
        "LevelRequirement" smallint NOT NULL,
        "Number" smallint NOT NULL,
        CONSTRAINT "PK_EnterGate" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_EnterGate_ExitGate_TargetGateId" FOREIGN KEY ("TargetGateId") REFERENCES config."ExitGate" ("Id"),
        CONSTRAINT "FK_EnterGate_GameMapDefinition_GameMapDefinitionId" FOREIGN KEY ("GameMapDefinitionId") REFERENCES config."GameMapDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."WarpInfo" (
        "Id" uuid NOT NULL,
        "GateId" uuid,
        "GameConfigurationId" uuid,
        "Index" integer NOT NULL,
        "Name" text NOT NULL,
        "Costs" integer NOT NULL,
        "LevelRequirement" integer NOT NULL,
        CONSTRAINT "PK_WarpInfo" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_WarpInfo_ExitGate_GateId" FOREIGN KEY ("GateId") REFERENCES config."ExitGate" ("Id"),
        CONSTRAINT "FK_WarpInfo_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE guild."GuildMember" (
        "Id" uuid NOT NULL,
        "GuildId" uuid NOT NULL,
        "Status" smallint NOT NULL,
        CONSTRAINT "PK_GuildMember" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_GuildMember_Character_Id" FOREIGN KEY ("Id") REFERENCES data."Character" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_GuildMember_Guild_GuildId" FOREIGN KEY ("GuildId") REFERENCES guild."Guild" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."LetterHeader" (
        "Id" uuid NOT NULL,
        "ReceiverId" uuid NOT NULL,
        "SenderName" text,
        "Subject" text,
        "LetterDate" timestamp with time zone NOT NULL,
        "ReadFlag" boolean NOT NULL,
        CONSTRAINT "PK_LetterHeader" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_LetterHeader_Character_ReceiverId" FOREIGN KEY ("ReceiverId") REFERENCES data."Character" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."StatAttribute" (
        "Id" uuid NOT NULL,
        "DefinitionId" uuid,
        "CharacterId" uuid,
        "Value" real NOT NULL,
        CONSTRAINT "PK_StatAttribute" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_StatAttribute_AttributeDefinition_DefinitionId" FOREIGN KEY ("DefinitionId") REFERENCES config."AttributeDefinition" ("Id"),
        CONSTRAINT "FK_StatAttribute_Character_CharacterId" FOREIGN KEY ("CharacterId") REFERENCES data."Character" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."LetterBody" (
        "Id" uuid NOT NULL,
        "HeaderId" uuid,
        "SenderAppearanceId" uuid,
        "Message" text NOT NULL,
        "Rotation" smallint NOT NULL,
        "Animation" smallint NOT NULL,
        CONSTRAINT "PK_LetterBody" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_LetterBody_AppearanceData_SenderAppearanceId" FOREIGN KEY ("SenderAppearanceId") REFERENCES data."AppearanceData" ("Id"),
        CONSTRAINT "FK_LetterBody_LetterHeader_HeaderId" FOREIGN KEY ("HeaderId") REFERENCES data."LetterHeader" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."CharacterDropItemGroup" (
        "CharacterId" uuid NOT NULL,
        "DropItemGroupId" uuid NOT NULL,
        CONSTRAINT "PK_CharacterDropItemGroup" PRIMARY KEY ("CharacterId", "DropItemGroupId"),
        CONSTRAINT "FK_CharacterDropItemGroup_Character_CharacterId" FOREIGN KEY ("CharacterId") REFERENCES data."Character" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."CharacterQuestState" (
        "Id" uuid NOT NULL,
        "LastFinishedQuestId" uuid,
        "ActiveQuestId" uuid,
        "CharacterId" uuid,
        "Group" smallint NOT NULL,
        "ClientActionPerformed" boolean NOT NULL,
        CONSTRAINT "PK_CharacterQuestState" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_CharacterQuestState_Character_CharacterId" FOREIGN KEY ("CharacterId") REFERENCES data."Character" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."DropItemGroup" (
        "Id" uuid NOT NULL,
        "MonsterId" uuid,
        "GameConfigurationId" uuid,
        "Description" text NOT NULL,
        "Chance" double precision NOT NULL,
        "MinimumMonsterLevel" smallint,
        "MaximumMonsterLevel" smallint,
        "ItemLevel" smallint,
        "ItemType" integer NOT NULL,
        CONSTRAINT "PK_DropItemGroup" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_DropItemGroup_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."GameMapDefinitionDropItemGroup" (
        "GameMapDefinitionId" uuid NOT NULL,
        "DropItemGroupId" uuid NOT NULL,
        CONSTRAINT "PK_GameMapDefinitionDropItemGroup" PRIMARY KEY ("GameMapDefinitionId", "DropItemGroupId"),
        CONSTRAINT "FK_GameMapDefinitionDropItemGroup_DropItemGroup_DropItemGroupId" FOREIGN KEY ("DropItemGroupId") REFERENCES config."DropItemGroup" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_GameMapDefinitionDropItemGroup_GameMapDefinition_GameMapDef~" FOREIGN KEY ("GameMapDefinitionId") REFERENCES config."GameMapDefinition" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."DropItemGroupItemDefinition" (
        "DropItemGroupId" uuid NOT NULL,
        "ItemDefinitionId" uuid NOT NULL,
        CONSTRAINT "PK_DropItemGroupItemDefinition" PRIMARY KEY ("DropItemGroupId", "ItemDefinitionId"),
        CONSTRAINT "FK_DropItemGroupItemDefinition_DropItemGroup_DropItemGroupId" FOREIGN KEY ("DropItemGroupId") REFERENCES config."DropItemGroup" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."Item" (
        "Id" uuid NOT NULL,
        "ItemStorageId" uuid,
        "DefinitionId" uuid,
        "ItemSlot" smallint NOT NULL,
        "Durability" double precision NOT NULL,
        "Level" smallint NOT NULL,
        "HasSkill" boolean NOT NULL,
        "SocketCount" integer NOT NULL,
        "StorePrice" integer,
        CONSTRAINT "PK_Item" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Item_ItemStorage_ItemStorageId" FOREIGN KEY ("ItemStorageId") REFERENCES data."ItemStorage" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT SELECT ON TABLE data."Item" TO GROUP config;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT USAGE ON SCHEMA data TO GROUP config;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."ItemOptionLink" (
        "Id" uuid NOT NULL,
        "ItemOptionId" uuid,
        "ItemId" uuid,
        "Level" integer NOT NULL,
        "Index" integer NOT NULL,
        CONSTRAINT "PK_ItemOptionLink" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemOptionLink_IncreasableItemOption_ItemOptionId" FOREIGN KEY ("ItemOptionId") REFERENCES config."IncreasableItemOption" ("Id"),
        CONSTRAINT "FK_ItemOptionLink_Item_ItemId" FOREIGN KEY ("ItemId") REFERENCES data."Item" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT SELECT ON TABLE data."ItemOptionLink" TO GROUP config;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT USAGE ON SCHEMA data TO GROUP config;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."ItemAppearance" (
        "Id" uuid NOT NULL,
        "DefinitionId" uuid,
        "AppearanceDataId" uuid,
        "ItemSlot" smallint NOT NULL,
        "Level" smallint NOT NULL,
        CONSTRAINT "PK_ItemAppearance" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemAppearance_AppearanceData_AppearanceDataId" FOREIGN KEY ("AppearanceDataId") REFERENCES data."AppearanceData" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."ItemAppearanceItemOptionType" (
        "ItemAppearanceId" uuid NOT NULL,
        "ItemOptionTypeId" uuid NOT NULL,
        CONSTRAINT "PK_ItemAppearanceItemOptionType" PRIMARY KEY ("ItemAppearanceId", "ItemOptionTypeId"),
        CONSTRAINT "FK_ItemAppearanceItemOptionType_ItemAppearance_ItemAppearanceId" FOREIGN KEY ("ItemAppearanceId") REFERENCES data."ItemAppearance" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_ItemAppearanceItemOptionType_ItemOptionType_ItemOptionTypeId" FOREIGN KEY ("ItemOptionTypeId") REFERENCES config."ItemOptionType" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemBasePowerUpDefinition" (
        "Id" uuid NOT NULL,
        "TargetAttributeId" uuid,
        "BonusPerLevelTableId" uuid,
        "ItemDefinitionId" uuid,
        "BaseValue" real NOT NULL,
        CONSTRAINT "PK_ItemBasePowerUpDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemBasePowerUpDefinition_AttributeDefinition_TargetAttribu~" FOREIGN KEY ("TargetAttributeId") REFERENCES config."AttributeDefinition" ("Id"),
        CONSTRAINT "FK_ItemBasePowerUpDefinition_ItemLevelBonusTable_BonusPerLevel~" FOREIGN KEY ("BonusPerLevelTableId") REFERENCES config."ItemLevelBonusTable" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemCrafting" (
        "Id" uuid NOT NULL,
        "SimpleCraftingSettingsId" uuid,
        "MonsterDefinitionId" uuid,
        "Number" smallint NOT NULL,
        "Name" text NOT NULL,
        "ItemCraftingHandlerClassName" text NOT NULL,
        CONSTRAINT "PK_ItemCrafting" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemCrafting_SimpleCraftingSettings_SimpleCraftingSettingsId" FOREIGN KEY ("SimpleCraftingSettingsId") REFERENCES config."SimpleCraftingSettings" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemCraftingRequiredItemItemDefinition" (
        "ItemCraftingRequiredItemId" uuid NOT NULL,
        "ItemDefinitionId" uuid NOT NULL,
        CONSTRAINT "PK_ItemCraftingRequiredItemItemDefinition" PRIMARY KEY ("ItemCraftingRequiredItemId", "ItemDefinitionId"),
        CONSTRAINT "FK_ItemCraftingRequiredItemItemDefinition_ItemCraftingRequired~" FOREIGN KEY ("ItemCraftingRequiredItemId") REFERENCES config."ItemCraftingRequiredItem" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemCraftingResultItem" (
        "Id" uuid NOT NULL,
        "ItemDefinitionId" uuid,
        "SimpleCraftingSettingsId" uuid,
        "RandomMinimumLevel" smallint NOT NULL,
        "RandomMaximumLevel" smallint NOT NULL,
        "Durability" smallint,
        "Reference" smallint NOT NULL,
        "AddLevel" smallint NOT NULL,
        CONSTRAINT "PK_ItemCraftingResultItem" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemCraftingResultItem_SimpleCraftingSettings_SimpleCraftin~" FOREIGN KEY ("SimpleCraftingSettingsId") REFERENCES config."SimpleCraftingSettings" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemDefinition" (
        "Id" uuid NOT NULL,
        "ItemSlotId" uuid,
        "ConsumeEffectId" uuid,
        "SkillId" uuid,
        "GameConfigurationId" uuid,
        "ItemGroupId" uuid,
        "Number" smallint NOT NULL,
        "Width" smallint NOT NULL,
        "Height" smallint NOT NULL,
        "DropsFromMonsters" boolean NOT NULL,
        "IsAmmunition" boolean NOT NULL,
        "IsBoundToCharacter" boolean NOT NULL,
        "Name" text NOT NULL,
        "DropLevel" smallint NOT NULL,
        "MaximumItemLevel" smallint NOT NULL,
        "Durability" smallint NOT NULL,
        "Group" smallint NOT NULL,
        "Value" integer NOT NULL,
        "ConsumeHandlerClass" text,
        "MaximumSockets" integer NOT NULL,
        CONSTRAINT "PK_ItemDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id"),
        CONSTRAINT "FK_ItemDefinition_ItemGroupDefinition_ItemGroupId" FOREIGN KEY ("ItemGroupId") REFERENCES config."ItemGroupDefinition" ("Id"),
        CONSTRAINT "FK_ItemDefinition_ItemSlotType_ItemSlotId" FOREIGN KEY ("ItemSlotId") REFERENCES config."ItemSlotType" ("Id"),
        CONSTRAINT "FK_ItemDefinition_MagicEffectDefinition_ConsumeEffectId" FOREIGN KEY ("ConsumeEffectId") REFERENCES config."MagicEffectDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemDefinitionCharacterClass" (
        "ItemDefinitionId" uuid NOT NULL,
        "CharacterClassId" uuid NOT NULL,
        CONSTRAINT "PK_ItemDefinitionCharacterClass" PRIMARY KEY ("ItemDefinitionId", "CharacterClassId"),
        CONSTRAINT "FK_ItemDefinitionCharacterClass_CharacterClass_CharacterClassId" FOREIGN KEY ("CharacterClassId") REFERENCES config."CharacterClass" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_ItemDefinitionCharacterClass_ItemDefinition_ItemDefinitionId" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemDefinitionItemOptionDefinition" (
        "ItemDefinitionId" uuid NOT NULL,
        "ItemOptionDefinitionId" uuid NOT NULL,
        CONSTRAINT "PK_ItemDefinitionItemOptionDefinition" PRIMARY KEY ("ItemDefinitionId", "ItemOptionDefinitionId"),
        CONSTRAINT "FK_ItemDefinitionItemOptionDefinition_ItemDefinition_ItemDefin~" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_ItemDefinitionItemOptionDefinition_ItemOptionDefinition_Ite~" FOREIGN KEY ("ItemOptionDefinitionId") REFERENCES config."ItemOptionDefinition" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemDefinitionItemSetGroup" (
        "ItemDefinitionId" uuid NOT NULL,
        "ItemSetGroupId" uuid NOT NULL,
        CONSTRAINT "PK_ItemDefinitionItemSetGroup" PRIMARY KEY ("ItemDefinitionId", "ItemSetGroupId"),
        CONSTRAINT "FK_ItemDefinitionItemSetGroup_ItemDefinition_ItemDefinitionId" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_ItemDefinitionItemSetGroup_ItemSetGroup_ItemSetGroupId" FOREIGN KEY ("ItemSetGroupId") REFERENCES config."ItemSetGroup" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemOfItemSet" (
        "Id" uuid NOT NULL,
        "ItemSetGroupId" uuid,
        "ItemDefinitionId" uuid,
        "BonusOptionId" uuid,
        "AncientSetDiscriminator" integer NOT NULL,
        CONSTRAINT "PK_ItemOfItemSet" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemOfItemSet_IncreasableItemOption_BonusOptionId" FOREIGN KEY ("BonusOptionId") REFERENCES config."IncreasableItemOption" ("Id"),
        CONSTRAINT "FK_ItemOfItemSet_ItemDefinition_ItemDefinitionId" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id"),
        CONSTRAINT "FK_ItemOfItemSet_ItemSetGroup_ItemSetGroupId" FOREIGN KEY ("ItemSetGroupId") REFERENCES config."ItemSetGroup" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."JewelMix" (
        "Id" uuid NOT NULL,
        "SingleJewelId" uuid,
        "MixedJewelId" uuid,
        "GameConfigurationId" uuid,
        "Number" smallint NOT NULL,
        CONSTRAINT "PK_JewelMix" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_JewelMix_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id"),
        CONSTRAINT "FK_JewelMix_ItemDefinition_MixedJewelId" FOREIGN KEY ("MixedJewelId") REFERENCES config."ItemDefinition" ("Id"),
        CONSTRAINT "FK_JewelMix_ItemDefinition_SingleJewelId" FOREIGN KEY ("SingleJewelId") REFERENCES config."ItemDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MiniGameDefinition" (
        "Id" uuid NOT NULL,
        "EntranceId" uuid,
        "TicketItemId" uuid,
        "GameConfigurationId" uuid,
        "Type" integer NOT NULL,
        "Name" text NOT NULL,
        "Description" text NOT NULL,
        "GameLevel" smallint NOT NULL,
        "MapCreationPolicy" integer NOT NULL,
        "EnterDuration" interval NOT NULL,
        "GameDuration" interval NOT NULL,
        "ExitDuration" interval NOT NULL,
        "MaximumPlayerCount" integer NOT NULL,
        "SaveRankingStatistics" boolean NOT NULL,
        "RequiresMasterClass" boolean NOT NULL,
        "MinimumCharacterLevel" integer NOT NULL,
        "MaximumCharacterLevel" integer NOT NULL,
        "MinimumSpecialCharacterLevel" integer NOT NULL,
        "MaximumSpecialCharacterLevel" integer NOT NULL,
        "TicketItemLevel" integer NOT NULL,
        CONSTRAINT "PK_MiniGameDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MiniGameDefinition_ExitGate_EntranceId" FOREIGN KEY ("EntranceId") REFERENCES config."ExitGate" ("Id"),
        CONSTRAINT "FK_MiniGameDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id"),
        CONSTRAINT "FK_MiniGameDefinition_ItemDefinition_TicketItemId" FOREIGN KEY ("TicketItemId") REFERENCES config."ItemDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."ItemItemOfItemSet" (
        "ItemId" uuid NOT NULL,
        "ItemOfItemSetId" uuid NOT NULL,
        CONSTRAINT "PK_ItemItemOfItemSet" PRIMARY KEY ("ItemId", "ItemOfItemSetId"),
        CONSTRAINT "FK_ItemItemOfItemSet_Item_ItemId" FOREIGN KEY ("ItemId") REFERENCES data."Item" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_ItemItemOfItemSet_ItemOfItemSet_ItemOfItemSetId" FOREIGN KEY ("ItemOfItemSetId") REFERENCES config."ItemOfItemSet" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT SELECT ON TABLE data."ItemItemOfItemSet" TO GROUP config;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    GRANT USAGE ON SCHEMA data TO GROUP config;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."MiniGameRankingEntry" (
        "Id" uuid NOT NULL,
        "CharacterId" uuid,
        "MiniGameId" uuid,
        "GameInstanceId" uuid NOT NULL,
        "Timestamp" timestamp with time zone NOT NULL,
        "Score" integer NOT NULL,
        "Rank" integer NOT NULL,
        CONSTRAINT "PK_MiniGameRankingEntry" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MiniGameRankingEntry_Character_CharacterId" FOREIGN KEY ("CharacterId") REFERENCES data."Character" ("Id"),
        CONSTRAINT "FK_MiniGameRankingEntry_MiniGameDefinition_MiniGameId" FOREIGN KEY ("MiniGameId") REFERENCES config."MiniGameDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MiniGameSpawnWave" (
        "Id" uuid NOT NULL,
        "MiniGameDefinitionId" uuid,
        "WaveNumber" smallint NOT NULL,
        "Description" text,
        "Message" text,
        "StartTime" interval NOT NULL,
        "EndTime" interval NOT NULL,
        CONSTRAINT "PK_MiniGameSpawnWave" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MiniGameSpawnWave_MiniGameDefinition_MiniGameDefinitionId" FOREIGN KEY ("MiniGameDefinitionId") REFERENCES config."MiniGameDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."AttributeRequirement" (
        "Id" uuid NOT NULL,
        "AttributeId" uuid,
        "GameMapDefinitionId" uuid,
        "ItemDefinitionId" uuid,
        "SkillId" uuid,
        "SkillId1" uuid,
        "MinimumValue" integer NOT NULL,
        CONSTRAINT "PK_AttributeRequirement" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AttributeRequirement_AttributeDefinition_AttributeId" FOREIGN KEY ("AttributeId") REFERENCES config."AttributeDefinition" ("Id"),
        CONSTRAINT "FK_AttributeRequirement_GameMapDefinition_GameMapDefinitionId" FOREIGN KEY ("GameMapDefinitionId") REFERENCES config."GameMapDefinition" ("Id"),
        CONSTRAINT "FK_AttributeRequirement_ItemDefinition_ItemDefinitionId" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemDropItemGroup" (
        "Id" uuid NOT NULL,
        "MonsterId" uuid,
        "ItemDefinitionId" uuid,
        "Description" text NOT NULL,
        "Chance" double precision NOT NULL,
        "MinimumMonsterLevel" smallint,
        "MaximumMonsterLevel" smallint,
        "ItemLevel" smallint,
        "ItemType" integer NOT NULL,
        "SourceItemLevel" smallint NOT NULL,
        "MoneyAmount" integer NOT NULL,
        "MinimumLevel" smallint NOT NULL,
        "MaximumLevel" smallint NOT NULL,
        "RequiredCharacterLevel" smallint NOT NULL,
        "DropEffect" integer NOT NULL,
        CONSTRAINT "PK_ItemDropItemGroup" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemDropItemGroup_ItemDefinition_ItemDefinitionId" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."ItemDropItemGroupItemDefinition" (
        "ItemDropItemGroupId" uuid NOT NULL,
        "ItemDefinitionId" uuid NOT NULL,
        CONSTRAINT "PK_ItemDropItemGroupItemDefinition" PRIMARY KEY ("ItemDropItemGroupId", "ItemDefinitionId"),
        CONSTRAINT "FK_ItemDropItemGroupItemDefinition_ItemDefinition_ItemDefiniti~" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_ItemDropItemGroupItemDefinition_ItemDropItemGroup_ItemDropI~" FOREIGN KEY ("ItemDropItemGroupId") REFERENCES config."ItemDropItemGroup" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MasterSkillDefinition" (
        "Id" uuid NOT NULL,
        "RootId" uuid,
        "TargetAttributeId" uuid,
        "ReplacedSkillId" uuid,
        "Rank" smallint NOT NULL,
        "MaximumLevel" smallint NOT NULL,
        "MinimumLevel" smallint NOT NULL,
        "ValueFormula" text NOT NULL,
        "DisplayValueFormula" text NOT NULL,
        "Aggregation" integer NOT NULL,
        CONSTRAINT "PK_MasterSkillDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MasterSkillDefinition_AttributeDefinition_TargetAttributeId" FOREIGN KEY ("TargetAttributeId") REFERENCES config."AttributeDefinition" ("Id"),
        CONSTRAINT "FK_MasterSkillDefinition_MasterSkillRoot_RootId" FOREIGN KEY ("RootId") REFERENCES config."MasterSkillRoot" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."Skill" (
        "Id" uuid NOT NULL,
        "ElementalModifierTargetId" uuid,
        "MagicEffectDefId" uuid,
        "MasterDefinitionId" uuid,
        "GameConfigurationId" uuid,
        "Number" smallint NOT NULL,
        "Name" text NOT NULL,
        "Range" smallint NOT NULL,
        "DamageType" integer NOT NULL,
        "SkillType" integer NOT NULL,
        "Target" integer NOT NULL,
        "ImplicitTargetRange" smallint NOT NULL,
        "TargetRestriction" integer NOT NULL,
        "MovesToTarget" boolean NOT NULL,
        "MovesTarget" boolean NOT NULL,
        "AttackDamage" integer NOT NULL,
        CONSTRAINT "PK_Skill" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Skill_AttributeDefinition_ElementalModifierTargetId" FOREIGN KEY ("ElementalModifierTargetId") REFERENCES config."AttributeDefinition" ("Id"),
        CONSTRAINT "FK_Skill_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id"),
        CONSTRAINT "FK_Skill_MagicEffectDefinition_MagicEffectDefId" FOREIGN KEY ("MagicEffectDefId") REFERENCES config."MagicEffectDefinition" ("Id"),
        CONSTRAINT "FK_Skill_MasterSkillDefinition_MasterDefinitionId" FOREIGN KEY ("MasterDefinitionId") REFERENCES config."MasterSkillDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MasterSkillDefinitionSkill" (
        "MasterSkillDefinitionId" uuid NOT NULL,
        "SkillId" uuid NOT NULL,
        CONSTRAINT "PK_MasterSkillDefinitionSkill" PRIMARY KEY ("MasterSkillDefinitionId", "SkillId"),
        CONSTRAINT "FK_MasterSkillDefinitionSkill_MasterSkillDefinition_MasterSkil~" FOREIGN KEY ("MasterSkillDefinitionId") REFERENCES config."MasterSkillDefinition" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_MasterSkillDefinitionSkill_Skill_SkillId" FOREIGN KEY ("SkillId") REFERENCES config."Skill" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MonsterDefinition" (
        "Id" uuid NOT NULL,
        "AttackSkillId" uuid,
        "MerchantStoreId" uuid,
        "GameConfigurationId" uuid,
        "Number" smallint NOT NULL,
        "Designation" text NOT NULL,
        "MoveRange" smallint NOT NULL,
        "AttackRange" smallint NOT NULL,
        "ViewRange" smallint NOT NULL,
        "MoveDelay" interval NOT NULL,
        "AttackDelay" interval NOT NULL,
        "RespawnDelay" interval NOT NULL,
        "Attribute" smallint NOT NULL,
        "NumberOfMaximumItemDrops" integer NOT NULL,
        "NpcWindow" integer NOT NULL,
        "ObjectKind" integer NOT NULL,
        "IntelligenceTypeName" text,
        CONSTRAINT "PK_MonsterDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MonsterDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id"),
        CONSTRAINT "FK_MonsterDefinition_ItemStorage_MerchantStoreId" FOREIGN KEY ("MerchantStoreId") REFERENCES data."ItemStorage" ("Id"),
        CONSTRAINT "FK_MonsterDefinition_Skill_AttackSkillId" FOREIGN KEY ("AttackSkillId") REFERENCES config."Skill" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."SkillCharacterClass" (
        "SkillId" uuid NOT NULL,
        "CharacterClassId" uuid NOT NULL,
        CONSTRAINT "PK_SkillCharacterClass" PRIMARY KEY ("SkillId", "CharacterClassId"),
        CONSTRAINT "FK_SkillCharacterClass_CharacterClass_CharacterClassId" FOREIGN KEY ("CharacterClassId") REFERENCES config."CharacterClass" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_SkillCharacterClass_Skill_SkillId" FOREIGN KEY ("SkillId") REFERENCES config."Skill" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."SkillEntry" (
        "Id" uuid NOT NULL,
        "SkillId" uuid,
        "CharacterId" uuid,
        "Level" integer NOT NULL,
        CONSTRAINT "PK_SkillEntry" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_SkillEntry_Character_CharacterId" FOREIGN KEY ("CharacterId") REFERENCES data."Character" ("Id"),
        CONSTRAINT "FK_SkillEntry_Skill_SkillId" FOREIGN KEY ("SkillId") REFERENCES config."Skill" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MiniGameReward" (
        "Id" uuid NOT NULL,
        "ItemRewardId" uuid,
        "RequiredKillId" uuid,
        "MiniGameDefinitionId" uuid,
        "Rank" integer,
        "RewardType" integer NOT NULL,
        "RewardAmount" integer NOT NULL,
        "RequiredSuccess" integer NOT NULL,
        CONSTRAINT "PK_MiniGameReward" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MiniGameReward_DropItemGroup_ItemRewardId" FOREIGN KEY ("ItemRewardId") REFERENCES config."DropItemGroup" ("Id"),
        CONSTRAINT "FK_MiniGameReward_MiniGameDefinition_MiniGameDefinitionId" FOREIGN KEY ("MiniGameDefinitionId") REFERENCES config."MiniGameDefinition" ("Id"),
        CONSTRAINT "FK_MiniGameReward_MonsterDefinition_RequiredKillId" FOREIGN KEY ("RequiredKillId") REFERENCES config."MonsterDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MonsterAttribute" (
        "Id" uuid NOT NULL,
        "AttributeDefinitionId" uuid,
        "MonsterDefinitionId" uuid,
        "Value" real NOT NULL,
        CONSTRAINT "PK_MonsterAttribute" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MonsterAttribute_AttributeDefinition_AttributeDefinitionId" FOREIGN KEY ("AttributeDefinitionId") REFERENCES config."AttributeDefinition" ("Id"),
        CONSTRAINT "FK_MonsterAttribute_MonsterDefinition_MonsterDefinitionId" FOREIGN KEY ("MonsterDefinitionId") REFERENCES config."MonsterDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MonsterDefinitionDropItemGroup" (
        "MonsterDefinitionId" uuid NOT NULL,
        "DropItemGroupId" uuid NOT NULL,
        CONSTRAINT "PK_MonsterDefinitionDropItemGroup" PRIMARY KEY ("MonsterDefinitionId", "DropItemGroupId"),
        CONSTRAINT "FK_MonsterDefinitionDropItemGroup_DropItemGroup_DropItemGroupId" FOREIGN KEY ("DropItemGroupId") REFERENCES config."DropItemGroup" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_MonsterDefinitionDropItemGroup_MonsterDefinition_MonsterDef~" FOREIGN KEY ("MonsterDefinitionId") REFERENCES config."MonsterDefinition" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MonsterSpawnArea" (
        "Id" uuid NOT NULL,
        "MonsterDefinitionId" uuid,
        "GameMapId" uuid,
        "X1" smallint NOT NULL,
        "Y1" smallint NOT NULL,
        "X2" smallint NOT NULL,
        "Y2" smallint NOT NULL,
        "Direction" integer NOT NULL,
        "Quantity" smallint NOT NULL,
        "SpawnTrigger" integer NOT NULL,
        "WaveNumber" smallint NOT NULL,
        "MaximumHealthOverride" integer,
        CONSTRAINT "PK_MonsterSpawnArea" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MonsterSpawnArea_GameMapDefinition_GameMapId" FOREIGN KEY ("GameMapId") REFERENCES config."GameMapDefinition" ("Id"),
        CONSTRAINT "FK_MonsterSpawnArea_MonsterDefinition_MonsterDefinitionId" FOREIGN KEY ("MonsterDefinitionId") REFERENCES config."MonsterDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."QuestDefinition" (
        "Id" uuid NOT NULL,
        "QuestGiverId" uuid,
        "QualifiedCharacterId" uuid,
        "MonsterDefinitionId" uuid,
        "Name" text NOT NULL,
        "Group" smallint NOT NULL,
        "Number" smallint NOT NULL,
        "StartingNumber" smallint NOT NULL,
        "RefuseNumber" smallint NOT NULL,
        "Repeatable" boolean NOT NULL,
        "RequiresClientAction" boolean NOT NULL,
        "RequiredStartMoney" integer NOT NULL,
        "MinimumCharacterLevel" integer NOT NULL,
        "MaximumCharacterLevel" integer NOT NULL,
        CONSTRAINT "PK_QuestDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_QuestDefinition_CharacterClass_QualifiedCharacterId" FOREIGN KEY ("QualifiedCharacterId") REFERENCES config."CharacterClass" ("Id"),
        CONSTRAINT "FK_QuestDefinition_MonsterDefinition_MonsterDefinitionId" FOREIGN KEY ("MonsterDefinitionId") REFERENCES config."MonsterDefinition" ("Id"),
        CONSTRAINT "FK_QuestDefinition_MonsterDefinition_QuestGiverId" FOREIGN KEY ("QuestGiverId") REFERENCES config."MonsterDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MiniGameChangeEvent" (
        "Id" uuid NOT NULL,
        "TargetDefinitionId" uuid,
        "SpawnAreaId" uuid,
        "MiniGameDefinitionId" uuid,
        "Index" integer NOT NULL,
        "Description" text,
        "Message" text,
        "Target" integer NOT NULL,
        "MinimumTargetLevel" smallint,
        "NumberOfKills" smallint NOT NULL,
        "MultiplyKillsByPlayers" boolean NOT NULL,
        CONSTRAINT "PK_MiniGameChangeEvent" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MiniGameChangeEvent_MiniGameDefinition_MiniGameDefinitionId" FOREIGN KEY ("MiniGameDefinitionId") REFERENCES config."MiniGameDefinition" ("Id"),
        CONSTRAINT "FK_MiniGameChangeEvent_MonsterDefinition_TargetDefinitionId" FOREIGN KEY ("TargetDefinitionId") REFERENCES config."MonsterDefinition" ("Id"),
        CONSTRAINT "FK_MiniGameChangeEvent_MonsterSpawnArea_SpawnAreaId" FOREIGN KEY ("SpawnAreaId") REFERENCES config."MonsterSpawnArea" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."QuestItemRequirement" (
        "Id" uuid NOT NULL,
        "ItemId" uuid,
        "DropItemGroupId" uuid,
        "QuestDefinitionId" uuid,
        "MinimumNumber" integer NOT NULL,
        CONSTRAINT "PK_QuestItemRequirement" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_QuestItemRequirement_DropItemGroup_DropItemGroupId" FOREIGN KEY ("DropItemGroupId") REFERENCES config."DropItemGroup" ("Id"),
        CONSTRAINT "FK_QuestItemRequirement_ItemDefinition_ItemId" FOREIGN KEY ("ItemId") REFERENCES config."ItemDefinition" ("Id"),
        CONSTRAINT "FK_QuestItemRequirement_QuestDefinition_QuestDefinitionId" FOREIGN KEY ("QuestDefinitionId") REFERENCES config."QuestDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."QuestMonsterKillRequirement" (
        "Id" uuid NOT NULL,
        "MonsterId" uuid,
        "QuestDefinitionId" uuid,
        "MinimumNumber" integer NOT NULL,
        CONSTRAINT "PK_QuestMonsterKillRequirement" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_QuestMonsterKillRequirement_MonsterDefinition_MonsterId" FOREIGN KEY ("MonsterId") REFERENCES config."MonsterDefinition" ("Id"),
        CONSTRAINT "FK_QuestMonsterKillRequirement_QuestDefinition_QuestDefinition~" FOREIGN KEY ("QuestDefinitionId") REFERENCES config."QuestDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."QuestReward" (
        "Id" uuid NOT NULL,
        "ItemRewardId" uuid,
        "AttributeRewardId" uuid,
        "SkillRewardId" uuid,
        "QuestDefinitionId" uuid,
        "RewardType" integer NOT NULL,
        "Value" integer NOT NULL,
        CONSTRAINT "PK_QuestReward" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_QuestReward_AttributeDefinition_AttributeRewardId" FOREIGN KEY ("AttributeRewardId") REFERENCES config."AttributeDefinition" ("Id"),
        CONSTRAINT "FK_QuestReward_Item_ItemRewardId" FOREIGN KEY ("ItemRewardId") REFERENCES data."Item" ("Id"),
        CONSTRAINT "FK_QuestReward_QuestDefinition_QuestDefinitionId" FOREIGN KEY ("QuestDefinitionId") REFERENCES config."QuestDefinition" ("Id"),
        CONSTRAINT "FK_QuestReward_Skill_SkillRewardId" FOREIGN KEY ("SkillRewardId") REFERENCES config."Skill" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE config."MiniGameTerrainChange" (
        "Id" uuid NOT NULL,
        "MiniGameChangeEventId" uuid,
        "TerrainAttribute" integer NOT NULL,
        "SetTerrainAttribute" boolean NOT NULL,
        "StartX" smallint NOT NULL,
        "StartY" smallint NOT NULL,
        "EndX" smallint NOT NULL,
        "EndY" smallint NOT NULL,
        CONSTRAINT "PK_MiniGameTerrainChange" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MiniGameTerrainChange_MiniGameChangeEvent_MiniGameChangeEve~" FOREIGN KEY ("MiniGameChangeEventId") REFERENCES config."MiniGameChangeEvent" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE TABLE data."QuestMonsterKillRequirementState" (
        "Id" uuid NOT NULL,
        "RequirementId" uuid,
        "CharacterQuestStateId" uuid,
        "KillCount" integer NOT NULL,
        CONSTRAINT "PK_QuestMonsterKillRequirementState" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_QuestMonsterKillRequirementState_CharacterQuestState_Charac~" FOREIGN KEY ("CharacterQuestStateId") REFERENCES data."CharacterQuestState" ("Id"),
        CONSTRAINT "FK_QuestMonsterKillRequirementState_QuestMonsterKillRequiremen~" FOREIGN KEY ("RequirementId") REFERENCES config."QuestMonsterKillRequirement" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE UNIQUE INDEX "IX_Account_LoginName" ON data."Account" ("LoginName");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Account_VaultId" ON data."Account" ("VaultId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_AccountCharacterClass_CharacterClassId" ON data."AccountCharacterClass" ("CharacterClassId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_AppearanceData_CharacterClassId" ON data."AppearanceData" ("CharacterClassId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_AttributeDefinition_GameConfigurationId" ON config."AttributeDefinition" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_AttributeRelationship_CharacterClassId" ON config."AttributeRelationship" ("CharacterClassId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_AttributeRelationship_InputAttributeId" ON config."AttributeRelationship" ("InputAttributeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_AttributeRelationship_PowerUpDefinitionValueId" ON config."AttributeRelationship" ("PowerUpDefinitionValueId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_AttributeRelationship_TargetAttributeId" ON config."AttributeRelationship" ("TargetAttributeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_AttributeRequirement_AttributeId" ON config."AttributeRequirement" ("AttributeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_AttributeRequirement_GameMapDefinitionId" ON config."AttributeRequirement" ("GameMapDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_AttributeRequirement_ItemDefinitionId" ON config."AttributeRequirement" ("ItemDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_AttributeRequirement_SkillId" ON config."AttributeRequirement" ("SkillId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_AttributeRequirement_SkillId1" ON config."AttributeRequirement" ("SkillId1");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_BattleZoneDefinition_GroundId" ON config."BattleZoneDefinition" ("GroundId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_BattleZoneDefinition_LeftGoalId" ON config."BattleZoneDefinition" ("LeftGoalId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_BattleZoneDefinition_RightGoalId" ON config."BattleZoneDefinition" ("RightGoalId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Character_AccountId" ON data."Character" ("AccountId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Character_CharacterClassId" ON data."Character" ("CharacterClassId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Character_CurrentMapId" ON data."Character" ("CurrentMapId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Character_InventoryId" ON data."Character" ("InventoryId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE UNIQUE INDEX "IX_Character_Name" ON data."Character" ("Name");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_CharacterClass_GameConfigurationId" ON config."CharacterClass" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_CharacterClass_HomeMapId" ON config."CharacterClass" ("HomeMapId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_CharacterClass_NextGenerationClassId" ON config."CharacterClass" ("NextGenerationClassId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_CharacterDropItemGroup_DropItemGroupId" ON data."CharacterDropItemGroup" ("DropItemGroupId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_CharacterQuestState_ActiveQuestId" ON data."CharacterQuestState" ("ActiveQuestId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_CharacterQuestState_CharacterId" ON data."CharacterQuestState" ("CharacterId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_CharacterQuestState_LastFinishedQuestId" ON data."CharacterQuestState" ("LastFinishedQuestId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ChatServerEndpoint_ChatServerDefinitionId" ON config."ChatServerEndpoint" ("ChatServerDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ChatServerEndpoint_ClientId" ON config."ChatServerEndpoint" ("ClientId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_CombinationBonusRequirement_ItemOptionCombinationBonusId" ON config."CombinationBonusRequirement" ("ItemOptionCombinationBonusId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_CombinationBonusRequirement_OptionTypeId" ON config."CombinationBonusRequirement" ("OptionTypeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ConnectServerDefinition_ClientId" ON config."ConnectServerDefinition" ("ClientId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ConstValueAttribute_CharacterClassId" ON config."ConstValueAttribute" ("CharacterClassId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ConstValueAttribute_DefinitionId" ON config."ConstValueAttribute" ("DefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_DropItemGroup_GameConfigurationId" ON config."DropItemGroup" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_DropItemGroup_MonsterId" ON config."DropItemGroup" ("MonsterId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_DropItemGroupItemDefinition_ItemDefinitionId" ON config."DropItemGroupItemDefinition" ("ItemDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_EnterGate_GameMapDefinitionId" ON config."EnterGate" ("GameMapDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_EnterGate_TargetGateId" ON config."EnterGate" ("TargetGateId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ExitGate_MapId" ON config."ExitGate" ("MapId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_GameMapDefinition_BattleZoneId" ON config."GameMapDefinition" ("BattleZoneId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_GameMapDefinition_GameConfigurationId" ON config."GameMapDefinition" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_GameMapDefinition_SafezoneMapId" ON config."GameMapDefinition" ("SafezoneMapId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_GameMapDefinitionDropItemGroup_DropItemGroupId" ON config."GameMapDefinitionDropItemGroup" ("DropItemGroupId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_GameServerConfigurationGameMapDefinition_GameMapDefinitionId" ON config."GameServerConfigurationGameMapDefinition" ("GameMapDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_GameServerDefinition_GameConfigurationId" ON config."GameServerDefinition" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_GameServerDefinition_ServerConfigurationId" ON config."GameServerDefinition" ("ServerConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_GameServerEndpoint_ClientId" ON config."GameServerEndpoint" ("ClientId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_GameServerEndpoint_GameServerDefinitionId" ON config."GameServerEndpoint" ("GameServerDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Guild_AllianceGuildId" ON guild."Guild" ("AllianceGuildId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Guild_HostilityId" ON guild."Guild" ("HostilityId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE UNIQUE INDEX "IX_Guild_Name" ON guild."Guild" ("Name");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_GuildMember_GuildId" ON guild."GuildMember" ("GuildId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_IncreasableItemOption_ItemOptionDefinitionId" ON config."IncreasableItemOption" ("ItemOptionDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_IncreasableItemOption_ItemSetGroupId" ON config."IncreasableItemOption" ("ItemSetGroupId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_IncreasableItemOption_OptionTypeId" ON config."IncreasableItemOption" ("OptionTypeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_IncreasableItemOption_PowerUpDefinitionId" ON config."IncreasableItemOption" ("PowerUpDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Item_DefinitionId" ON data."Item" ("DefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Item_ItemStorageId" ON data."Item" ("ItemStorageId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemAppearance_AppearanceDataId" ON data."ItemAppearance" ("AppearanceDataId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemAppearance_DefinitionId" ON data."ItemAppearance" ("DefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemAppearanceItemOptionType_ItemOptionTypeId" ON data."ItemAppearanceItemOptionType" ("ItemOptionTypeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemBasePowerUpDefinition_BonusPerLevelTableId" ON config."ItemBasePowerUpDefinition" ("BonusPerLevelTableId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemBasePowerUpDefinition_ItemDefinitionId" ON config."ItemBasePowerUpDefinition" ("ItemDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemBasePowerUpDefinition_TargetAttributeId" ON config."ItemBasePowerUpDefinition" ("TargetAttributeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemCrafting_MonsterDefinitionId" ON config."ItemCrafting" ("MonsterDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemCrafting_SimpleCraftingSettingsId" ON config."ItemCrafting" ("SimpleCraftingSettingsId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemCraftingRequiredItem_SimpleCraftingSettingsId" ON config."ItemCraftingRequiredItem" ("SimpleCraftingSettingsId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemCraftingRequiredItemItemDefinition_ItemDefinitionId" ON config."ItemCraftingRequiredItemItemDefinition" ("ItemDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemCraftingRequiredItemItemOptionType_ItemOptionTypeId" ON config."ItemCraftingRequiredItemItemOptionType" ("ItemOptionTypeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemCraftingResultItem_ItemDefinitionId" ON config."ItemCraftingResultItem" ("ItemDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemCraftingResultItem_SimpleCraftingSettingsId" ON config."ItemCraftingResultItem" ("SimpleCraftingSettingsId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemDefinition_ConsumeEffectId" ON config."ItemDefinition" ("ConsumeEffectId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemDefinition_GameConfigurationId" ON config."ItemDefinition" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemDefinition_ItemSlotId" ON config."ItemDefinition" ("ItemSlotId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemDefinition_SkillId" ON config."ItemDefinition" ("SkillId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemDefinition_ItemGroupId" ON config."ItemDefinition" ("ItemGroupId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemDefinitionCharacterClass_CharacterClassId" ON config."ItemDefinitionCharacterClass" ("CharacterClassId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemDefinitionItemOptionDefinition_ItemOptionDefinitionId" ON config."ItemDefinitionItemOptionDefinition" ("ItemOptionDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemDefinitionItemSetGroup_ItemSetGroupId" ON config."ItemDefinitionItemSetGroup" ("ItemSetGroupId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemDropItemGroup_ItemDefinitionId" ON config."ItemDropItemGroup" ("ItemDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemDropItemGroup_MonsterId" ON config."ItemDropItemGroup" ("MonsterId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemDropItemGroupItemDefinition_ItemDefinitionId" ON config."ItemDropItemGroupItemDefinition" ("ItemDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemItemOfItemSet_ItemOfItemSetId" ON data."ItemItemOfItemSet" ("ItemOfItemSetId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemLevelBonusTable_GameConfigurationId" ON config."ItemLevelBonusTable" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemOfItemSet_BonusOptionId" ON config."ItemOfItemSet" ("BonusOptionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemOfItemSet_ItemDefinitionId" ON config."ItemOfItemSet" ("ItemDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemOfItemSet_ItemSetGroupId" ON config."ItemOfItemSet" ("ItemSetGroupId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemOptionCombinationBonus_BonusId" ON config."ItemOptionCombinationBonus" ("BonusId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemOptionCombinationBonus_GameConfigurationId" ON config."ItemOptionCombinationBonus" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemOptionDefinition_GameConfigurationId" ON config."ItemOptionDefinition" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemOptionLink_ItemId" ON data."ItemOptionLink" ("ItemId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemOptionLink_ItemOptionId" ON data."ItemOptionLink" ("ItemOptionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemOptionOfLevel_IncreasableItemOptionId" ON config."ItemOptionOfLevel" ("IncreasableItemOptionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemOptionOfLevel_PowerUpDefinitionId" ON config."ItemOptionOfLevel" ("PowerUpDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemOptionType_GameConfigurationId" ON config."ItemOptionType" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemSetGroup_GameConfigurationId" ON config."ItemSetGroup" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_ItemSlotType_GameConfigurationId" ON config."ItemSlotType" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_JewelMix_GameConfigurationId" ON config."JewelMix" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_JewelMix_MixedJewelId" ON config."JewelMix" ("MixedJewelId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_JewelMix_SingleJewelId" ON config."JewelMix" ("SingleJewelId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_LetterBody_HeaderId" ON data."LetterBody" ("HeaderId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_LetterBody_SenderAppearanceId" ON data."LetterBody" ("SenderAppearanceId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_LetterHeader_ReceiverId" ON data."LetterHeader" ("ReceiverId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_LevelBonus_ItemLevelBonusTableId" ON config."LevelBonus" ("ItemLevelBonusTableId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MagicEffectDefinition_DurationId" ON config."MagicEffectDefinition" ("DurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MagicEffectDefinition_GameConfigurationId" ON config."MagicEffectDefinition" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MasterSkillDefinition_ReplacedSkillId" ON config."MasterSkillDefinition" ("ReplacedSkillId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MasterSkillDefinition_RootId" ON config."MasterSkillDefinition" ("RootId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MasterSkillDefinition_TargetAttributeId" ON config."MasterSkillDefinition" ("TargetAttributeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MasterSkillDefinitionSkill_SkillId" ON config."MasterSkillDefinitionSkill" ("SkillId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MasterSkillRoot_GameConfigurationId" ON config."MasterSkillRoot" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameChangeEvent_MiniGameDefinitionId" ON config."MiniGameChangeEvent" ("MiniGameDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameChangeEvent_SpawnAreaId" ON config."MiniGameChangeEvent" ("SpawnAreaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameChangeEvent_TargetDefinitionId" ON config."MiniGameChangeEvent" ("TargetDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameDefinition_EntranceId" ON config."MiniGameDefinition" ("EntranceId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameDefinition_GameConfigurationId" ON config."MiniGameDefinition" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameDefinition_TicketItemId" ON config."MiniGameDefinition" ("TicketItemId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameRankingEntry_CharacterId" ON data."MiniGameRankingEntry" ("CharacterId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameRankingEntry_MiniGameId" ON data."MiniGameRankingEntry" ("MiniGameId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameReward_ItemRewardId" ON config."MiniGameReward" ("ItemRewardId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameReward_MiniGameDefinitionId" ON config."MiniGameReward" ("MiniGameDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameReward_RequiredKillId" ON config."MiniGameReward" ("RequiredKillId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameSpawnWave_MiniGameDefinitionId" ON config."MiniGameSpawnWave" ("MiniGameDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MiniGameTerrainChange_MiniGameChangeEventId" ON config."MiniGameTerrainChange" ("MiniGameChangeEventId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MonsterAttribute_AttributeDefinitionId" ON config."MonsterAttribute" ("AttributeDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MonsterAttribute_MonsterDefinitionId" ON config."MonsterAttribute" ("MonsterDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MonsterDefinition_AttackSkillId" ON config."MonsterDefinition" ("AttackSkillId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MonsterDefinition_GameConfigurationId" ON config."MonsterDefinition" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MonsterDefinition_MerchantStoreId" ON config."MonsterDefinition" ("MerchantStoreId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MonsterDefinitionDropItemGroup_DropItemGroupId" ON config."MonsterDefinitionDropItemGroup" ("DropItemGroupId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MonsterSpawnArea_GameMapId" ON config."MonsterSpawnArea" ("GameMapId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_MonsterSpawnArea_MonsterDefinitionId" ON config."MonsterSpawnArea" ("MonsterDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_PlugInConfiguration_GameConfigurationId" ON config."PlugInConfiguration" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_PowerUpDefinition_BoostId" ON config."PowerUpDefinition" ("BoostId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_PowerUpDefinition_MagicEffectDefinitionId" ON config."PowerUpDefinition" ("MagicEffectDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_PowerUpDefinition_TargetAttributeId" ON config."PowerUpDefinition" ("TargetAttributeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestDefinition_MonsterDefinitionId" ON config."QuestDefinition" ("MonsterDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestDefinition_QualifiedCharacterId" ON config."QuestDefinition" ("QualifiedCharacterId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestDefinition_QuestGiverId" ON config."QuestDefinition" ("QuestGiverId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestItemRequirement_DropItemGroupId" ON config."QuestItemRequirement" ("DropItemGroupId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestItemRequirement_ItemId" ON config."QuestItemRequirement" ("ItemId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestItemRequirement_QuestDefinitionId" ON config."QuestItemRequirement" ("QuestDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestMonsterKillRequirement_MonsterId" ON config."QuestMonsterKillRequirement" ("MonsterId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestMonsterKillRequirement_QuestDefinitionId" ON config."QuestMonsterKillRequirement" ("QuestDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestMonsterKillRequirementState_CharacterQuestStateId" ON data."QuestMonsterKillRequirementState" ("CharacterQuestStateId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestMonsterKillRequirementState_RequirementId" ON data."QuestMonsterKillRequirementState" ("RequirementId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestReward_AttributeRewardId" ON config."QuestReward" ("AttributeRewardId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestReward_ItemRewardId" ON config."QuestReward" ("ItemRewardId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestReward_QuestDefinitionId" ON config."QuestReward" ("QuestDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_QuestReward_SkillRewardId" ON config."QuestReward" ("SkillRewardId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Skill_ElementalModifierTargetId" ON config."Skill" ("ElementalModifierTargetId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Skill_GameConfigurationId" ON config."Skill" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Skill_MagicEffectDefId" ON config."Skill" ("MagicEffectDefId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_Skill_MasterDefinitionId" ON config."Skill" ("MasterDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_SkillCharacterClass_CharacterClassId" ON config."SkillCharacterClass" ("CharacterClassId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_SkillEntry_CharacterId" ON data."SkillEntry" ("CharacterId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_SkillEntry_SkillId" ON data."SkillEntry" ("SkillId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_StatAttribute_CharacterId" ON data."StatAttribute" ("CharacterId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_StatAttribute_DefinitionId" ON data."StatAttribute" ("DefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_StatAttributeDefinition_AttributeId" ON config."StatAttributeDefinition" ("AttributeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_StatAttributeDefinition_CharacterClassId" ON config."StatAttributeDefinition" ("CharacterClassId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_WarpInfo_GameConfigurationId" ON config."WarpInfo" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    CREATE INDEX "IX_WarpInfo_GateId" ON config."WarpInfo" ("GateId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE data."CharacterDropItemGroup" ADD CONSTRAINT "FK_CharacterDropItemGroup_DropItemGroup_DropItemGroupId" FOREIGN KEY ("DropItemGroupId") REFERENCES config."DropItemGroup" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE data."CharacterQuestState" ADD CONSTRAINT "FK_CharacterQuestState_QuestDefinition_ActiveQuestId" FOREIGN KEY ("ActiveQuestId") REFERENCES config."QuestDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE data."CharacterQuestState" ADD CONSTRAINT "FK_CharacterQuestState_QuestDefinition_LastFinishedQuestId" FOREIGN KEY ("LastFinishedQuestId") REFERENCES config."QuestDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE config."DropItemGroup" ADD CONSTRAINT "FK_DropItemGroup_MonsterDefinition_MonsterId" FOREIGN KEY ("MonsterId") REFERENCES config."MonsterDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE config."DropItemGroupItemDefinition" ADD CONSTRAINT "FK_DropItemGroupItemDefinition_ItemDefinition_ItemDefinitionId" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE data."Item" ADD CONSTRAINT "FK_Item_ItemDefinition_DefinitionId" FOREIGN KEY ("DefinitionId") REFERENCES config."ItemDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE data."ItemAppearance" ADD CONSTRAINT "FK_ItemAppearance_ItemDefinition_DefinitionId" FOREIGN KEY ("DefinitionId") REFERENCES config."ItemDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE config."ItemBasePowerUpDefinition" ADD CONSTRAINT "FK_ItemBasePowerUpDefinition_ItemDefinition_ItemDefinitionId" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE config."ItemCrafting" ADD CONSTRAINT "FK_ItemCrafting_MonsterDefinition_MonsterDefinitionId" FOREIGN KEY ("MonsterDefinitionId") REFERENCES config."MonsterDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE config."ItemCraftingRequiredItemItemDefinition" ADD CONSTRAINT "FK_ItemCraftingRequiredItemItemDefinition_ItemDefinition_ItemD~" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE config."ItemCraftingResultItem" ADD CONSTRAINT "FK_ItemCraftingResultItem_ItemDefinition_ItemDefinitionId" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE config."ItemDefinition" ADD CONSTRAINT "FK_ItemDefinition_Skill_SkillId" FOREIGN KEY ("SkillId") REFERENCES config."Skill" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE config."AttributeRequirement" ADD CONSTRAINT "FK_AttributeRequirement_Skill_SkillId" FOREIGN KEY ("SkillId") REFERENCES config."Skill" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE config."AttributeRequirement" ADD CONSTRAINT "FK_AttributeRequirement_Skill_SkillId1" FOREIGN KEY ("SkillId1") REFERENCES config."Skill" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE config."ItemDropItemGroup" ADD CONSTRAINT "FK_ItemDropItemGroup_MonsterDefinition_MonsterId" FOREIGN KEY ("MonsterId") REFERENCES config."MonsterDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    ALTER TABLE config."MasterSkillDefinition" ADD CONSTRAINT "FK_MasterSkillDefinition_Skill_ReplacedSkillId" FOREIGN KEY ("ReplacedSkillId") REFERENCES config."Skill" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '00000000000000_Initial') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('00000000000000_Initial', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221008183306_PetLevels') THEN
    ALTER TABLE config."ItemDefinition" ADD "PetExperienceFormula" text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221008183306_PetLevels') THEN
    ALTER TABLE data."Item" ADD "PetExperience" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221008183306_PetLevels') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20221008183306_PetLevels', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221018194652_Combo') THEN
    ALTER TABLE config."CharacterClass" ADD "ComboDefinitionId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221018194652_Combo') THEN
    CREATE TABLE config."SkillComboDefinition" (
        "Id" uuid NOT NULL,
        "Name" text NOT NULL,
        "MaximumCompletionTime" interval NOT NULL,
        CONSTRAINT "PK_SkillComboDefinition" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221018194652_Combo') THEN
    CREATE TABLE config."SkillComboStep" (
        "Id" uuid NOT NULL,
        "SkillId" uuid,
        "SkillComboDefinitionId" uuid,
        "Order" integer NOT NULL,
        "IsFinalStep" boolean NOT NULL,
        CONSTRAINT "PK_SkillComboStep" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_SkillComboStep_Skill_SkillId" FOREIGN KEY ("SkillId") REFERENCES config."Skill" ("Id"),
        CONSTRAINT "FK_SkillComboStep_SkillComboDefinition_SkillComboDefinitionId" FOREIGN KEY ("SkillComboDefinitionId") REFERENCES config."SkillComboDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221018194652_Combo') THEN
    CREATE INDEX "IX_CharacterClass_ComboDefinitionId" ON config."CharacterClass" ("ComboDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221018194652_Combo') THEN
    CREATE INDEX "IX_SkillComboStep_SkillComboDefinitionId" ON config."SkillComboStep" ("SkillComboDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221018194652_Combo') THEN
    CREATE INDEX "IX_SkillComboStep_SkillId" ON config."SkillComboStep" ("SkillId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221018194652_Combo') THEN
    ALTER TABLE config."CharacterClass" ADD CONSTRAINT "FK_CharacterClass_SkillComboDefinition_ComboDefinitionId" FOREIGN KEY ("ComboDefinitionId") REFERENCES config."SkillComboDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221018194652_Combo') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20221018194652_Combo', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."Account" DROP CONSTRAINT "FK_Account_ItemStorage_VaultId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeDefinition" DROP CONSTRAINT "FK_AttributeDefinition_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeRelationship" DROP CONSTRAINT "FK_AttributeRelationship_CharacterClass_CharacterClassId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeRelationship" DROP CONSTRAINT "FK_AttributeRelationship_PowerUpDefinitionValue_PowerUpDefinit~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeRequirement" DROP CONSTRAINT "FK_AttributeRequirement_GameMapDefinition_GameMapDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeRequirement" DROP CONSTRAINT "FK_AttributeRequirement_ItemDefinition_ItemDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeRequirement" DROP CONSTRAINT "FK_AttributeRequirement_Skill_SkillId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeRequirement" DROP CONSTRAINT "FK_AttributeRequirement_Skill_SkillId1";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."BattleZoneDefinition" DROP CONSTRAINT "FK_BattleZoneDefinition_Rectangle_GroundId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."BattleZoneDefinition" DROP CONSTRAINT "FK_BattleZoneDefinition_Rectangle_LeftGoalId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."BattleZoneDefinition" DROP CONSTRAINT "FK_BattleZoneDefinition_Rectangle_RightGoalId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."Character" DROP CONSTRAINT "FK_Character_ItemStorage_InventoryId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."CharacterClass" DROP CONSTRAINT "FK_CharacterClass_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."CharacterClass" DROP CONSTRAINT "FK_CharacterClass_SkillComboDefinition_ComboDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."CharacterQuestState" DROP CONSTRAINT "FK_CharacterQuestState_Character_CharacterId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ChatServerEndpoint" DROP CONSTRAINT "FK_ChatServerEndpoint_ChatServerDefinition_ChatServerDefinitio~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."CombinationBonusRequirement" DROP CONSTRAINT "FK_CombinationBonusRequirement_ItemOptionCombinationBonus_Item~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."DropItemGroup" DROP CONSTRAINT "FK_DropItemGroup_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."EnterGate" DROP CONSTRAINT "FK_EnterGate_GameMapDefinition_GameMapDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ExitGate" DROP CONSTRAINT "FK_ExitGate_GameMapDefinition_MapId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."GameMapDefinition" DROP CONSTRAINT "FK_GameMapDefinition_BattleZoneDefinition_BattleZoneId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."GameMapDefinition" DROP CONSTRAINT "FK_GameMapDefinition_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."GameServerEndpoint" DROP CONSTRAINT "FK_GameServerEndpoint_GameServerDefinition_GameServerDefinitio~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."IncreasableItemOption" DROP CONSTRAINT "FK_IncreasableItemOption_ItemOptionDefinition_ItemOptionDefini~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."IncreasableItemOption" DROP CONSTRAINT "FK_IncreasableItemOption_ItemSetGroup_ItemSetGroupId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."IncreasableItemOption" DROP CONSTRAINT "FK_IncreasableItemOption_PowerUpDefinition_PowerUpDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."Item" DROP CONSTRAINT "FK_Item_ItemStorage_ItemStorageId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."ItemAppearance" DROP CONSTRAINT "FK_ItemAppearance_AppearanceData_AppearanceDataId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemBasePowerUpDefinition" DROP CONSTRAINT "FK_ItemBasePowerUpDefinition_ItemDefinition_ItemDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemCrafting" DROP CONSTRAINT "FK_ItemCrafting_MonsterDefinition_MonsterDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemCrafting" DROP CONSTRAINT "FK_ItemCrafting_SimpleCraftingSettings_SimpleCraftingSettingsId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemCraftingRequiredItem" DROP CONSTRAINT "FK_ItemCraftingRequiredItem_SimpleCraftingSettings_SimpleCraft~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemCraftingResultItem" DROP CONSTRAINT "FK_ItemCraftingResultItem_SimpleCraftingSettings_SimpleCraftin~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemDefinition" DROP CONSTRAINT "FK_ItemDefinition_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemDropItemGroup" DROP CONSTRAINT "FK_ItemDropItemGroup_ItemDefinition_ItemDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemLevelBonusTable" DROP CONSTRAINT "FK_ItemLevelBonusTable_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOfItemSet" DROP CONSTRAINT "FK_ItemOfItemSet_ItemSetGroup_ItemSetGroupId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOptionCombinationBonus" DROP CONSTRAINT "FK_ItemOptionCombinationBonus_GameConfiguration_GameConfigurat~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOptionCombinationBonus" DROP CONSTRAINT "FK_ItemOptionCombinationBonus_PowerUpDefinition_BonusId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOptionDefinition" DROP CONSTRAINT "FK_ItemOptionDefinition_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."ItemOptionLink" DROP CONSTRAINT "FK_ItemOptionLink_Item_ItemId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOptionOfLevel" DROP CONSTRAINT "FK_ItemOptionOfLevel_IncreasableItemOption_IncreasableItemOpti~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOptionOfLevel" DROP CONSTRAINT "FK_ItemOptionOfLevel_PowerUpDefinition_PowerUpDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOptionType" DROP CONSTRAINT "FK_ItemOptionType_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemSetGroup" DROP CONSTRAINT "FK_ItemSetGroup_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemSlotType" DROP CONSTRAINT "FK_ItemSlotType_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."JewelMix" DROP CONSTRAINT "FK_JewelMix_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."LetterBody" DROP CONSTRAINT "FK_LetterBody_AppearanceData_SenderAppearanceId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."LevelBonus" DROP CONSTRAINT "FK_LevelBonus_ItemLevelBonusTable_ItemLevelBonusTableId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MagicEffectDefinition" DROP CONSTRAINT "FK_MagicEffectDefinition_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MagicEffectDefinition" DROP CONSTRAINT "FK_MagicEffectDefinition_PowerUpDefinitionValue_DurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MasterSkillRoot" DROP CONSTRAINT "FK_MasterSkillRoot_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MiniGameChangeEvent" DROP CONSTRAINT "FK_MiniGameChangeEvent_MiniGameDefinition_MiniGameDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MiniGameChangeEvent" DROP CONSTRAINT "FK_MiniGameChangeEvent_MonsterSpawnArea_SpawnAreaId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MiniGameDefinition" DROP CONSTRAINT "FK_MiniGameDefinition_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MiniGameReward" DROP CONSTRAINT "FK_MiniGameReward_MiniGameDefinition_MiniGameDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MiniGameSpawnWave" DROP CONSTRAINT "FK_MiniGameSpawnWave_MiniGameDefinition_MiniGameDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MiniGameTerrainChange" DROP CONSTRAINT "FK_MiniGameTerrainChange_MiniGameChangeEvent_MiniGameChangeEve~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MonsterAttribute" DROP CONSTRAINT "FK_MonsterAttribute_MonsterDefinition_MonsterDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MonsterDefinition" DROP CONSTRAINT "FK_MonsterDefinition_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MonsterDefinition" DROP CONSTRAINT "FK_MonsterDefinition_ItemStorage_MerchantStoreId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."PlugInConfiguration" DROP CONSTRAINT "FK_PlugInConfiguration_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."PowerUpDefinition" DROP CONSTRAINT "FK_PowerUpDefinition_MagicEffectDefinition_MagicEffectDefiniti~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."PowerUpDefinition" DROP CONSTRAINT "FK_PowerUpDefinition_PowerUpDefinitionValue_BoostId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."QuestDefinition" DROP CONSTRAINT "FK_QuestDefinition_MonsterDefinition_MonsterDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."QuestItemRequirement" DROP CONSTRAINT "FK_QuestItemRequirement_QuestDefinition_QuestDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."QuestMonsterKillRequirement" DROP CONSTRAINT "FK_QuestMonsterKillRequirement_QuestDefinition_QuestDefinition~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."QuestReward" DROP CONSTRAINT "FK_QuestReward_Item_ItemRewardId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."QuestReward" DROP CONSTRAINT "FK_QuestReward_QuestDefinition_QuestDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."Skill" DROP CONSTRAINT "FK_Skill_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."Skill" DROP CONSTRAINT "FK_Skill_MasterSkillDefinition_MasterDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."SkillComboStep" DROP CONSTRAINT "FK_SkillComboStep_SkillComboDefinition_SkillComboDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."SkillEntry" DROP CONSTRAINT "FK_SkillEntry_Character_CharacterId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."StatAttribute" DROP CONSTRAINT "FK_StatAttribute_Character_CharacterId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."StatAttributeDefinition" DROP CONSTRAINT "FK_StatAttributeDefinition_CharacterClass_CharacterClassId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."WarpInfo" DROP CONSTRAINT "FK_WarpInfo_GameConfiguration_GameConfigurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_Skill_MasterDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_QuestReward_ItemRewardId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_PowerUpDefinition_BoostId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_MonsterDefinition_MerchantStoreId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_MiniGameChangeEvent_SpawnAreaId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_MagicEffectDefinition_DurationId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX data."IX_LetterBody_SenderAppearanceId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_ItemOptionOfLevel_PowerUpDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_ItemOptionCombinationBonus_BonusId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_ItemCrafting_SimpleCraftingSettingsId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_IncreasableItemOption_PowerUpDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_GameMapDefinition_BattleZoneId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_CharacterClass_ComboDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX data."IX_Character_InventoryId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_BattleZoneDefinition_GroundId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_BattleZoneDefinition_LeftGoalId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX config."IX_BattleZoneDefinition_RightGoalId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    DROP INDEX data."IX_Account_VaultId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MonsterSpawnArea" ADD "GameMapDefinitionId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."LetterHeader" ADD "CharacterId" uuid NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000';
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE TABLE config."ItemOption" (
        "Id" uuid NOT NULL,
        "OptionTypeId" uuid,
        "PowerUpDefinitionId" uuid,
        "Number" integer NOT NULL,
        "SubOptionType" integer NOT NULL,
        CONSTRAINT "PK_ItemOption" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ItemOption_ItemOptionType_OptionTypeId" FOREIGN KEY ("OptionTypeId") REFERENCES config."ItemOptionType" ("Id"),
        CONSTRAINT "FK_ItemOption_PowerUpDefinition_PowerUpDefinitionId" FOREIGN KEY ("PowerUpDefinitionId") REFERENCES config."PowerUpDefinition" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_Skill_MasterDefinitionId" ON config."Skill" ("MasterDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_QuestReward_ItemRewardId" ON config."QuestReward" ("ItemRewardId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_PowerUpDefinition_BoostId" ON config."PowerUpDefinition" ("BoostId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE INDEX "IX_MonsterSpawnArea_GameMapDefinitionId" ON config."MonsterSpawnArea" ("GameMapDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_MonsterDefinition_MerchantStoreId" ON config."MonsterDefinition" ("MerchantStoreId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_MiniGameChangeEvent_SpawnAreaId" ON config."MiniGameChangeEvent" ("SpawnAreaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_MagicEffectDefinition_DurationId" ON config."MagicEffectDefinition" ("DurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_LetterBody_SenderAppearanceId" ON data."LetterBody" ("SenderAppearanceId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_ItemOptionOfLevel_PowerUpDefinitionId" ON config."ItemOptionOfLevel" ("PowerUpDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_ItemOptionCombinationBonus_BonusId" ON config."ItemOptionCombinationBonus" ("BonusId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_ItemCrafting_SimpleCraftingSettingsId" ON config."ItemCrafting" ("SimpleCraftingSettingsId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_IncreasableItemOption_PowerUpDefinitionId" ON config."IncreasableItemOption" ("PowerUpDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_GameMapDefinition_BattleZoneId" ON config."GameMapDefinition" ("BattleZoneId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_CharacterClass_ComboDefinitionId" ON config."CharacterClass" ("ComboDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_Character_InventoryId" ON data."Character" ("InventoryId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_BattleZoneDefinition_GroundId" ON config."BattleZoneDefinition" ("GroundId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_BattleZoneDefinition_LeftGoalId" ON config."BattleZoneDefinition" ("LeftGoalId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_BattleZoneDefinition_RightGoalId" ON config."BattleZoneDefinition" ("RightGoalId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_Account_VaultId" ON data."Account" ("VaultId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE INDEX "IX_ItemOption_OptionTypeId" ON config."ItemOption" ("OptionTypeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    CREATE UNIQUE INDEX "IX_ItemOption_PowerUpDefinitionId" ON config."ItemOption" ("PowerUpDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."Account" ADD CONSTRAINT "FK_Account_ItemStorage_VaultId" FOREIGN KEY ("VaultId") REFERENCES data."ItemStorage" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeDefinition" ADD CONSTRAINT "FK_AttributeDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeRelationship" ADD CONSTRAINT "FK_AttributeRelationship_CharacterClass_CharacterClassId" FOREIGN KEY ("CharacterClassId") REFERENCES config."CharacterClass" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeRelationship" ADD CONSTRAINT "FK_AttributeRelationship_PowerUpDefinitionValue_PowerUpDefinit~" FOREIGN KEY ("PowerUpDefinitionValueId") REFERENCES config."PowerUpDefinitionValue" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeRequirement" ADD CONSTRAINT "FK_AttributeRequirement_GameMapDefinition_GameMapDefinitionId" FOREIGN KEY ("GameMapDefinitionId") REFERENCES config."GameMapDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeRequirement" ADD CONSTRAINT "FK_AttributeRequirement_ItemDefinition_ItemDefinitionId" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeRequirement" ADD CONSTRAINT "FK_AttributeRequirement_Skill_SkillId" FOREIGN KEY ("SkillId") REFERENCES config."Skill" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."AttributeRequirement" ADD CONSTRAINT "FK_AttributeRequirement_Skill_SkillId1" FOREIGN KEY ("SkillId1") REFERENCES config."Skill" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."BattleZoneDefinition" ADD CONSTRAINT "FK_BattleZoneDefinition_Rectangle_GroundId" FOREIGN KEY ("GroundId") REFERENCES config."Rectangle" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."BattleZoneDefinition" ADD CONSTRAINT "FK_BattleZoneDefinition_Rectangle_LeftGoalId" FOREIGN KEY ("LeftGoalId") REFERENCES config."Rectangle" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."BattleZoneDefinition" ADD CONSTRAINT "FK_BattleZoneDefinition_Rectangle_RightGoalId" FOREIGN KEY ("RightGoalId") REFERENCES config."Rectangle" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."Character" ADD CONSTRAINT "FK_Character_ItemStorage_InventoryId" FOREIGN KEY ("InventoryId") REFERENCES data."ItemStorage" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."CharacterClass" ADD CONSTRAINT "FK_CharacterClass_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."CharacterClass" ADD CONSTRAINT "FK_CharacterClass_SkillComboDefinition_ComboDefinitionId" FOREIGN KEY ("ComboDefinitionId") REFERENCES config."SkillComboDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."CharacterQuestState" ADD CONSTRAINT "FK_CharacterQuestState_Character_CharacterId" FOREIGN KEY ("CharacterId") REFERENCES data."Character" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ChatServerEndpoint" ADD CONSTRAINT "FK_ChatServerEndpoint_ChatServerDefinition_ChatServerDefinitio~" FOREIGN KEY ("ChatServerDefinitionId") REFERENCES config."ChatServerDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."CombinationBonusRequirement" ADD CONSTRAINT "FK_CombinationBonusRequirement_ItemOptionCombinationBonus_Item~" FOREIGN KEY ("ItemOptionCombinationBonusId") REFERENCES config."ItemOptionCombinationBonus" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."DropItemGroup" ADD CONSTRAINT "FK_DropItemGroup_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."EnterGate" ADD CONSTRAINT "FK_EnterGate_GameMapDefinition_GameMapDefinitionId" FOREIGN KEY ("GameMapDefinitionId") REFERENCES config."GameMapDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ExitGate" ADD CONSTRAINT "FK_ExitGate_GameMapDefinition_MapId" FOREIGN KEY ("MapId") REFERENCES config."GameMapDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."GameMapDefinition" ADD CONSTRAINT "FK_GameMapDefinition_BattleZoneDefinition_BattleZoneId" FOREIGN KEY ("BattleZoneId") REFERENCES config."BattleZoneDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."GameMapDefinition" ADD CONSTRAINT "FK_GameMapDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."GameServerEndpoint" ADD CONSTRAINT "FK_GameServerEndpoint_GameServerDefinition_GameServerDefinitio~" FOREIGN KEY ("GameServerDefinitionId") REFERENCES config."GameServerDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."IncreasableItemOption" ADD CONSTRAINT "FK_IncreasableItemOption_ItemOptionDefinition_ItemOptionDefini~" FOREIGN KEY ("ItemOptionDefinitionId") REFERENCES config."ItemOptionDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."IncreasableItemOption" ADD CONSTRAINT "FK_IncreasableItemOption_ItemSetGroup_ItemSetGroupId" FOREIGN KEY ("ItemSetGroupId") REFERENCES config."ItemSetGroup" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."IncreasableItemOption" ADD CONSTRAINT "FK_IncreasableItemOption_PowerUpDefinition_PowerUpDefinitionId" FOREIGN KEY ("PowerUpDefinitionId") REFERENCES config."PowerUpDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."Item" ADD CONSTRAINT "FK_Item_ItemStorage_ItemStorageId" FOREIGN KEY ("ItemStorageId") REFERENCES data."ItemStorage" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."ItemAppearance" ADD CONSTRAINT "FK_ItemAppearance_AppearanceData_AppearanceDataId" FOREIGN KEY ("AppearanceDataId") REFERENCES data."AppearanceData" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemBasePowerUpDefinition" ADD CONSTRAINT "FK_ItemBasePowerUpDefinition_ItemDefinition_ItemDefinitionId" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemCrafting" ADD CONSTRAINT "FK_ItemCrafting_MonsterDefinition_MonsterDefinitionId" FOREIGN KEY ("MonsterDefinitionId") REFERENCES config."MonsterDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemCrafting" ADD CONSTRAINT "FK_ItemCrafting_SimpleCraftingSettings_SimpleCraftingSettingsId" FOREIGN KEY ("SimpleCraftingSettingsId") REFERENCES config."SimpleCraftingSettings" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemCraftingRequiredItem" ADD CONSTRAINT "FK_ItemCraftingRequiredItem_SimpleCraftingSettings_SimpleCraft~" FOREIGN KEY ("SimpleCraftingSettingsId") REFERENCES config."SimpleCraftingSettings" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemCraftingResultItem" ADD CONSTRAINT "FK_ItemCraftingResultItem_SimpleCraftingSettings_SimpleCraftin~" FOREIGN KEY ("SimpleCraftingSettingsId") REFERENCES config."SimpleCraftingSettings" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemDefinition" ADD CONSTRAINT "FK_ItemDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemDropItemGroup" ADD CONSTRAINT "FK_ItemDropItemGroup_ItemDefinition_ItemDefinitionId" FOREIGN KEY ("ItemDefinitionId") REFERENCES config."ItemDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemLevelBonusTable" ADD CONSTRAINT "FK_ItemLevelBonusTable_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOfItemSet" ADD CONSTRAINT "FK_ItemOfItemSet_ItemSetGroup_ItemSetGroupId" FOREIGN KEY ("ItemSetGroupId") REFERENCES config."ItemSetGroup" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOptionCombinationBonus" ADD CONSTRAINT "FK_ItemOptionCombinationBonus_GameConfiguration_GameConfigurat~" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOptionCombinationBonus" ADD CONSTRAINT "FK_ItemOptionCombinationBonus_PowerUpDefinition_BonusId" FOREIGN KEY ("BonusId") REFERENCES config."PowerUpDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOptionDefinition" ADD CONSTRAINT "FK_ItemOptionDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."ItemOptionLink" ADD CONSTRAINT "FK_ItemOptionLink_Item_ItemId" FOREIGN KEY ("ItemId") REFERENCES data."Item" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOptionOfLevel" ADD CONSTRAINT "FK_ItemOptionOfLevel_IncreasableItemOption_IncreasableItemOpti~" FOREIGN KEY ("IncreasableItemOptionId") REFERENCES config."IncreasableItemOption" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOptionOfLevel" ADD CONSTRAINT "FK_ItemOptionOfLevel_PowerUpDefinition_PowerUpDefinitionId" FOREIGN KEY ("PowerUpDefinitionId") REFERENCES config."PowerUpDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemOptionType" ADD CONSTRAINT "FK_ItemOptionType_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemSetGroup" ADD CONSTRAINT "FK_ItemSetGroup_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."ItemSlotType" ADD CONSTRAINT "FK_ItemSlotType_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."JewelMix" ADD CONSTRAINT "FK_JewelMix_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."LetterBody" ADD CONSTRAINT "FK_LetterBody_AppearanceData_SenderAppearanceId" FOREIGN KEY ("SenderAppearanceId") REFERENCES data."AppearanceData" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."LevelBonus" ADD CONSTRAINT "FK_LevelBonus_ItemLevelBonusTable_ItemLevelBonusTableId" FOREIGN KEY ("ItemLevelBonusTableId") REFERENCES config."ItemLevelBonusTable" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MagicEffectDefinition" ADD CONSTRAINT "FK_MagicEffectDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MagicEffectDefinition" ADD CONSTRAINT "FK_MagicEffectDefinition_PowerUpDefinitionValue_DurationId" FOREIGN KEY ("DurationId") REFERENCES config."PowerUpDefinitionValue" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MasterSkillRoot" ADD CONSTRAINT "FK_MasterSkillRoot_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MiniGameChangeEvent" ADD CONSTRAINT "FK_MiniGameChangeEvent_MiniGameDefinition_MiniGameDefinitionId" FOREIGN KEY ("MiniGameDefinitionId") REFERENCES config."MiniGameDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MiniGameChangeEvent" ADD CONSTRAINT "FK_MiniGameChangeEvent_MonsterSpawnArea_SpawnAreaId" FOREIGN KEY ("SpawnAreaId") REFERENCES config."MonsterSpawnArea" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MiniGameDefinition" ADD CONSTRAINT "FK_MiniGameDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MiniGameReward" ADD CONSTRAINT "FK_MiniGameReward_MiniGameDefinition_MiniGameDefinitionId" FOREIGN KEY ("MiniGameDefinitionId") REFERENCES config."MiniGameDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MiniGameSpawnWave" ADD CONSTRAINT "FK_MiniGameSpawnWave_MiniGameDefinition_MiniGameDefinitionId" FOREIGN KEY ("MiniGameDefinitionId") REFERENCES config."MiniGameDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MiniGameTerrainChange" ADD CONSTRAINT "FK_MiniGameTerrainChange_MiniGameChangeEvent_MiniGameChangeEve~" FOREIGN KEY ("MiniGameChangeEventId") REFERENCES config."MiniGameChangeEvent" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MonsterAttribute" ADD CONSTRAINT "FK_MonsterAttribute_MonsterDefinition_MonsterDefinitionId" FOREIGN KEY ("MonsterDefinitionId") REFERENCES config."MonsterDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MonsterDefinition" ADD CONSTRAINT "FK_MonsterDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MonsterDefinition" ADD CONSTRAINT "FK_MonsterDefinition_ItemStorage_MerchantStoreId" FOREIGN KEY ("MerchantStoreId") REFERENCES data."ItemStorage" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."MonsterSpawnArea" ADD CONSTRAINT "FK_MonsterSpawnArea_GameMapDefinition_GameMapDefinitionId" FOREIGN KEY ("GameMapDefinitionId") REFERENCES config."GameMapDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."PlugInConfiguration" ADD CONSTRAINT "FK_PlugInConfiguration_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."PowerUpDefinition" ADD CONSTRAINT "FK_PowerUpDefinition_MagicEffectDefinition_MagicEffectDefiniti~" FOREIGN KEY ("MagicEffectDefinitionId") REFERENCES config."MagicEffectDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."PowerUpDefinition" ADD CONSTRAINT "FK_PowerUpDefinition_PowerUpDefinitionValue_BoostId" FOREIGN KEY ("BoostId") REFERENCES config."PowerUpDefinitionValue" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."QuestDefinition" ADD CONSTRAINT "FK_QuestDefinition_MonsterDefinition_MonsterDefinitionId" FOREIGN KEY ("MonsterDefinitionId") REFERENCES config."MonsterDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."QuestItemRequirement" ADD CONSTRAINT "FK_QuestItemRequirement_QuestDefinition_QuestDefinitionId" FOREIGN KEY ("QuestDefinitionId") REFERENCES config."QuestDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."QuestMonsterKillRequirement" ADD CONSTRAINT "FK_QuestMonsterKillRequirement_QuestDefinition_QuestDefinition~" FOREIGN KEY ("QuestDefinitionId") REFERENCES config."QuestDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."QuestReward" ADD CONSTRAINT "FK_QuestReward_Item_ItemRewardId" FOREIGN KEY ("ItemRewardId") REFERENCES data."Item" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."QuestReward" ADD CONSTRAINT "FK_QuestReward_QuestDefinition_QuestDefinitionId" FOREIGN KEY ("QuestDefinitionId") REFERENCES config."QuestDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."Skill" ADD CONSTRAINT "FK_Skill_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."Skill" ADD CONSTRAINT "FK_Skill_MasterSkillDefinition_MasterDefinitionId" FOREIGN KEY ("MasterDefinitionId") REFERENCES config."MasterSkillDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."SkillComboStep" ADD CONSTRAINT "FK_SkillComboStep_SkillComboDefinition_SkillComboDefinitionId" FOREIGN KEY ("SkillComboDefinitionId") REFERENCES config."SkillComboDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."SkillEntry" ADD CONSTRAINT "FK_SkillEntry_Character_CharacterId" FOREIGN KEY ("CharacterId") REFERENCES data."Character" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE data."StatAttribute" ADD CONSTRAINT "FK_StatAttribute_Character_CharacterId" FOREIGN KEY ("CharacterId") REFERENCES data."Character" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."StatAttributeDefinition" ADD CONSTRAINT "FK_StatAttributeDefinition_CharacterClass_CharacterClassId" FOREIGN KEY ("CharacterClassId") REFERENCES config."CharacterClass" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    ALTER TABLE config."WarpInfo" ADD CONSTRAINT "FK_WarpInfo_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121161552_DeleteCascade') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20221121161552_DeleteCascade', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121163220_AttributeRelationship_OperandAttribute') THEN
    ALTER TABLE config."AttributeRelationship" ADD "OperandAttributeId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121163220_AttributeRelationship_OperandAttribute') THEN
    CREATE INDEX "IX_AttributeRelationship_OperandAttributeId" ON config."AttributeRelationship" ("OperandAttributeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121163220_AttributeRelationship_OperandAttribute') THEN
    ALTER TABLE config."AttributeRelationship" ADD CONSTRAINT "FK_AttributeRelationship_AttributeDefinition_OperandAttributeId" FOREIGN KEY ("OperandAttributeId") REFERENCES config."AttributeDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221121163220_AttributeRelationship_OperandAttribute') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20221121163220_AttributeRelationship_OperandAttribute', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221128203249_RemoveConsumeHandler') THEN
    ALTER TABLE config."ItemDefinition" DROP COLUMN "ConsumeHandlerClass";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221128203249_RemoveConsumeHandler') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20221128203249_RemoveConsumeHandler', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221128204928_AddItemDropDuration') THEN
    ALTER TABLE config."GameConfiguration" ADD "ItemDropDuration" interval NOT NULL DEFAULT INTERVAL '00:01:00';
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221128204928_AddItemDropDuration') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20221128204928_AddItemDropDuration', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221221182248_MuHelper') THEN
    ALTER TABLE data."Character" ADD "MuHelperConfiguration" bytea;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20221221182248_MuHelper') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20221221182248_MuHelper', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230303185735_ConfigurationUpdate') THEN
    CREATE TABLE config."ConfigurationUpdate" (
        "Id" uuid NOT NULL,
        "Version" integer NOT NULL,
        "Name" text,
        "Description" text,
        "CreatedAt" timestamp with time zone,
        "InstalledAt" timestamp with time zone,
        CONSTRAINT "PK_ConfigurationUpdate" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230303185735_ConfigurationUpdate') THEN
    CREATE TABLE config."ConfigurationUpdateState" (
        "Id" uuid NOT NULL,
        "InitializationKey" text,
        "CurrentInstalledVersion" integer NOT NULL,
        CONSTRAINT "PK_ConfigurationUpdateState" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230303185735_ConfigurationUpdate') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20230303185735_ConfigurationUpdate', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230306185635_MiniGameExt') THEN
    ALTER TABLE config."MiniGameTerrainChange" ADD "IsClientUpdateRequired" boolean NOT NULL DEFAULT FALSE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230306185635_MiniGameExt') THEN
    ALTER TABLE data."MiniGameRankingEntry" ALTER COLUMN "Timestamp" DROP NOT NULL;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230306185635_MiniGameExt') THEN
    ALTER TABLE config."MiniGameDefinition" ADD "AllowParty" boolean NOT NULL DEFAULT FALSE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230306185635_MiniGameExt') THEN
    ALTER TABLE config."MiniGameDefinition" ADD "ArePlayerKillersAllowedToEnter" boolean NOT NULL DEFAULT FALSE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230306185635_MiniGameExt') THEN
    ALTER TABLE config."MiniGameDefinition" ADD "EntranceFee" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230306185635_MiniGameExt') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20230306185635_MiniGameExt', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230324205415_AddSystemConfiguration') THEN
    ALTER TABLE data."QuestMonsterKillRequirementState" DROP CONSTRAINT "FK_QuestMonsterKillRequirementState_CharacterQuestState_Charac~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230324205415_AddSystemConfiguration') THEN
    CREATE TABLE config."SystemConfiguration" (
        "Id" uuid NOT NULL,
        "IpResolver" integer NOT NULL,
        "IpResolverParameter" text,
        "AutoStart" boolean NOT NULL,
        "AutoUpdateSchema" boolean NOT NULL,
        "ReadConsoleInput" boolean NOT NULL,
        CONSTRAINT "PK_SystemConfiguration" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230324205415_AddSystemConfiguration') THEN
    ALTER TABLE data."QuestMonsterKillRequirementState" ADD CONSTRAINT "FK_QuestMonsterKillRequirementState_CharacterQuestState_Charac~" FOREIGN KEY ("CharacterQuestStateId") REFERENCES data."CharacterQuestState" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230324205415_AddSystemConfiguration') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20230324205415_AddSystemConfiguration', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230504172021_StorageLimitPerCharacter') THEN
    ALTER TABLE config."ItemDefinition" ADD "StorageLimitPerCharacter" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230504172021_StorageLimitPerCharacter') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20230504172021_StorageLimitPerCharacter', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230701010432_AddChatBanUntil') THEN
    ALTER TABLE data."Account" ADD "ChatBanUntil" timestamp with time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230701010432_AddChatBanUntil') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20230701010432_AddChatBanUntil', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230724154747_AccountAndMapAttributes') THEN
    ALTER TABLE data."StatAttribute" ADD "AccountId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230724154747_AccountAndMapAttributes') THEN
    ALTER TABLE config."PowerUpDefinition" ADD "GameMapDefinitionId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230724154747_AccountAndMapAttributes') THEN
    CREATE INDEX "IX_StatAttribute_AccountId" ON data."StatAttribute" ("AccountId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230724154747_AccountAndMapAttributes') THEN
    CREATE INDEX "IX_PowerUpDefinition_GameMapDefinitionId" ON config."PowerUpDefinition" ("GameMapDefinitionId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230724154747_AccountAndMapAttributes') THEN
    ALTER TABLE config."PowerUpDefinition" ADD CONSTRAINT "FK_PowerUpDefinition_GameMapDefinition_GameMapDefinitionId" FOREIGN KEY ("GameMapDefinitionId") REFERENCES config."GameMapDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230724154747_AccountAndMapAttributes') THEN
    ALTER TABLE data."StatAttribute" ADD CONSTRAINT "FK_StatAttribute_Account_AccountId" FOREIGN KEY ("AccountId") REFERENCES data."Account" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20230724154747_AccountAndMapAttributes') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20230724154747_AccountAndMapAttributes', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602060055_FixItemOptions') THEN
    ALTER TABLE config."IncreasableItemOption" DROP CONSTRAINT "FK_IncreasableItemOption_ItemSetGroup_ItemSetGroupId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602060055_FixItemOptions') THEN
    ALTER TABLE config."IncreasableItemOption" ADD CONSTRAINT "FK_IncreasableItemOption_ItemSetGroup_ItemSetGroupId" FOREIGN KEY ("ItemSetGroupId") REFERENCES config."ItemSetGroup" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602060055_FixItemOptions') THEN
    INSERT INTO config."ItemOptionDefinition" ("Id", "GameConfigurationId", "Name", "AddsRandomly", "AddChance", "MaximumOptionsPerItem")
    SELECT UUID(REPLACE(sets.setId, '00000092-','00000083-')), '00000001-0001-0000-0000-000000000000', sets.setName || ' (Ancient Set)', false, 0, 0
    FROM
    (
        SELECT COUNT(o."Id") c, text(o."ItemSetGroupId") setId, g."Name" setName
        FROM config."IncreasableItemOption" o, config."ItemSetGroup" g
        WHERE "ItemSetGroupId" is not null
          AND "ItemOptionDefinitionId" is null
          AND g."Id" = o."ItemSetGroupId"
        GROUP BY o."ItemSetGroupId", g."Name"
        ORDER BY c
    ) sets
    WHERE sets.c > 1
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602060055_FixItemOptions') THEN
    UPDATE config."IncreasableItemOption" o
    SET "ItemOptionDefinitionId" = UUID(REPLACE(TEXT(o."ItemSetGroupId"), '00000092-','00000083-'))
        WHERE o."ItemSetGroupId" is not null
          AND o."ItemOptionDefinitionId" is null
          AND o."OptionTypeId" is not null
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602060055_FixItemOptions') THEN
    INSERT INTO config."ItemOptionDefinition" ("Id", "GameConfigurationId", "Name", "AddsRandomly", "AddChance", "MaximumOptionsPerItem")
    SELECT UUID(REPLACE(sets.optionId, '00000088-','00000083-')),
            '00000001-0001-0000-0000-000000000000',
            CASE WHEN sets.setLevel=0 THEN 'Complete Set Bonus (any level)'
                ELSE 'Complete Set Bonus (Level ' || sets.setLevel || ')'
            END,
            false, 0, 0
    FROM
    (
        SELECT text(o."Id") optionId, text(o."ItemSetGroupId") setId, g."Name" setName, g."SetLevel" setLevel
        FROM config."IncreasableItemOption" o, config."ItemSetGroup" g
        WHERE "ItemSetGroupId" is not null
          AND "ItemOptionDefinitionId" is null
          AND g."Id" = o."ItemSetGroupId"
        ORDER BY setLevel
    ) sets
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602060055_FixItemOptions') THEN
    UPDATE config."IncreasableItemOption" o
    SET "ItemOptionDefinitionId" = UUID(REPLACE(TEXT(o."Id"), '00000088-','00000083-'))
        WHERE o."ItemOptionDefinitionId" is null
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602060055_FixItemOptions') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20240602060055_FixItemOptions', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602085237_FixItemOptions2') THEN
    ALTER TABLE config."IncreasableItemOption" DROP CONSTRAINT "FK_IncreasableItemOption_ItemSetGroup_ItemSetGroupId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602085237_FixItemOptions2') THEN
    DROP INDEX config."IX_IncreasableItemOption_ItemSetGroupId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602085237_FixItemOptions2') THEN
    ALTER TABLE config."IncreasableItemOption" DROP COLUMN "ItemSetGroupId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602085237_FixItemOptions2') THEN
    ALTER TABLE config."ItemSetGroup" ADD "OptionsId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602085237_FixItemOptions2') THEN
    CREATE INDEX "IX_ItemSetGroup_OptionsId" ON config."ItemSetGroup" ("OptionsId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602085237_FixItemOptions2') THEN
    ALTER TABLE config."ItemSetGroup" ADD CONSTRAINT "FK_ItemSetGroup_ItemOptionDefinition_OptionsId" FOREIGN KEY ("OptionsId") REFERENCES config."ItemOptionDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602085237_FixItemOptions2') THEN
    UPDATE config."ItemSetGroup" s
      SET "OptionsId" = UUID(REPLACE(TEXT(s."Id"), '00000092-','00000083-'))
    WHERE EXISTS(SELECT "Id" FROM config."ItemOptionDefinition" WHERE "Id" = UUID(REPLACE(TEXT(s."Id"), '00000092-','00000083-')) )
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602085237_FixItemOptions2') THEN
    UPDATE config."ItemSetGroup" s SET
      "AlwaysApplies" = true,
      "OptionsId" = 
        CASE
          WHEN "SetLevel"=0 THEN uuid('00000083-0021-0000-0000-000000000000')
          ELSE uuid('00000083-0020-000' || to_hex("SetLevel") || '-0000-000000000000')
        END
    WHERE "OptionsId" is null
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240602085237_FixItemOptions2') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20240602085237_FixItemOptions2', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240707081614_DuelConfiguration') THEN
    ALTER TABLE config."GameConfiguration" ADD "DuelConfigurationId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240707081614_DuelConfiguration') THEN
    CREATE TABLE config."DuelConfiguration" (
        "Id" uuid NOT NULL,
        "ExitId" uuid,
        "MaximumScore" integer NOT NULL,
        "EntranceFee" integer NOT NULL,
        "MinimumCharacterLevel" integer NOT NULL,
        "MaximumSpectatorsPerDuelRoom" integer NOT NULL,
        CONSTRAINT "PK_DuelConfiguration" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_DuelConfiguration_ExitGate_ExitId" FOREIGN KEY ("ExitId") REFERENCES config."ExitGate" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240707081614_DuelConfiguration') THEN
    CREATE TABLE config."DuelArea" (
        "Id" uuid NOT NULL,
        "FirstPlayerGateId" uuid,
        "SecondPlayerGateId" uuid,
        "SpectatorsGateId" uuid,
        "DuelConfigurationId" uuid,
        "Index" smallint NOT NULL,
        CONSTRAINT "PK_DuelArea" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_DuelArea_DuelConfiguration_DuelConfigurationId" FOREIGN KEY ("DuelConfigurationId") REFERENCES config."DuelConfiguration" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_DuelArea_ExitGate_FirstPlayerGateId" FOREIGN KEY ("FirstPlayerGateId") REFERENCES config."ExitGate" ("Id"),
        CONSTRAINT "FK_DuelArea_ExitGate_SecondPlayerGateId" FOREIGN KEY ("SecondPlayerGateId") REFERENCES config."ExitGate" ("Id"),
        CONSTRAINT "FK_DuelArea_ExitGate_SpectatorsGateId" FOREIGN KEY ("SpectatorsGateId") REFERENCES config."ExitGate" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240707081614_DuelConfiguration') THEN
    CREATE UNIQUE INDEX "IX_GameConfiguration_DuelConfigurationId" ON config."GameConfiguration" ("DuelConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240707081614_DuelConfiguration') THEN
    CREATE INDEX "IX_DuelArea_DuelConfigurationId" ON config."DuelArea" ("DuelConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240707081614_DuelConfiguration') THEN
    CREATE INDEX "IX_DuelArea_FirstPlayerGateId" ON config."DuelArea" ("FirstPlayerGateId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240707081614_DuelConfiguration') THEN
    CREATE INDEX "IX_DuelArea_SecondPlayerGateId" ON config."DuelArea" ("SecondPlayerGateId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240707081614_DuelConfiguration') THEN
    CREATE INDEX "IX_DuelArea_SpectatorsGateId" ON config."DuelArea" ("SpectatorsGateId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240707081614_DuelConfiguration') THEN
    CREATE INDEX "IX_DuelConfiguration_ExitId" ON config."DuelConfiguration" ("ExitId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240707081614_DuelConfiguration') THEN
    ALTER TABLE config."GameConfiguration" ADD CONSTRAINT "FK_GameConfiguration_DuelConfiguration_DuelConfigurationId" FOREIGN KEY ("DuelConfigurationId") REFERENCES config."DuelConfiguration" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240707081614_DuelConfiguration') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20240707081614_DuelConfiguration', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240714154210_FixSetOptions') THEN
    UPDATE config."ItemOptionDefinition" SET "GameConfigurationId" = (SELECT "Id" from config."GameConfiguration")
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240714154210_FixSetOptions') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20240714154210_FixSetOptions', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240805183034_ExpFormulas') THEN
    ALTER TABLE config."GameConfiguration" ADD "ExperienceFormula" text DEFAULT 'if(level == 0, 0, if(level < 256, 10 * (level + 8) * (level - 1) * (level - 1), (10 * (level + 8) * (level - 1) * (level - 1)) + (1000 * (level - 247) * (level - 256) * (level - 256))))';
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240805183034_ExpFormulas') THEN
    ALTER TABLE config."GameConfiguration" ADD "MasterExperienceFormula" text DEFAULT '(505 * level * level * level) + (35278500 * level) + (228045 * level * level)';
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240805183034_ExpFormulas') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20240805183034_ExpFormulas', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240805184944_FixGameMapMonsterSpawnRelation') THEN
    UPDATE config."MonsterSpawnArea" SET "GameMapId" = "GameMapDefinitionId" WHERE "GameMapId" is null
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240805184944_FixGameMapMonsterSpawnRelation') THEN
    ALTER TABLE config."MonsterSpawnArea" DROP CONSTRAINT "FK_MonsterSpawnArea_GameMapDefinition_GameMapDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240805184944_FixGameMapMonsterSpawnRelation') THEN
    ALTER TABLE config."MonsterSpawnArea" DROP CONSTRAINT "FK_MonsterSpawnArea_GameMapDefinition_GameMapId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240805184944_FixGameMapMonsterSpawnRelation') THEN
    DROP INDEX config."IX_MonsterSpawnArea_GameMapDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240805184944_FixGameMapMonsterSpawnRelation') THEN
    ALTER TABLE config."MonsterSpawnArea" DROP COLUMN "GameMapDefinitionId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240805184944_FixGameMapMonsterSpawnRelation') THEN
    ALTER TABLE config."MonsterSpawnArea" ADD CONSTRAINT "FK_MonsterSpawnArea_GameMapDefinition_GameMapId" FOREIGN KEY ("GameMapId") REFERENCES config."GameMapDefinition" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240805184944_FixGameMapMonsterSpawnRelation') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20240805184944_FixGameMapMonsterSpawnRelation', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240816132011_AddAggregateTypeToItemBasePowerUpDef') THEN
    ALTER TABLE config."ItemBasePowerUpDefinition" ADD "AggregateType" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240816132011_AddAggregateTypeToItemBasePowerUpDef') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20240816132011_AddAggregateTypeToItemBasePowerUpDef', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240902181002_AddPvpOptionToGameServer') THEN
    ALTER TABLE config."GameServerDefinition" ADD "PvpEnabled" boolean NOT NULL DEFAULT TRUE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20240902181002_AddPvpOptionToGameServer') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20240902181002_AddPvpOptionToGameServer', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241003093659_AddGameConfigurationMaxItemOptLevelDrop') THEN
    ALTER TABLE config."GameConfiguration" ADD "MaximumItemOptionLevelDrop" smallint NOT NULL DEFAULT 3;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241003093659_AddGameConfigurationMaxItemOptLevelDrop') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20241003093659_AddGameConfigurationMaxItemOptLevelDrop', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241018200704_AddAttributeMaximum') THEN
    ALTER TABLE config."AttributeDefinition" ADD "MaximumValue" real;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241018200704_AddAttributeMaximum') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20241018200704_AddAttributeMaximum', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241021134401_AddIncreasableItemOptionWeight') THEN
    ALTER TABLE config."IncreasableItemOption" ADD "Weight" smallint NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241021134401_AddIncreasableItemOptionWeight') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20241021134401_AddIncreasableItemOptionWeight', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241021175011_AddAreaSkillConfiguration') THEN
    ALTER TABLE config."Skill" ADD "AreaSkillSettingsId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241021175011_AddAreaSkillConfiguration') THEN
    CREATE TABLE config."AreaSkillSettings" (
        "Id" uuid NOT NULL,
        "UseFrustumFilter" boolean NOT NULL,
        "FrustumStartWidth" real NOT NULL,
        "FrustumEndWidth" real NOT NULL,
        "FrustumDistance" real NOT NULL,
        "UseTargetAreaFilter" boolean NOT NULL,
        "TargetAreaDiameter" real NOT NULL,
        "UseDeferredHits" boolean NOT NULL,
        "DelayPerOneDistance" interval NOT NULL,
        "DelayBetweenHits" interval NOT NULL,
        "MinimumNumberOfHitsPerTarget" integer NOT NULL,
        "MaximumNumberOfHitsPerTarget" integer NOT NULL,
        "MaximumNumberOfHitsPerAttack" integer NOT NULL,
        "HitChancePerDistanceMultiplier" real NOT NULL,
        CONSTRAINT "PK_AreaSkillSettings" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241021175011_AddAreaSkillConfiguration') THEN
    CREATE UNIQUE INDEX "IX_Skill_AreaSkillSettingsId" ON config."Skill" ("AreaSkillSettingsId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241021175011_AddAreaSkillConfiguration') THEN
    ALTER TABLE config."Skill" ADD CONSTRAINT "FK_Skill_AreaSkillSettings_AreaSkillSettingsId" FOREIGN KEY ("AreaSkillSettingsId") REFERENCES config."AreaSkillSettings" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241021175011_AddAreaSkillConfiguration') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20241021175011_AddAreaSkillConfiguration', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241204090233_UpdateSimpleCraftingSettings') THEN
    ALTER TABLE config."SimpleCraftingSettings" ADD "NpcPriceDivisor" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241204090233_UpdateSimpleCraftingSettings') THEN
    ALTER TABLE config."SimpleCraftingSettings" ADD "SuccessPercentageAdditionForGuardianItem" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241204090233_UpdateSimpleCraftingSettings') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20241204090233_UpdateSimpleCraftingSettings', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20250114201231_AddAccountIsTemplate') THEN
    ALTER TABLE data."Account" ADD "IsTemplate" boolean NOT NULL DEFAULT FALSE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20250114201231_AddAccountIsTemplate') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20250114201231_AddAccountIsTemplate', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20250228170503_AddMasterSkillDefinitionExtendsDuration') THEN
    ALTER TABLE config."MasterSkillDefinition" ADD "ExtendsDuration" boolean NOT NULL DEFAULT FALSE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20250228170503_AddMasterSkillDefinitionExtendsDuration') THEN
    ALTER TABLE config."AttributeRelationship" ADD "AggregateType" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20250228170503_AddMasterSkillDefinitionExtendsDuration') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20250228170503_AddMasterSkillDefinitionExtendsDuration', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20250302164032_AddStoreProperties') THEN
    ALTER TABLE data."Character" ADD "IsStoreOpened" boolean NOT NULL DEFAULT FALSE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20250302164032_AddStoreProperties') THEN
    ALTER TABLE data."Character" ADD "StoreName" text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20250302164032_AddStoreProperties') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20250302164032_AddStoreProperties', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20250728194753_AddSkillAttributeRelationships') THEN
    ALTER TABLE config."AttributeRelationship" ADD "SkillId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20250728194753_AddSkillAttributeRelationships') THEN
    CREATE INDEX "IX_AttributeRelationship_SkillId" ON config."AttributeRelationship" ("SkillId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20250728194753_AddSkillAttributeRelationships') THEN
    ALTER TABLE config."AttributeRelationship" ADD CONSTRAINT "FK_AttributeRelationship_Skill_SkillId" FOREIGN KEY ("SkillId") REFERENCES config."Skill" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20250728194753_AddSkillAttributeRelationships') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20250728194753_AddSkillAttributeRelationships', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE config."MiniGameDefinition" ADD "BlessJewelDropCount" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE config."MiniGameDefinition" ADD "SoulJewelDropCount" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE config."ItemDefinition" ADD "LearnableSkillId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE config."ItemDefinition" ADD "PetLeadershipFormula" text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE config."ItemDefinition" ADD "WearableSkillId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE data."Item" ADD "GiftMessage" text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE config."GameServerConfiguration" ADD "Description" text NOT NULL DEFAULT '';
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE config."GameMapDefinition" ADD "DisablePartySummon" boolean NOT NULL DEFAULT FALSE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE data."Character" ADD "CashShopStorageId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE config."AttributeRequirement" ADD "MinimumValuePerItemLevel" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE data."Account" ADD "GoblinPoints" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE data."Account" ADD "WCoinC" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE data."Account" ADD "WCoinP" integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    CREATE TABLE config."CashShopCategory" (
        "Id" uuid NOT NULL,
        "GameConfigurationId" uuid,
        "CategoryId" integer NOT NULL,
        "Name" text NOT NULL,
        "Description" text NOT NULL,
        "IconId" text,
        "DisplayOrder" integer NOT NULL,
        "IsVisible" boolean NOT NULL,
        CONSTRAINT "PK_CashShopCategory" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_CashShopCategory_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    CREATE TABLE data."CashShopTransaction" (
        "Id" uuid NOT NULL,
        "AccountId" uuid,
        "AccountId1" uuid,
        "ProductId" integer NOT NULL,
        "Amount" integer NOT NULL,
        "CoinType" smallint NOT NULL,
        "Timestamp" timestamp with time zone NOT NULL,
        "TransactionType" integer NOT NULL,
        "CharacterName" text NOT NULL,
        "ReceiverName" text,
        "Success" boolean NOT NULL,
        "Notes" text,
        CONSTRAINT "PK_CashShopTransaction" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_CashShopTransaction_Account_AccountId" FOREIGN KEY ("AccountId") REFERENCES data."Account" ("Id"),
        CONSTRAINT "FK_CashShopTransaction_Account_AccountId1" FOREIGN KEY ("AccountId1") REFERENCES data."Account" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    CREATE TABLE config."CashShopProduct" (
        "Id" uuid NOT NULL,
        "ItemId" uuid,
        "CategoryObjectId" uuid,
        "GameConfigurationId" uuid,
        "ProductId" integer NOT NULL,
        "PriceWCoinC" integer NOT NULL,
        "PriceWCoinP" integer NOT NULL,
        "PriceGoblinPoints" integer NOT NULL,
        "Quantity" smallint NOT NULL,
        "ItemLevel" smallint NOT NULL,
        "ItemOptionLevel" smallint NOT NULL,
        "Durability" smallint NOT NULL,
        "IsAvailable" boolean NOT NULL,
        "AvailableFrom" timestamp with time zone,
        "AvailableUntil" timestamp with time zone,
        "IsEventItem" boolean NOT NULL,
        "Category" text NOT NULL,
        "DisplayName" text NOT NULL,
        CONSTRAINT "PK_CashShopProduct" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_CashShopProduct_CashShopCategory_CategoryObjectId" FOREIGN KEY ("CategoryObjectId") REFERENCES config."CashShopCategory" ("Id"),
        CONSTRAINT "FK_CashShopProduct_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_CashShopProduct_ItemDefinition_ItemId" FOREIGN KEY ("ItemId") REFERENCES config."ItemDefinition" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    CREATE INDEX "IX_ItemDefinition_LearnableSkillId" ON config."ItemDefinition" ("LearnableSkillId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    CREATE INDEX "IX_ItemDefinition_WearableSkillId" ON config."ItemDefinition" ("WearableSkillId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    CREATE UNIQUE INDEX "IX_Character_CashShopStorageId" ON data."Character" ("CashShopStorageId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    CREATE INDEX "IX_CashShopCategory_GameConfigurationId" ON config."CashShopCategory" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    CREATE INDEX "IX_CashShopProduct_CategoryObjectId" ON config."CashShopProduct" ("CategoryObjectId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    CREATE INDEX "IX_CashShopProduct_GameConfigurationId" ON config."CashShopProduct" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    CREATE INDEX "IX_CashShopProduct_ItemId" ON config."CashShopProduct" ("ItemId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    CREATE INDEX "IX_CashShopTransaction_AccountId" ON data."CashShopTransaction" ("AccountId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    CREATE INDEX "IX_CashShopTransaction_AccountId1" ON data."CashShopTransaction" ("AccountId1");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE data."Character" ADD CONSTRAINT "FK_Character_ItemStorage_CashShopStorageId" FOREIGN KEY ("CashShopStorageId") REFERENCES data."ItemStorage" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE config."ItemDefinition" ADD CONSTRAINT "FK_ItemDefinition_Skill_LearnableSkillId" FOREIGN KEY ("LearnableSkillId") REFERENCES config."Skill" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    ALTER TABLE config."ItemDefinition" ADD CONSTRAINT "FK_ItemDefinition_Skill_WearableSkillId" FOREIGN KEY ("WearableSkillId") REFERENCES config."Skill" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251106235745_AddCashShopCategoryTable') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20251106235745_AddCashShopCategoryTable', '9.0.10');
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251110134236_AddMonsterTypeDefinition') THEN
    ALTER TABLE config."MonsterDefinition" ADD "MonsterTypeId" uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251110134236_AddMonsterTypeDefinition') THEN
    CREATE TABLE config."MonsterTypeDefinition" (
        "Id" uuid NOT NULL,
        "GameConfigurationId" uuid,
        "Name" text NOT NULL,
        "Description" text NOT NULL,
        "BehaviorType" integer NOT NULL,
        "MovementPattern" integer NOT NULL,
        "AttackPattern" integer NOT NULL,
        "IsAggressive" boolean NOT NULL,
        "CanRespawn" boolean NOT NULL,
        "IsTargetable" boolean NOT NULL,
        "AggroMultiplier" real NOT NULL,
        "ExperienceMultiplier" real NOT NULL,
        "DropRateMultiplier" real NOT NULL,
        CONSTRAINT "PK_MonsterTypeDefinition" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MonsterTypeDefinition_GameConfiguration_GameConfigurationId" FOREIGN KEY ("GameConfigurationId") REFERENCES config."GameConfiguration" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251110134236_AddMonsterTypeDefinition') THEN
    CREATE INDEX "IX_MonsterDefinition_MonsterTypeId" ON config."MonsterDefinition" ("MonsterTypeId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251110134236_AddMonsterTypeDefinition') THEN
    CREATE INDEX "IX_MonsterTypeDefinition_GameConfigurationId" ON config."MonsterTypeDefinition" ("GameConfigurationId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251110134236_AddMonsterTypeDefinition') THEN
    ALTER TABLE config."MonsterDefinition" ADD CONSTRAINT "FK_MonsterDefinition_MonsterTypeDefinition_MonsterTypeId" FOREIGN KEY ("MonsterTypeId") REFERENCES config."MonsterTypeDefinition" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20251110134236_AddMonsterTypeDefinition') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20251110134236_AddMonsterTypeDefinition', '9.0.10');
    END IF;
END $EF$;
COMMIT;

