SET NOCOUNT ON;
IF DB_ID(N'DB_SCRUM_PLANNING') IS NULL
BEGIN
    EXEC(N'CREATE DATABASE [DB_SCRUM_PLANNING]');
END;
GO
USE [DB_SCRUM_PLANNING];
GO
IF SCHEMA_ID(N'SQM_SECURITY') IS NULL EXEC(N'CREATE SCHEMA [SQM_SECURITY]');
GO
IF SCHEMA_ID(N'SQM_CATALOGS') IS NULL EXEC(N'CREATE SCHEMA [SQM_CATALOGS]');
GO
IF SCHEMA_ID(N'SQM_GENERAL') IS NULL EXEC(N'CREATE SCHEMA [SQM_GENERAL]');
GO
IF OBJECT_ID(N'[SQM_CATALOGS].[TBL_Status]', N'U') IS NULL
BEGIN
CREATE TABLE [SQM_CATALOGS].[TBL_Status]
(
	statusId INT PRIMARY KEY IDENTITY (1,1),
	statusName VARCHAR(80) NOT NULL,
	statusCreationDate DATETIME NOT NULL,
	statusCreatorId INT NOT NULL,
	statusModificationDate DATETIME NOT NULL,
	statusModificatorId INT NULL,
	statusEnable BIT NOT NULL
);
END;
GO

IF OBJECT_ID(N'[SQM_SECURITY].[TBL_Roles]', N'U') IS NULL
BEGIN
CREATE TABLE [SQM_SECURITY].[TBL_Roles]
(
	rolId INT PRIMARY KEY IDENTITY (1,1),
	rolName VARCHAR(80) NOT NULL,
	rolCreationDate DATETIME NOT NULL,
	rolCreatorId INT NOT NULL,
	rolModificationDate DATETIME NOT NULL,
	rolModificatorId INT NULL,
	rolEnable BIT NOT NULL
);
END;
GO

IF OBJECT_ID(N'[SQM_SECURITY].[TBL_Users]', N'U') IS NULL
BEGIN
CREATE TABLE [SQM_SECURITY].[TBL_Users]
(
	userId INT PRIMARY KEY IDENTITY (1,1),
	userFullName VARCHAR(80) NOT NULL,
	userName VARCHAR(80) NOT NULL,
	userEmail VARCHAR(80) NOT NULL,
	userPassword VARBINARY(256) NOT NULL,
	userRolId INT REFERENCES [SQM_SECURITY].[TBL_Roles](rolId) NOT NULL,
	userCreationDate DATETIME NOT NULL,
	userCreatorId INT NOT NULL,
	userModificationDate DATETIME NOT NULL,
	userModificatorId INT NULL,
	userEnable BIT NOT NULL
);
END;
GO

IF OBJECT_ID(N'[SQM_CATALOGS].[TBL_BusinessValues]', N'U') IS NULL
BEGIN
CREATE TABLE [SQM_CATALOGS].[TBL_BusinessValues]
(
	businessValueId INT PRIMARY KEY IDENTITY (1,1),
	businessValueName VARCHAR(80) NOT NULL,
	businessValueCreationDate DATETIME NOT NULL,
	businessValueCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	businessValueModificationDate DATETIME NULL,
	businessValueModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	businessValueEnable BIT NOT NULL
);
END;
GO

IF OBJECT_ID(N'[SQM_GENERAL].[TBL_Initiatives]', N'U') IS NULL
BEGIN
CREATE TABLE [SQM_GENERAL].[TBL_Initiatives]
(
	initiativeId INT PRIMARY KEY IDENTITY (1,1),
	initiativeSummary VARCHAR(200) NOT NULL,
	initiativeDescription VARCHAR(2000) NOT NULL,
	initiativeOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	initiativeGoals VARCHAR(255) NULL,
	initiativeBusinessValue INT REFERENCES [SQM_CATALOGS].[TBL_BusinessValues](BusinessValueId) NOT NULL,
	initiativeTargetStart DATE NULL,
	initiativeTargetEnd DATE NULL,
	initiativeCreationDate DATETIME NOT NULL,
	initiativeCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	initiativeModificationDate DATETIME NULL,
	initiativeModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	initiativeStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);
END;
GO

IF OBJECT_ID(N'[SQM_CATALOGS].[TBL_Priorities]', N'U') IS NULL
BEGIN
CREATE TABLE [SQM_CATALOGS].[TBL_Priorities]
(
	priorityId INT PRIMARY KEY IDENTITY (1,1),
	priorityName VARCHAR(80) NOT NULL,
	priorityCreationDate DATETIME NOT NULL,
	priorityCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	priorityModificationDate DATETIME NULL,
	priorityModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	priorityEnable BIT NOT NULL
);
END;
GO

IF OBJECT_ID(N'[SQM_GENERAL].[TBL_Epics]', N'U') IS NULL
BEGIN
CREATE TABLE [SQM_GENERAL].[TBL_Epics]
(
	epicId INT PRIMARY KEY IDENTITY (1,1),
	epicName VARCHAR(100) NOT NULL,
	epicSummary VARCHAR(500) NOT NULL,
	epicDescription VARCHAR(4000) NOT NULL,
	epicParentLink INT REFERENCES [SQM_GENERAL].[TBL_Initiatives](initiativeId) NOT NULL,
	epicOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	epicStartDate DATE NULL,
	epicDueDate DATE NULL,
	epicPriority INT REFERENCES [SQM_CATALOGS].[TBL_Priorities](priorityId),
	epicCreationDate DATETIME NOT NULL,
	epicCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	epicModificationDate DATETIME NULL,
	epicModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	epicStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);
END;
GO

IF OBJECT_ID(N'[SQM_GENERAL].[TBL_Features]', N'U') IS NULL
BEGIN
CREATE TABLE [SQM_GENERAL].[TBL_Features]
(
	featureId INT PRIMARY KEY IDENTITY (1,1),
	featureSummary VARCHAR(500) NOT NULL,
	featureDescription VARCHAR(2000) NOT NULL,
	featuresAcceptanceCriteria VARCHAR(4000) NOT NULL,
	featureParentLink INT REFERENCES [SQM_GENERAL].[TBL_Epics](epicId) NOT NULL,
	featureOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	featureStartDate DATE NULL,
	featureDueDate DATE NULL,
	featurePriority INT REFERENCES [SQM_CATALOGS].[TBL_Priorities](priorityId),
	featureCreationDate DATETIME NOT NULL,
	featureCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	featureModificationDate DATETIME NULL,
	featureModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	featureStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);
END;
GO

IF OBJECT_ID(N'[SQM_GENERAL].[TBL_ProductBacklogItems]', N'U') IS NULL
BEGIN
CREATE TABLE [SQM_GENERAL].[TBL_ProductBacklogItems]
(
	PBIId INT PRIMARY KEY IDENTITY (1,1),
	PBISummary VARCHAR(500) NOT NULL,
	PBIDescription VARCHAR(2000) NOT NULL,
	PBIsAcceptanceCriteria VARCHAR(4000) NOT NULL,
	PBIOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	PBIParentLink INT REFERENCES [SQM_GENERAL].[TBL_Features](featureId) NOT NULL,
	PBIStoryPoint INT,
	PBIStartDate DATE NULL,
	PBIDueDate DATE NULL,
	PBIPriority INT REFERENCES [SQM_CATALOGS].[TBL_Priorities](priorityId),
	PBICreationDate DATETIME NOT NULL,
	PBICreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	PBIModificationDate DATETIME NULL,
	PBIModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	PBIStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);
END;
GO

IF OBJECT_ID(N'[SQM_CATALOGS].[TBL_ActivityTypes]', N'U') IS NULL
BEGIN
CREATE TABLE [SQM_CATALOGS].[TBL_ActivityTypes]
(
	activityTypeId INT PRIMARY KEY IDENTITY (1,1),
	activityTypeName VARCHAR(80) NOT NULL,
	activityTypeCreationDate DATETIME NOT NULL,
	activityTypeCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	activityTypeModificationDate DATETIME NULL,
	activityTypeModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	activityTypeEnable BIT NOT NULL
);
END;
GO

IF OBJECT_ID(N'[SQM_GENERAL].[TBL_Tasks]', N'U') IS NULL
BEGIN
CREATE TABLE [SQM_GENERAL].[TBL_Tasks]
(
	taskId INT PRIMARY KEY IDENTITY (1,1),
	taskSummary VARCHAR(500) NOT NULL,
	taskDescription VARCHAR(2000) NOT NULL,
	taskOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	taskParentLink INT REFERENCES [SQM_GENERAL].[TBL_ProductBacklogItems](PBIId) NOT NULL,
	taskOriginalEstimate DECIMAL(4,2) NULL, --5
	taskCompletedWork DECIMAL(4,2) NULL, --6
	taskRemaningWork DECIMAL(4,2) NULL,
	taskStartDate DATE NULL,
	taskCompletedDate DATE NULL,
	taskDueDate DATE NULL,
	taskActivityType INT REFERENCES [SQM_CATALOGS].[TBL_ActivityTypes] (activityTypeId),
	taskCreationDate DATETIME NOT NULL,
	taskCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	taskModificationDate DATETIME NULL,
	taskModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	taskStatus INT REFERENCES [SQM_CATALOGS].[TBL_Status](statusId) NOT NULL
);
END;
GO

IF OBJECT_ID(N'[SQM_GENERAL].[TBL_TaskComments]', N'U') IS NULL
BEGIN
CREATE TABLE [SQM_GENERAL].[TBL_TaskComments]
(
	taskCommentId INT PRIMARY KEY IDENTITY (1,1),
	taskCommentParentLink INT REFERENCES [SQM_GENERAL].[TBL_Tasks](TaskId) NOT NULL,
	taskCommentOwner INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	taskCommentText NVARCHAR(4000) NOT NULL,
	taskCommentCreationDate DATETIME NOT NULL,
	taskCommentCreatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NOT NULL,
	taskCommentModificationDate DATETIME NULL,
	taskCommentModificatorId INT REFERENCES [SQM_SECURITY].[TBL_Users] (userId) NULL,
	taskCommentStatus BIT NOT NULL
);
END;
GO

-- 12 USP: INSERTAR / ACTUALIZAR / LISTAR
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[USP_Status]
    @Accion VARCHAR(12),
    @statusId INT = NULL,
    @Pagina INT = 1,
    @TamanoPagina INT = 20,
    @statusName VARCHAR(80) = NULL,
    @statusCreationDate DATETIME = NULL,
    @statusCreatorId INT = NULL,
    @statusModificationDate DATETIME = NULL,
    @statusModificatorId INT = NULL,
    @statusEnable BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        SET @Accion = UPPER(LTRIM(RTRIM(ISNULL(@Accion, ''))));
        IF @Accion NOT IN ('INSERTAR', 'ACTUALIZAR', 'LISTAR')
            THROW 50000, 'Accion invalida. Use INSERTAR, ACTUALIZAR o LISTAR.', 1;

        IF @Accion = 'LISTAR'
        BEGIN
            IF @Pagina IS NULL OR @Pagina < 1 OR @TamanoPagina IS NULL OR @TamanoPagina < 1 OR @TamanoPagina > 500
                THROW 50001, 'Pagina debe ser >= 1 y TamanoPagina entre 1 y 500.', 1;
            SELECT COUNT_BIG(*) AS TotalRegistros FROM [SQM_CATALOGS].[TBL_Status];
            SELECT * FROM [SQM_CATALOGS].[TBL_Status]
            ORDER BY [statusId]
            OFFSET (CONVERT(BIGINT, @Pagina) - 1) * CONVERT(BIGINT, @TamanoPagina) ROWS
            FETCH NEXT @TamanoPagina ROWS ONLY;
            RETURN;
        END

        IF @Accion = 'ACTUALIZAR'
        BEGIN
            IF @statusId IS NULL OR @statusId < 1
                THROW 50002, 'Debe indicar un ID valido para actualizar.', 1;
            IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] WHERE [statusId] = @statusId)
                THROW 50003, 'No existe el registro a actualizar.', 1;
        END

        IF NULLIF(LTRIM(RTRIM(@statusName)), '') IS NULL
            THROW 50004, 'Campo obligatorio: statusName.', 1;
        IF @statusName IS NOT NULL AND LEN(LTRIM(RTRIM(@statusName))) = 0
            THROW 50005, 'No se permite texto vacio: statusName.', 1;
        IF @Accion = 'INSERTAR' AND @statusCreatorId IS NULL
            THROW 50004, 'Campo obligatorio: statusCreatorId.', 1;
        IF @statusEnable IS NULL
            THROW 50004, 'Campo obligatorio: statusEnable.', 1;

        IF @Accion = 'INSERTAR'
        BEGIN
            INSERT INTO [SQM_CATALOGS].[TBL_Status]
                ([statusName], [statusCreationDate], [statusCreatorId], [statusModificationDate], [statusEnable])
            VALUES (@statusName, GETDATE(), @statusCreatorId, GETDATE(), @statusEnable);
            SELECT * FROM [SQM_CATALOGS].[TBL_Status] WHERE [statusId] = CONVERT(INT, SCOPE_IDENTITY());
            RETURN;
        END

        UPDATE [SQM_CATALOGS].[TBL_Status]
        SET [statusName] = @statusName,
            [statusModificationDate] = GETDATE(),
            [statusModificatorId] = @statusModificatorId,
            [statusEnable] = @statusEnable
        WHERE [statusId] = @statusId;
        SELECT * FROM [SQM_CATALOGS].[TBL_Status] WHERE [statusId] = @statusId;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[USP_Roles]
    @Accion VARCHAR(12),
    @rolId INT = NULL,
    @Pagina INT = 1,
    @TamanoPagina INT = 20,
    @rolName VARCHAR(80) = NULL,
    @rolCreationDate DATETIME = NULL,
    @rolCreatorId INT = NULL,
    @rolModificationDate DATETIME = NULL,
    @rolModificatorId INT = NULL,
    @rolEnable BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        SET @Accion = UPPER(LTRIM(RTRIM(ISNULL(@Accion, ''))));
        IF @Accion NOT IN ('INSERTAR', 'ACTUALIZAR', 'LISTAR')
            THROW 50000, 'Accion invalida. Use INSERTAR, ACTUALIZAR o LISTAR.', 1;

        IF @Accion = 'LISTAR'
        BEGIN
            IF @Pagina IS NULL OR @Pagina < 1 OR @TamanoPagina IS NULL OR @TamanoPagina < 1 OR @TamanoPagina > 500
                THROW 50001, 'Pagina debe ser >= 1 y TamanoPagina entre 1 y 500.', 1;
            SELECT COUNT_BIG(*) AS TotalRegistros FROM [SQM_SECURITY].[TBL_Roles];
            SELECT * FROM [SQM_SECURITY].[TBL_Roles]
            ORDER BY [rolId]
            OFFSET (CONVERT(BIGINT, @Pagina) - 1) * CONVERT(BIGINT, @TamanoPagina) ROWS
            FETCH NEXT @TamanoPagina ROWS ONLY;
            RETURN;
        END

        IF @Accion = 'ACTUALIZAR'
        BEGIN
            IF @rolId IS NULL OR @rolId < 1
                THROW 50002, 'Debe indicar un ID valido para actualizar.', 1;
            IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Roles] WHERE [rolId] = @rolId)
                THROW 50003, 'No existe el registro a actualizar.', 1;
        END

        IF NULLIF(LTRIM(RTRIM(@rolName)), '') IS NULL
            THROW 50004, 'Campo obligatorio: rolName.', 1;
        IF @rolName IS NOT NULL AND LEN(LTRIM(RTRIM(@rolName))) = 0
            THROW 50005, 'No se permite texto vacio: rolName.', 1;
        IF @Accion = 'INSERTAR' AND @rolCreatorId IS NULL
            THROW 50004, 'Campo obligatorio: rolCreatorId.', 1;
        IF @rolEnable IS NULL
            THROW 50004, 'Campo obligatorio: rolEnable.', 1;

        IF @Accion = 'INSERTAR'
        BEGIN
            INSERT INTO [SQM_SECURITY].[TBL_Roles]
                ([rolName], [rolCreationDate], [rolCreatorId], [rolModificationDate], [rolEnable])
            VALUES (@rolName, GETDATE(), @rolCreatorId, GETDATE(), @rolEnable);
            SELECT * FROM [SQM_SECURITY].[TBL_Roles] WHERE [rolId] = CONVERT(INT, SCOPE_IDENTITY());
            RETURN;
        END

        UPDATE [SQM_SECURITY].[TBL_Roles]
        SET [rolName] = @rolName,
            [rolModificationDate] = GETDATE(),
            [rolModificatorId] = @rolModificatorId,
            [rolEnable] = @rolEnable
        WHERE [rolId] = @rolId;
        SELECT * FROM [SQM_SECURITY].[TBL_Roles] WHERE [rolId] = @rolId;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[USP_Users]
    @Accion VARCHAR(12),
    @userId INT = NULL,
    @Pagina INT = 1,
    @TamanoPagina INT = 20,
    @userFullName VARCHAR(80) = NULL,
    @userName VARCHAR(80) = NULL,
    @userEmail VARCHAR(80) = NULL,
    @userPassword VARBINARY(256) = NULL,
    @userRolId INT = NULL,
    @userCreationDate DATETIME = NULL,
    @userCreatorId INT = NULL,
    @userModificationDate DATETIME = NULL,
    @userModificatorId INT = NULL,
    @userEnable BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        SET @Accion = UPPER(LTRIM(RTRIM(ISNULL(@Accion, ''))));
        IF @Accion NOT IN ('INSERTAR', 'ACTUALIZAR', 'LISTAR')
            THROW 50000, 'Accion invalida. Use INSERTAR, ACTUALIZAR o LISTAR.', 1;

        IF @Accion = 'LISTAR'
        BEGIN
            IF @Pagina IS NULL OR @Pagina < 1 OR @TamanoPagina IS NULL OR @TamanoPagina < 1 OR @TamanoPagina > 500
                THROW 50001, 'Pagina debe ser >= 1 y TamanoPagina entre 1 y 500.', 1;
            SELECT COUNT_BIG(*) AS TotalRegistros FROM [SQM_SECURITY].[TBL_Users];
            SELECT * FROM [SQM_SECURITY].[TBL_Users]
            ORDER BY [userId]
            OFFSET (CONVERT(BIGINT, @Pagina) - 1) * CONVERT(BIGINT, @TamanoPagina) ROWS
            FETCH NEXT @TamanoPagina ROWS ONLY;
            RETURN;
        END

        IF @Accion = 'ACTUALIZAR'
        BEGIN
            IF @userId IS NULL OR @userId < 1
                THROW 50002, 'Debe indicar un ID valido para actualizar.', 1;
            IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @userId)
                THROW 50003, 'No existe el registro a actualizar.', 1;
        END

        IF NULLIF(LTRIM(RTRIM(@userFullName)), '') IS NULL
            THROW 50004, 'Campo obligatorio: userFullName.', 1;
        IF @userFullName IS NOT NULL AND LEN(LTRIM(RTRIM(@userFullName))) = 0
            THROW 50005, 'No se permite texto vacio: userFullName.', 1;
        IF NULLIF(LTRIM(RTRIM(@userName)), '') IS NULL
            THROW 50004, 'Campo obligatorio: userName.', 1;
        IF @userName IS NOT NULL AND LEN(LTRIM(RTRIM(@userName))) = 0
            THROW 50005, 'No se permite texto vacio: userName.', 1;
        IF NULLIF(LTRIM(RTRIM(@userEmail)), '') IS NULL
            THROW 50004, 'Campo obligatorio: userEmail.', 1;
        IF @userEmail IS NOT NULL AND LEN(LTRIM(RTRIM(@userEmail))) = 0
            THROW 50005, 'No se permite texto vacio: userEmail.', 1;
        IF @userPassword IS NULL
            THROW 50004, 'Campo obligatorio: userPassword.', 1;
        IF @userRolId IS NULL
            THROW 50004, 'Campo obligatorio: userRolId.', 1;
        IF @userRolId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Roles] WHERE [rolId] = @userRolId)
            THROW 50006, 'Referencia inexistente: userRolId.', 1;
        IF @Accion = 'INSERTAR' AND @userCreatorId IS NULL
            THROW 50004, 'Campo obligatorio: userCreatorId.', 1;
        IF @userEnable IS NULL
            THROW 50004, 'Campo obligatorio: userEnable.', 1;

        IF @Accion = 'INSERTAR'
        BEGIN
            INSERT INTO [SQM_SECURITY].[TBL_Users]
                ([userFullName], [userName], [userEmail], [userPassword], [userRolId], [userCreationDate], [userCreatorId], [userModificationDate], [userEnable])
            VALUES (@userFullName, @userName, @userEmail, @userPassword, @userRolId, GETDATE(), @userCreatorId, GETDATE(), @userEnable);
            SELECT * FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = CONVERT(INT, SCOPE_IDENTITY());
            RETURN;
        END

        UPDATE [SQM_SECURITY].[TBL_Users]
        SET [userFullName] = @userFullName,
            [userName] = @userName,
            [userEmail] = @userEmail,
            [userPassword] = @userPassword,
            [userRolId] = @userRolId,
            [userModificationDate] = GETDATE(),
            [userModificatorId] = @userModificatorId,
            [userEnable] = @userEnable
        WHERE [userId] = @userId;
        SELECT * FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @userId;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[USP_BusinessValues]
    @Accion VARCHAR(12),
    @businessValueId INT = NULL,
    @Pagina INT = 1,
    @TamanoPagina INT = 20,
    @businessValueName VARCHAR(80) = NULL,
    @businessValueCreationDate DATETIME = NULL,
    @businessValueCreatorId INT = NULL,
    @businessValueModificationDate DATETIME = NULL,
    @businessValueModificatorId INT = NULL,
    @businessValueEnable BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        SET @Accion = UPPER(LTRIM(RTRIM(ISNULL(@Accion, ''))));
        IF @Accion NOT IN ('INSERTAR', 'ACTUALIZAR', 'LISTAR')
            THROW 50000, 'Accion invalida. Use INSERTAR, ACTUALIZAR o LISTAR.', 1;

        IF @Accion = 'LISTAR'
        BEGIN
            IF @Pagina IS NULL OR @Pagina < 1 OR @TamanoPagina IS NULL OR @TamanoPagina < 1 OR @TamanoPagina > 500
                THROW 50001, 'Pagina debe ser >= 1 y TamanoPagina entre 1 y 500.', 1;
            SELECT COUNT_BIG(*) AS TotalRegistros FROM [SQM_CATALOGS].[TBL_BusinessValues];
            SELECT * FROM [SQM_CATALOGS].[TBL_BusinessValues]
            ORDER BY [businessValueId]
            OFFSET (CONVERT(BIGINT, @Pagina) - 1) * CONVERT(BIGINT, @TamanoPagina) ROWS
            FETCH NEXT @TamanoPagina ROWS ONLY;
            RETURN;
        END

        IF @Accion = 'ACTUALIZAR'
        BEGIN
            IF @businessValueId IS NULL OR @businessValueId < 1
                THROW 50002, 'Debe indicar un ID valido para actualizar.', 1;
            IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_BusinessValues] WHERE [businessValueId] = @businessValueId)
                THROW 50003, 'No existe el registro a actualizar.', 1;
        END

        IF NULLIF(LTRIM(RTRIM(@businessValueName)), '') IS NULL
            THROW 50004, 'Campo obligatorio: businessValueName.', 1;
        IF @businessValueName IS NOT NULL AND LEN(LTRIM(RTRIM(@businessValueName))) = 0
            THROW 50005, 'No se permite texto vacio: businessValueName.', 1;
        IF @Accion = 'INSERTAR' AND @businessValueCreatorId IS NULL
            THROW 50004, 'Campo obligatorio: businessValueCreatorId.', 1;
        IF @businessValueModificatorId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @businessValueModificatorId)
            THROW 50006, 'Referencia inexistente: businessValueModificatorId.', 1;
        IF @businessValueEnable IS NULL
            THROW 50004, 'Campo obligatorio: businessValueEnable.', 1;

        IF @Accion = 'INSERTAR'
        BEGIN
            INSERT INTO [SQM_CATALOGS].[TBL_BusinessValues]
                ([businessValueName], [businessValueCreationDate], [businessValueCreatorId], [businessValueEnable])
            VALUES (@businessValueName, GETDATE(), @businessValueCreatorId, @businessValueEnable);
            SELECT * FROM [SQM_CATALOGS].[TBL_BusinessValues] WHERE [businessValueId] = CONVERT(INT, SCOPE_IDENTITY());
            RETURN;
        END

        UPDATE [SQM_CATALOGS].[TBL_BusinessValues]
        SET [businessValueName] = @businessValueName,
            [businessValueModificationDate] = GETDATE(),
            [businessValueModificatorId] = @businessValueModificatorId,
            [businessValueEnable] = @businessValueEnable
        WHERE [businessValueId] = @businessValueId;
        SELECT * FROM [SQM_CATALOGS].[TBL_BusinessValues] WHERE [businessValueId] = @businessValueId;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[USP_Initiatives]
    @Accion VARCHAR(12),
    @initiativeId INT = NULL,
    @Pagina INT = 1,
    @TamanoPagina INT = 20,
    @initiativeSummary VARCHAR(200) = NULL,
    @initiativeDescription VARCHAR(2000) = NULL,
    @initiativeOwner INT = NULL,
    @initiativeGoals VARCHAR(255) = NULL,
    @initiativeBusinessValue INT = NULL,
    @initiativeTargetStart DATE = NULL,
    @initiativeTargetEnd DATE = NULL,
    @initiativeCreationDate DATETIME = NULL,
    @initiativeCreatorId INT = NULL,
    @initiativeModificationDate DATETIME = NULL,
    @initiativeModificatorId INT = NULL,
    @initiativeStatus INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        SET @Accion = UPPER(LTRIM(RTRIM(ISNULL(@Accion, ''))));
        IF @Accion NOT IN ('INSERTAR', 'ACTUALIZAR', 'LISTAR')
            THROW 50000, 'Accion invalida. Use INSERTAR, ACTUALIZAR o LISTAR.', 1;

        IF @Accion = 'LISTAR'
        BEGIN
            IF @Pagina IS NULL OR @Pagina < 1 OR @TamanoPagina IS NULL OR @TamanoPagina < 1 OR @TamanoPagina > 500
                THROW 50001, 'Pagina debe ser >= 1 y TamanoPagina entre 1 y 500.', 1;
            SELECT COUNT_BIG(*) AS TotalRegistros FROM [SQM_GENERAL].[TBL_Initiatives];
            SELECT * FROM [SQM_GENERAL].[TBL_Initiatives]
            ORDER BY [initiativeId]
            OFFSET (CONVERT(BIGINT, @Pagina) - 1) * CONVERT(BIGINT, @TamanoPagina) ROWS
            FETCH NEXT @TamanoPagina ROWS ONLY;
            RETURN;
        END

        IF @Accion = 'ACTUALIZAR'
        BEGIN
            IF @initiativeId IS NULL OR @initiativeId < 1
                THROW 50002, 'Debe indicar un ID valido para actualizar.', 1;
            IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Initiatives] WHERE [initiativeId] = @initiativeId)
                THROW 50003, 'No existe el registro a actualizar.', 1;
        END

        IF NULLIF(LTRIM(RTRIM(@initiativeSummary)), '') IS NULL
            THROW 50004, 'Campo obligatorio: initiativeSummary.', 1;
        IF @initiativeSummary IS NOT NULL AND LEN(LTRIM(RTRIM(@initiativeSummary))) = 0
            THROW 50005, 'No se permite texto vacio: initiativeSummary.', 1;
        IF NULLIF(LTRIM(RTRIM(@initiativeDescription)), '') IS NULL
            THROW 50004, 'Campo obligatorio: initiativeDescription.', 1;
        IF @initiativeDescription IS NOT NULL AND LEN(LTRIM(RTRIM(@initiativeDescription))) = 0
            THROW 50005, 'No se permite texto vacio: initiativeDescription.', 1;
        IF @initiativeOwner IS NULL
            THROW 50004, 'Campo obligatorio: initiativeOwner.', 1;
        IF @initiativeOwner IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @initiativeOwner)
            THROW 50006, 'Referencia inexistente: initiativeOwner.', 1;
        IF @initiativeGoals IS NOT NULL AND LEN(LTRIM(RTRIM(@initiativeGoals))) = 0
            THROW 50005, 'No se permite texto vacio: initiativeGoals.', 1;
        IF @initiativeBusinessValue IS NULL
            THROW 50004, 'Campo obligatorio: initiativeBusinessValue.', 1;
        IF @initiativeBusinessValue IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_BusinessValues] WHERE [BusinessValueId] = @initiativeBusinessValue)
            THROW 50006, 'Referencia inexistente: initiativeBusinessValue.', 1;
        IF @Accion = 'INSERTAR' AND @initiativeCreatorId IS NULL
            THROW 50004, 'Campo obligatorio: initiativeCreatorId.', 1;
        IF @initiativeModificatorId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @initiativeModificatorId)
            THROW 50006, 'Referencia inexistente: initiativeModificatorId.', 1;
        IF @initiativeStatus IS NULL
            THROW 50004, 'Campo obligatorio: initiativeStatus.', 1;
        IF @initiativeStatus IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] WHERE [statusId] = @initiativeStatus)
            THROW 50006, 'Referencia inexistente: initiativeStatus.', 1;
        IF @initiativeTargetStart IS NOT NULL AND @initiativeTargetEnd IS NOT NULL AND @initiativeTargetStart > @initiativeTargetEnd
            THROW 50008, 'La fecha inicial no puede ser posterior a la fecha final.', 1;

        IF @Accion = 'INSERTAR'
        BEGIN
            INSERT INTO [SQM_GENERAL].[TBL_Initiatives]
                ([initiativeSummary], [initiativeDescription], [initiativeOwner], [initiativeGoals], [initiativeBusinessValue], [initiativeTargetStart], [initiativeTargetEnd], [initiativeCreationDate], [initiativeCreatorId], [initiativeStatus])
            VALUES (@initiativeSummary, @initiativeDescription, @initiativeOwner, @initiativeGoals, @initiativeBusinessValue, @initiativeTargetStart, @initiativeTargetEnd, GETDATE(), @initiativeCreatorId, @initiativeStatus);
            SELECT * FROM [SQM_GENERAL].[TBL_Initiatives] WHERE [initiativeId] = CONVERT(INT, SCOPE_IDENTITY());
            RETURN;
        END

        UPDATE [SQM_GENERAL].[TBL_Initiatives]
        SET [initiativeSummary] = @initiativeSummary,
            [initiativeDescription] = @initiativeDescription,
            [initiativeOwner] = @initiativeOwner,
            [initiativeGoals] = @initiativeGoals,
            [initiativeBusinessValue] = @initiativeBusinessValue,
            [initiativeTargetStart] = @initiativeTargetStart,
            [initiativeTargetEnd] = @initiativeTargetEnd,
            [initiativeModificationDate] = GETDATE(),
            [initiativeModificatorId] = @initiativeModificatorId,
            [initiativeStatus] = @initiativeStatus
        WHERE [initiativeId] = @initiativeId;
        SELECT * FROM [SQM_GENERAL].[TBL_Initiatives] WHERE [initiativeId] = @initiativeId;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[USP_Priorities]
    @Accion VARCHAR(12),
    @priorityId INT = NULL,
    @Pagina INT = 1,
    @TamanoPagina INT = 20,
    @priorityName VARCHAR(80) = NULL,
    @priorityCreationDate DATETIME = NULL,
    @priorityCreatorId INT = NULL,
    @priorityModificationDate DATETIME = NULL,
    @priorityModificatorId INT = NULL,
    @priorityEnable BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        SET @Accion = UPPER(LTRIM(RTRIM(ISNULL(@Accion, ''))));
        IF @Accion NOT IN ('INSERTAR', 'ACTUALIZAR', 'LISTAR')
            THROW 50000, 'Accion invalida. Use INSERTAR, ACTUALIZAR o LISTAR.', 1;

        IF @Accion = 'LISTAR'
        BEGIN
            IF @Pagina IS NULL OR @Pagina < 1 OR @TamanoPagina IS NULL OR @TamanoPagina < 1 OR @TamanoPagina > 500
                THROW 50001, 'Pagina debe ser >= 1 y TamanoPagina entre 1 y 500.', 1;
            SELECT COUNT_BIG(*) AS TotalRegistros FROM [SQM_CATALOGS].[TBL_Priorities];
            SELECT * FROM [SQM_CATALOGS].[TBL_Priorities]
            ORDER BY [priorityId]
            OFFSET (CONVERT(BIGINT, @Pagina) - 1) * CONVERT(BIGINT, @TamanoPagina) ROWS
            FETCH NEXT @TamanoPagina ROWS ONLY;
            RETURN;
        END

        IF @Accion = 'ACTUALIZAR'
        BEGIN
            IF @priorityId IS NULL OR @priorityId < 1
                THROW 50002, 'Debe indicar un ID valido para actualizar.', 1;
            IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Priorities] WHERE [priorityId] = @priorityId)
                THROW 50003, 'No existe el registro a actualizar.', 1;
        END

        IF NULLIF(LTRIM(RTRIM(@priorityName)), '') IS NULL
            THROW 50004, 'Campo obligatorio: priorityName.', 1;
        IF @priorityName IS NOT NULL AND LEN(LTRIM(RTRIM(@priorityName))) = 0
            THROW 50005, 'No se permite texto vacio: priorityName.', 1;
        IF @Accion = 'INSERTAR' AND @priorityCreatorId IS NULL
            THROW 50004, 'Campo obligatorio: priorityCreatorId.', 1;
        IF @priorityModificatorId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @priorityModificatorId)
            THROW 50006, 'Referencia inexistente: priorityModificatorId.', 1;
        IF @priorityEnable IS NULL
            THROW 50004, 'Campo obligatorio: priorityEnable.', 1;

        IF @Accion = 'INSERTAR'
        BEGIN
            INSERT INTO [SQM_CATALOGS].[TBL_Priorities]
                ([priorityName], [priorityCreationDate], [priorityCreatorId], [priorityEnable])
            VALUES (@priorityName, GETDATE(), @priorityCreatorId, @priorityEnable);
            SELECT * FROM [SQM_CATALOGS].[TBL_Priorities] WHERE [priorityId] = CONVERT(INT, SCOPE_IDENTITY());
            RETURN;
        END

        UPDATE [SQM_CATALOGS].[TBL_Priorities]
        SET [priorityName] = @priorityName,
            [priorityModificationDate] = GETDATE(),
            [priorityModificatorId] = @priorityModificatorId,
            [priorityEnable] = @priorityEnable
        WHERE [priorityId] = @priorityId;
        SELECT * FROM [SQM_CATALOGS].[TBL_Priorities] WHERE [priorityId] = @priorityId;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[USP_Epics]
    @Accion VARCHAR(12),
    @epicId INT = NULL,
    @Pagina INT = 1,
    @TamanoPagina INT = 20,
    @epicName VARCHAR(100) = NULL,
    @epicSummary VARCHAR(500) = NULL,
    @epicDescription VARCHAR(4000) = NULL,
    @epicParentLink INT = NULL,
    @epicOwner INT = NULL,
    @epicStartDate DATE = NULL,
    @epicDueDate DATE = NULL,
    @epicPriority INT = NULL,
    @epicCreationDate DATETIME = NULL,
    @epicCreatorId INT = NULL,
    @epicModificationDate DATETIME = NULL,
    @epicModificatorId INT = NULL,
    @epicStatus INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        SET @Accion = UPPER(LTRIM(RTRIM(ISNULL(@Accion, ''))));
        IF @Accion NOT IN ('INSERTAR', 'ACTUALIZAR', 'LISTAR')
            THROW 50000, 'Accion invalida. Use INSERTAR, ACTUALIZAR o LISTAR.', 1;

        IF @Accion = 'LISTAR'
        BEGIN
            IF @Pagina IS NULL OR @Pagina < 1 OR @TamanoPagina IS NULL OR @TamanoPagina < 1 OR @TamanoPagina > 500
                THROW 50001, 'Pagina debe ser >= 1 y TamanoPagina entre 1 y 500.', 1;
            SELECT COUNT_BIG(*) AS TotalRegistros FROM [SQM_GENERAL].[TBL_Epics];
            SELECT * FROM [SQM_GENERAL].[TBL_Epics]
            ORDER BY [epicId]
            OFFSET (CONVERT(BIGINT, @Pagina) - 1) * CONVERT(BIGINT, @TamanoPagina) ROWS
            FETCH NEXT @TamanoPagina ROWS ONLY;
            RETURN;
        END

        IF @Accion = 'ACTUALIZAR'
        BEGIN
            IF @epicId IS NULL OR @epicId < 1
                THROW 50002, 'Debe indicar un ID valido para actualizar.', 1;
            IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Epics] WHERE [epicId] = @epicId)
                THROW 50003, 'No existe el registro a actualizar.', 1;
        END

        IF NULLIF(LTRIM(RTRIM(@epicName)), '') IS NULL
            THROW 50004, 'Campo obligatorio: epicName.', 1;
        IF @epicName IS NOT NULL AND LEN(LTRIM(RTRIM(@epicName))) = 0
            THROW 50005, 'No se permite texto vacio: epicName.', 1;
        IF NULLIF(LTRIM(RTRIM(@epicSummary)), '') IS NULL
            THROW 50004, 'Campo obligatorio: epicSummary.', 1;
        IF @epicSummary IS NOT NULL AND LEN(LTRIM(RTRIM(@epicSummary))) = 0
            THROW 50005, 'No se permite texto vacio: epicSummary.', 1;
        IF NULLIF(LTRIM(RTRIM(@epicDescription)), '') IS NULL
            THROW 50004, 'Campo obligatorio: epicDescription.', 1;
        IF @epicDescription IS NOT NULL AND LEN(LTRIM(RTRIM(@epicDescription))) = 0
            THROW 50005, 'No se permite texto vacio: epicDescription.', 1;
        IF @epicParentLink IS NULL
            THROW 50004, 'Campo obligatorio: epicParentLink.', 1;
        IF @epicParentLink IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Initiatives] WHERE [initiativeId] = @epicParentLink)
            THROW 50006, 'Referencia inexistente: epicParentLink.', 1;
        IF @epicOwner IS NULL
            THROW 50004, 'Campo obligatorio: epicOwner.', 1;
        IF @epicOwner IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @epicOwner)
            THROW 50006, 'Referencia inexistente: epicOwner.', 1;
        IF @epicPriority IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Priorities] WHERE [priorityId] = @epicPriority)
            THROW 50006, 'Referencia inexistente: epicPriority.', 1;
        IF @Accion = 'INSERTAR' AND @epicCreatorId IS NULL
            THROW 50004, 'Campo obligatorio: epicCreatorId.', 1;
        IF @epicModificatorId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @epicModificatorId)
            THROW 50006, 'Referencia inexistente: epicModificatorId.', 1;
        IF @epicStatus IS NULL
            THROW 50004, 'Campo obligatorio: epicStatus.', 1;
        IF @epicStatus IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] WHERE [statusId] = @epicStatus)
            THROW 50006, 'Referencia inexistente: epicStatus.', 1;
        IF @epicStartDate IS NOT NULL AND @epicDueDate IS NOT NULL AND @epicStartDate > @epicDueDate
            THROW 50008, 'La fecha inicial no puede ser posterior a la fecha final.', 1;

        IF @Accion = 'INSERTAR'
        BEGIN
            INSERT INTO [SQM_GENERAL].[TBL_Epics]
                ([epicName], [epicSummary], [epicDescription], [epicParentLink], [epicOwner], [epicStartDate], [epicDueDate], [epicPriority], [epicCreationDate], [epicCreatorId], [epicStatus])
            VALUES (@epicName, @epicSummary, @epicDescription, @epicParentLink, @epicOwner, @epicStartDate, @epicDueDate, @epicPriority, GETDATE(), @epicCreatorId, @epicStatus);
            SELECT * FROM [SQM_GENERAL].[TBL_Epics] WHERE [epicId] = CONVERT(INT, SCOPE_IDENTITY());
            RETURN;
        END

        UPDATE [SQM_GENERAL].[TBL_Epics]
        SET [epicName] = @epicName,
            [epicSummary] = @epicSummary,
            [epicDescription] = @epicDescription,
            [epicParentLink] = @epicParentLink,
            [epicOwner] = @epicOwner,
            [epicStartDate] = @epicStartDate,
            [epicDueDate] = @epicDueDate,
            [epicPriority] = @epicPriority,
            [epicModificationDate] = GETDATE(),
            [epicModificatorId] = @epicModificatorId,
            [epicStatus] = @epicStatus
        WHERE [epicId] = @epicId;
        SELECT * FROM [SQM_GENERAL].[TBL_Epics] WHERE [epicId] = @epicId;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[USP_Features]
    @Accion VARCHAR(12),
    @featureId INT = NULL,
    @Pagina INT = 1,
    @TamanoPagina INT = 20,
    @featureSummary VARCHAR(500) = NULL,
    @featureDescription VARCHAR(2000) = NULL,
    @featuresAcceptanceCriteria VARCHAR(4000) = NULL,
    @featureParentLink INT = NULL,
    @featureOwner INT = NULL,
    @featureStartDate DATE = NULL,
    @featureDueDate DATE = NULL,
    @featurePriority INT = NULL,
    @featureCreationDate DATETIME = NULL,
    @featureCreatorId INT = NULL,
    @featureModificationDate DATETIME = NULL,
    @featureModificatorId INT = NULL,
    @featureStatus INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        SET @Accion = UPPER(LTRIM(RTRIM(ISNULL(@Accion, ''))));
        IF @Accion NOT IN ('INSERTAR', 'ACTUALIZAR', 'LISTAR')
            THROW 50000, 'Accion invalida. Use INSERTAR, ACTUALIZAR o LISTAR.', 1;

        IF @Accion = 'LISTAR'
        BEGIN
            IF @Pagina IS NULL OR @Pagina < 1 OR @TamanoPagina IS NULL OR @TamanoPagina < 1 OR @TamanoPagina > 500
                THROW 50001, 'Pagina debe ser >= 1 y TamanoPagina entre 1 y 500.', 1;
            SELECT COUNT_BIG(*) AS TotalRegistros FROM [SQM_GENERAL].[TBL_Features];
            SELECT * FROM [SQM_GENERAL].[TBL_Features]
            ORDER BY [featureId]
            OFFSET (CONVERT(BIGINT, @Pagina) - 1) * CONVERT(BIGINT, @TamanoPagina) ROWS
            FETCH NEXT @TamanoPagina ROWS ONLY;
            RETURN;
        END

        IF @Accion = 'ACTUALIZAR'
        BEGIN
            IF @featureId IS NULL OR @featureId < 1
                THROW 50002, 'Debe indicar un ID valido para actualizar.', 1;
            IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Features] WHERE [featureId] = @featureId)
                THROW 50003, 'No existe el registro a actualizar.', 1;
        END

        IF NULLIF(LTRIM(RTRIM(@featureSummary)), '') IS NULL
            THROW 50004, 'Campo obligatorio: featureSummary.', 1;
        IF @featureSummary IS NOT NULL AND LEN(LTRIM(RTRIM(@featureSummary))) = 0
            THROW 50005, 'No se permite texto vacio: featureSummary.', 1;
        IF NULLIF(LTRIM(RTRIM(@featureDescription)), '') IS NULL
            THROW 50004, 'Campo obligatorio: featureDescription.', 1;
        IF @featureDescription IS NOT NULL AND LEN(LTRIM(RTRIM(@featureDescription))) = 0
            THROW 50005, 'No se permite texto vacio: featureDescription.', 1;
        IF NULLIF(LTRIM(RTRIM(@featuresAcceptanceCriteria)), '') IS NULL
            THROW 50004, 'Campo obligatorio: featuresAcceptanceCriteria.', 1;
        IF @featuresAcceptanceCriteria IS NOT NULL AND LEN(LTRIM(RTRIM(@featuresAcceptanceCriteria))) = 0
            THROW 50005, 'No se permite texto vacio: featuresAcceptanceCriteria.', 1;
        IF @featureParentLink IS NULL
            THROW 50004, 'Campo obligatorio: featureParentLink.', 1;
        IF @featureParentLink IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Epics] WHERE [epicId] = @featureParentLink)
            THROW 50006, 'Referencia inexistente: featureParentLink.', 1;
        IF @featureOwner IS NULL
            THROW 50004, 'Campo obligatorio: featureOwner.', 1;
        IF @featureOwner IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @featureOwner)
            THROW 50006, 'Referencia inexistente: featureOwner.', 1;
        IF @featurePriority IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Priorities] WHERE [priorityId] = @featurePriority)
            THROW 50006, 'Referencia inexistente: featurePriority.', 1;
        IF @Accion = 'INSERTAR' AND @featureCreatorId IS NULL
            THROW 50004, 'Campo obligatorio: featureCreatorId.', 1;
        IF @featureModificatorId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @featureModificatorId)
            THROW 50006, 'Referencia inexistente: featureModificatorId.', 1;
        IF @featureStatus IS NULL
            THROW 50004, 'Campo obligatorio: featureStatus.', 1;
        IF @featureStatus IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] WHERE [statusId] = @featureStatus)
            THROW 50006, 'Referencia inexistente: featureStatus.', 1;
        IF @featureStartDate IS NOT NULL AND @featureDueDate IS NOT NULL AND @featureStartDate > @featureDueDate
            THROW 50008, 'La fecha inicial no puede ser posterior a la fecha final.', 1;

        IF @Accion = 'INSERTAR'
        BEGIN
            INSERT INTO [SQM_GENERAL].[TBL_Features]
                ([featureSummary], [featureDescription], [featuresAcceptanceCriteria], [featureParentLink], [featureOwner], [featureStartDate], [featureDueDate], [featurePriority], [featureCreationDate], [featureCreatorId], [featureStatus])
            VALUES (@featureSummary, @featureDescription, @featuresAcceptanceCriteria, @featureParentLink, @featureOwner, @featureStartDate, @featureDueDate, @featurePriority, GETDATE(), @featureCreatorId, @featureStatus);
            SELECT * FROM [SQM_GENERAL].[TBL_Features] WHERE [featureId] = CONVERT(INT, SCOPE_IDENTITY());
            RETURN;
        END

        UPDATE [SQM_GENERAL].[TBL_Features]
        SET [featureSummary] = @featureSummary,
            [featureDescription] = @featureDescription,
            [featuresAcceptanceCriteria] = @featuresAcceptanceCriteria,
            [featureParentLink] = @featureParentLink,
            [featureOwner] = @featureOwner,
            [featureStartDate] = @featureStartDate,
            [featureDueDate] = @featureDueDate,
            [featurePriority] = @featurePriority,
            [featureModificationDate] = GETDATE(),
            [featureModificatorId] = @featureModificatorId,
            [featureStatus] = @featureStatus
        WHERE [featureId] = @featureId;
        SELECT * FROM [SQM_GENERAL].[TBL_Features] WHERE [featureId] = @featureId;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[USP_ProductBacklogItems]
    @Accion VARCHAR(12),
    @PBIId INT = NULL,
    @Pagina INT = 1,
    @TamanoPagina INT = 20,
    @PBISummary VARCHAR(500) = NULL,
    @PBIDescription VARCHAR(2000) = NULL,
    @PBIsAcceptanceCriteria VARCHAR(4000) = NULL,
    @PBIOwner INT = NULL,
    @PBIParentLink INT = NULL,
    @PBIStoryPoint INT = NULL,
    @PBIStartDate DATE = NULL,
    @PBIDueDate DATE = NULL,
    @PBIPriority INT = NULL,
    @PBICreationDate DATETIME = NULL,
    @PBICreatorId INT = NULL,
    @PBIModificationDate DATETIME = NULL,
    @PBIModificatorId INT = NULL,
    @PBIStatus INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        SET @Accion = UPPER(LTRIM(RTRIM(ISNULL(@Accion, ''))));
        IF @Accion NOT IN ('INSERTAR', 'ACTUALIZAR', 'LISTAR')
            THROW 50000, 'Accion invalida. Use INSERTAR, ACTUALIZAR o LISTAR.', 1;

        IF @Accion = 'LISTAR'
        BEGIN
            IF @Pagina IS NULL OR @Pagina < 1 OR @TamanoPagina IS NULL OR @TamanoPagina < 1 OR @TamanoPagina > 500
                THROW 50001, 'Pagina debe ser >= 1 y TamanoPagina entre 1 y 500.', 1;
            SELECT COUNT_BIG(*) AS TotalRegistros FROM [SQM_GENERAL].[TBL_ProductBacklogItems];
            SELECT * FROM [SQM_GENERAL].[TBL_ProductBacklogItems]
            ORDER BY [PBIId]
            OFFSET (CONVERT(BIGINT, @Pagina) - 1) * CONVERT(BIGINT, @TamanoPagina) ROWS
            FETCH NEXT @TamanoPagina ROWS ONLY;
            RETURN;
        END

        IF @Accion = 'ACTUALIZAR'
        BEGIN
            IF @PBIId IS NULL OR @PBIId < 1
                THROW 50002, 'Debe indicar un ID valido para actualizar.', 1;
            IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_ProductBacklogItems] WHERE [PBIId] = @PBIId)
                THROW 50003, 'No existe el registro a actualizar.', 1;
        END

        IF NULLIF(LTRIM(RTRIM(@PBISummary)), '') IS NULL
            THROW 50004, 'Campo obligatorio: PBISummary.', 1;
        IF @PBISummary IS NOT NULL AND LEN(LTRIM(RTRIM(@PBISummary))) = 0
            THROW 50005, 'No se permite texto vacio: PBISummary.', 1;
        IF NULLIF(LTRIM(RTRIM(@PBIDescription)), '') IS NULL
            THROW 50004, 'Campo obligatorio: PBIDescription.', 1;
        IF @PBIDescription IS NOT NULL AND LEN(LTRIM(RTRIM(@PBIDescription))) = 0
            THROW 50005, 'No se permite texto vacio: PBIDescription.', 1;
        IF NULLIF(LTRIM(RTRIM(@PBIsAcceptanceCriteria)), '') IS NULL
            THROW 50004, 'Campo obligatorio: PBIsAcceptanceCriteria.', 1;
        IF @PBIsAcceptanceCriteria IS NOT NULL AND LEN(LTRIM(RTRIM(@PBIsAcceptanceCriteria))) = 0
            THROW 50005, 'No se permite texto vacio: PBIsAcceptanceCriteria.', 1;
        IF @PBIOwner IS NULL
            THROW 50004, 'Campo obligatorio: PBIOwner.', 1;
        IF @PBIOwner IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @PBIOwner)
            THROW 50006, 'Referencia inexistente: PBIOwner.', 1;
        IF @PBIParentLink IS NULL
            THROW 50004, 'Campo obligatorio: PBIParentLink.', 1;
        IF @PBIParentLink IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Features] WHERE [featureId] = @PBIParentLink)
            THROW 50006, 'Referencia inexistente: PBIParentLink.', 1;
        IF @PBIStoryPoint < 0
            THROW 50007, 'No se admiten valores negativos: PBIStoryPoint.', 1;
        IF @PBIPriority IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Priorities] WHERE [priorityId] = @PBIPriority)
            THROW 50006, 'Referencia inexistente: PBIPriority.', 1;
        IF @Accion = 'INSERTAR' AND @PBICreatorId IS NULL
            THROW 50004, 'Campo obligatorio: PBICreatorId.', 1;
        IF @PBIModificatorId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @PBIModificatorId)
            THROW 50006, 'Referencia inexistente: PBIModificatorId.', 1;
        IF @PBIStatus IS NULL
            THROW 50004, 'Campo obligatorio: PBIStatus.', 1;
        IF @PBIStatus IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] WHERE [statusId] = @PBIStatus)
            THROW 50006, 'Referencia inexistente: PBIStatus.', 1;
        IF @PBIStartDate IS NOT NULL AND @PBIDueDate IS NOT NULL AND @PBIStartDate > @PBIDueDate
            THROW 50008, 'La fecha inicial no puede ser posterior a la fecha final.', 1;

        IF @Accion = 'INSERTAR'
        BEGIN
            INSERT INTO [SQM_GENERAL].[TBL_ProductBacklogItems]
                ([PBISummary], [PBIDescription], [PBIsAcceptanceCriteria], [PBIOwner], [PBIParentLink], [PBIStoryPoint], [PBIStartDate], [PBIDueDate], [PBIPriority], [PBICreationDate], [PBICreatorId], [PBIStatus])
            VALUES (@PBISummary, @PBIDescription, @PBIsAcceptanceCriteria, @PBIOwner, @PBIParentLink, @PBIStoryPoint, @PBIStartDate, @PBIDueDate, @PBIPriority, GETDATE(), @PBICreatorId, @PBIStatus);
            SELECT * FROM [SQM_GENERAL].[TBL_ProductBacklogItems] WHERE [PBIId] = CONVERT(INT, SCOPE_IDENTITY());
            RETURN;
        END

        UPDATE [SQM_GENERAL].[TBL_ProductBacklogItems]
        SET [PBISummary] = @PBISummary,
            [PBIDescription] = @PBIDescription,
            [PBIsAcceptanceCriteria] = @PBIsAcceptanceCriteria,
            [PBIOwner] = @PBIOwner,
            [PBIParentLink] = @PBIParentLink,
            [PBIStoryPoint] = @PBIStoryPoint,
            [PBIStartDate] = @PBIStartDate,
            [PBIDueDate] = @PBIDueDate,
            [PBIPriority] = @PBIPriority,
            [PBIModificationDate] = GETDATE(),
            [PBIModificatorId] = @PBIModificatorId,
            [PBIStatus] = @PBIStatus
        WHERE [PBIId] = @PBIId;
        SELECT * FROM [SQM_GENERAL].[TBL_ProductBacklogItems] WHERE [PBIId] = @PBIId;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[USP_ActivityTypes]
    @Accion VARCHAR(12),
    @activityTypeId INT = NULL,
    @Pagina INT = 1,
    @TamanoPagina INT = 20,
    @activityTypeName VARCHAR(80) = NULL,
    @activityTypeCreationDate DATETIME = NULL,
    @activityTypeCreatorId INT = NULL,
    @activityTypeModificationDate DATETIME = NULL,
    @activityTypeModificatorId INT = NULL,
    @activityTypeEnable BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        SET @Accion = UPPER(LTRIM(RTRIM(ISNULL(@Accion, ''))));
        IF @Accion NOT IN ('INSERTAR', 'ACTUALIZAR', 'LISTAR')
            THROW 50000, 'Accion invalida. Use INSERTAR, ACTUALIZAR o LISTAR.', 1;

        IF @Accion = 'LISTAR'
        BEGIN
            IF @Pagina IS NULL OR @Pagina < 1 OR @TamanoPagina IS NULL OR @TamanoPagina < 1 OR @TamanoPagina > 500
                THROW 50001, 'Pagina debe ser >= 1 y TamanoPagina entre 1 y 500.', 1;
            SELECT COUNT_BIG(*) AS TotalRegistros FROM [SQM_CATALOGS].[TBL_ActivityTypes];
            SELECT * FROM [SQM_CATALOGS].[TBL_ActivityTypes]
            ORDER BY [activityTypeId]
            OFFSET (CONVERT(BIGINT, @Pagina) - 1) * CONVERT(BIGINT, @TamanoPagina) ROWS
            FETCH NEXT @TamanoPagina ROWS ONLY;
            RETURN;
        END

        IF @Accion = 'ACTUALIZAR'
        BEGIN
            IF @activityTypeId IS NULL OR @activityTypeId < 1
                THROW 50002, 'Debe indicar un ID valido para actualizar.', 1;
            IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_ActivityTypes] WHERE [activityTypeId] = @activityTypeId)
                THROW 50003, 'No existe el registro a actualizar.', 1;
        END

        IF NULLIF(LTRIM(RTRIM(@activityTypeName)), '') IS NULL
            THROW 50004, 'Campo obligatorio: activityTypeName.', 1;
        IF @activityTypeName IS NOT NULL AND LEN(LTRIM(RTRIM(@activityTypeName))) = 0
            THROW 50005, 'No se permite texto vacio: activityTypeName.', 1;
        IF @Accion = 'INSERTAR' AND @activityTypeCreatorId IS NULL
            THROW 50004, 'Campo obligatorio: activityTypeCreatorId.', 1;
        IF @activityTypeModificatorId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @activityTypeModificatorId)
            THROW 50006, 'Referencia inexistente: activityTypeModificatorId.', 1;
        IF @activityTypeEnable IS NULL
            THROW 50004, 'Campo obligatorio: activityTypeEnable.', 1;

        IF @Accion = 'INSERTAR'
        BEGIN
            INSERT INTO [SQM_CATALOGS].[TBL_ActivityTypes]
                ([activityTypeName], [activityTypeCreationDate], [activityTypeCreatorId], [activityTypeEnable])
            VALUES (@activityTypeName, GETDATE(), @activityTypeCreatorId, @activityTypeEnable);
            SELECT * FROM [SQM_CATALOGS].[TBL_ActivityTypes] WHERE [activityTypeId] = CONVERT(INT, SCOPE_IDENTITY());
            RETURN;
        END

        UPDATE [SQM_CATALOGS].[TBL_ActivityTypes]
        SET [activityTypeName] = @activityTypeName,
            [activityTypeModificationDate] = GETDATE(),
            [activityTypeModificatorId] = @activityTypeModificatorId,
            [activityTypeEnable] = @activityTypeEnable
        WHERE [activityTypeId] = @activityTypeId;
        SELECT * FROM [SQM_CATALOGS].[TBL_ActivityTypes] WHERE [activityTypeId] = @activityTypeId;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[USP_Tasks]
    @Accion VARCHAR(12),
    @taskId INT = NULL,
    @Pagina INT = 1,
    @TamanoPagina INT = 20,
    @taskSummary VARCHAR(500) = NULL,
    @taskDescription VARCHAR(2000) = NULL,
    @taskOwner INT = NULL,
    @taskParentLink INT = NULL,
    @taskOriginalEstimate DECIMAL(4,2) = NULL,
    @taskCompletedWork DECIMAL(4,2) = NULL,
    @taskRemaningWork DECIMAL(4,2) = NULL,
    @taskStartDate DATE = NULL,
    @taskCompletedDate DATE = NULL,
    @taskDueDate DATE = NULL,
    @taskActivityType INT = NULL,
    @taskCreationDate DATETIME = NULL,
    @taskCreatorId INT = NULL,
    @taskModificationDate DATETIME = NULL,
    @taskModificatorId INT = NULL,
    @taskStatus INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        SET @Accion = UPPER(LTRIM(RTRIM(ISNULL(@Accion, ''))));
        IF @Accion NOT IN ('INSERTAR', 'ACTUALIZAR', 'LISTAR')
            THROW 50000, 'Accion invalida. Use INSERTAR, ACTUALIZAR o LISTAR.', 1;

        IF @Accion = 'LISTAR'
        BEGIN
            IF @Pagina IS NULL OR @Pagina < 1 OR @TamanoPagina IS NULL OR @TamanoPagina < 1 OR @TamanoPagina > 500
                THROW 50001, 'Pagina debe ser >= 1 y TamanoPagina entre 1 y 500.', 1;
            SELECT COUNT_BIG(*) AS TotalRegistros FROM [SQM_GENERAL].[TBL_Tasks];
            SELECT * FROM [SQM_GENERAL].[TBL_Tasks]
            ORDER BY [taskId]
            OFFSET (CONVERT(BIGINT, @Pagina) - 1) * CONVERT(BIGINT, @TamanoPagina) ROWS
            FETCH NEXT @TamanoPagina ROWS ONLY;
            RETURN;
        END

        IF @Accion = 'ACTUALIZAR'
        BEGIN
            IF @taskId IS NULL OR @taskId < 1
                THROW 50002, 'Debe indicar un ID valido para actualizar.', 1;
            IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Tasks] WHERE [taskId] = @taskId)
                THROW 50003, 'No existe el registro a actualizar.', 1;
        END

        IF NULLIF(LTRIM(RTRIM(@taskSummary)), '') IS NULL
            THROW 50004, 'Campo obligatorio: taskSummary.', 1;
        IF @taskSummary IS NOT NULL AND LEN(LTRIM(RTRIM(@taskSummary))) = 0
            THROW 50005, 'No se permite texto vacio: taskSummary.', 1;
        IF NULLIF(LTRIM(RTRIM(@taskDescription)), '') IS NULL
            THROW 50004, 'Campo obligatorio: taskDescription.', 1;
        IF @taskDescription IS NOT NULL AND LEN(LTRIM(RTRIM(@taskDescription))) = 0
            THROW 50005, 'No se permite texto vacio: taskDescription.', 1;
        IF @taskOwner IS NULL
            THROW 50004, 'Campo obligatorio: taskOwner.', 1;
        IF @taskOwner IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @taskOwner)
            THROW 50006, 'Referencia inexistente: taskOwner.', 1;
        IF @taskParentLink IS NULL
            THROW 50004, 'Campo obligatorio: taskParentLink.', 1;
        IF @taskParentLink IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_ProductBacklogItems] WHERE [PBIId] = @taskParentLink)
            THROW 50006, 'Referencia inexistente: taskParentLink.', 1;
        IF @taskOriginalEstimate < 0
            THROW 50007, 'No se admiten valores negativos: taskOriginalEstimate.', 1;
        IF @taskCompletedWork < 0
            THROW 50007, 'No se admiten valores negativos: taskCompletedWork.', 1;
        IF @taskRemaningWork < 0
            THROW 50007, 'No se admiten valores negativos: taskRemaningWork.', 1;
        IF @taskActivityType IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_ActivityTypes] WHERE [activityTypeId] = @taskActivityType)
            THROW 50006, 'Referencia inexistente: taskActivityType.', 1;
        IF @Accion = 'INSERTAR' AND @taskCreatorId IS NULL
            THROW 50004, 'Campo obligatorio: taskCreatorId.', 1;
        IF @taskModificatorId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @taskModificatorId)
            THROW 50006, 'Referencia inexistente: taskModificatorId.', 1;
        IF @taskStatus IS NULL
            THROW 50004, 'Campo obligatorio: taskStatus.', 1;
        IF @taskStatus IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] WHERE [statusId] = @taskStatus)
            THROW 50006, 'Referencia inexistente: taskStatus.', 1;
        IF @taskStartDate IS NOT NULL AND @taskDueDate IS NOT NULL AND @taskStartDate > @taskDueDate
            THROW 50008, 'La fecha inicial no puede ser posterior a la fecha final.', 1;

        IF @Accion = 'INSERTAR'
        BEGIN
            INSERT INTO [SQM_GENERAL].[TBL_Tasks]
                ([taskSummary], [taskDescription], [taskOwner], [taskParentLink], [taskOriginalEstimate], [taskCompletedWork], [taskRemaningWork], [taskStartDate], [taskCompletedDate], [taskDueDate], [taskActivityType], [taskCreationDate], [taskCreatorId], [taskStatus])
            VALUES (@taskSummary, @taskDescription, @taskOwner, @taskParentLink, @taskOriginalEstimate, @taskCompletedWork, @taskRemaningWork, @taskStartDate, @taskCompletedDate, @taskDueDate, @taskActivityType, GETDATE(), @taskCreatorId, @taskStatus);
            SELECT * FROM [SQM_GENERAL].[TBL_Tasks] WHERE [taskId] = CONVERT(INT, SCOPE_IDENTITY());
            RETURN;
        END

        UPDATE [SQM_GENERAL].[TBL_Tasks]
        SET [taskSummary] = @taskSummary,
            [taskDescription] = @taskDescription,
            [taskOwner] = @taskOwner,
            [taskParentLink] = @taskParentLink,
            [taskOriginalEstimate] = @taskOriginalEstimate,
            [taskCompletedWork] = @taskCompletedWork,
            [taskRemaningWork] = @taskRemaningWork,
            [taskStartDate] = @taskStartDate,
            [taskCompletedDate] = @taskCompletedDate,
            [taskDueDate] = @taskDueDate,
            [taskActivityType] = @taskActivityType,
            [taskModificationDate] = GETDATE(),
            [taskModificatorId] = @taskModificatorId,
            [taskStatus] = @taskStatus
        WHERE [taskId] = @taskId;
        SELECT * FROM [SQM_GENERAL].[TBL_Tasks] WHERE [taskId] = @taskId;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[USP_TaskComments]
    @Accion VARCHAR(12),
    @taskCommentId INT = NULL,
    @Pagina INT = 1,
    @TamanoPagina INT = 20,
    @taskCommentParentLink INT = NULL,
    @taskCommentOwner INT = NULL,
    @taskCommentText NVARCHAR(4000) = NULL,
    @taskCommentCreationDate DATETIME = NULL,
    @taskCommentCreatorId INT = NULL,
    @taskCommentModificationDate DATETIME = NULL,
    @taskCommentModificatorId INT = NULL,
    @taskCommentStatus BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        SET @Accion = UPPER(LTRIM(RTRIM(ISNULL(@Accion, ''))));
        IF @Accion NOT IN ('INSERTAR', 'ACTUALIZAR', 'LISTAR')
            THROW 50000, 'Accion invalida. Use INSERTAR, ACTUALIZAR o LISTAR.', 1;

        IF @Accion = 'LISTAR'
        BEGIN
            IF @Pagina IS NULL OR @Pagina < 1 OR @TamanoPagina IS NULL OR @TamanoPagina < 1 OR @TamanoPagina > 500
                THROW 50001, 'Pagina debe ser >= 1 y TamanoPagina entre 1 y 500.', 1;
            SELECT COUNT_BIG(*) AS TotalRegistros FROM [SQM_GENERAL].[TBL_TaskComments];
            SELECT * FROM [SQM_GENERAL].[TBL_TaskComments]
            ORDER BY [taskCommentId]
            OFFSET (CONVERT(BIGINT, @Pagina) - 1) * CONVERT(BIGINT, @TamanoPagina) ROWS
            FETCH NEXT @TamanoPagina ROWS ONLY;
            RETURN;
        END

        IF @Accion = 'ACTUALIZAR'
        BEGIN
            IF @taskCommentId IS NULL OR @taskCommentId < 1
                THROW 50002, 'Debe indicar un ID valido para actualizar.', 1;
            IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_TaskComments] WHERE [taskCommentId] = @taskCommentId)
                THROW 50003, 'No existe el registro a actualizar.', 1;
        END

        IF @taskCommentParentLink IS NULL
            THROW 50004, 'Campo obligatorio: taskCommentParentLink.', 1;
        IF @taskCommentParentLink IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Tasks] WHERE [TaskId] = @taskCommentParentLink)
            THROW 50006, 'Referencia inexistente: taskCommentParentLink.', 1;
        IF @taskCommentOwner IS NULL
            THROW 50004, 'Campo obligatorio: taskCommentOwner.', 1;
        IF @taskCommentOwner IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @taskCommentOwner)
            THROW 50006, 'Referencia inexistente: taskCommentOwner.', 1;
        IF NULLIF(LTRIM(RTRIM(@taskCommentText)), '') IS NULL
            THROW 50004, 'Campo obligatorio: taskCommentText.', 1;
        IF @taskCommentText IS NOT NULL AND LEN(LTRIM(RTRIM(@taskCommentText))) = 0
            THROW 50005, 'No se permite texto vacio: taskCommentText.', 1;
        IF @Accion = 'INSERTAR' AND @taskCommentCreatorId IS NULL
            THROW 50004, 'Campo obligatorio: taskCommentCreatorId.', 1;
        IF @taskCommentModificatorId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE [userId] = @taskCommentModificatorId)
            THROW 50006, 'Referencia inexistente: taskCommentModificatorId.', 1;
        IF @taskCommentStatus IS NULL
            THROW 50004, 'Campo obligatorio: taskCommentStatus.', 1;

        IF @Accion = 'INSERTAR'
        BEGIN
            INSERT INTO [SQM_GENERAL].[TBL_TaskComments]
                ([taskCommentParentLink], [taskCommentOwner], [taskCommentText], [taskCommentCreationDate], [taskCommentCreatorId], [taskCommentStatus])
            VALUES (@taskCommentParentLink, @taskCommentOwner, @taskCommentText, GETDATE(), @taskCommentCreatorId, @taskCommentStatus);
            SELECT * FROM [SQM_GENERAL].[TBL_TaskComments] WHERE [taskCommentId] = CONVERT(INT, SCOPE_IDENTITY());
            RETURN;
        END

        UPDATE [SQM_GENERAL].[TBL_TaskComments]
        SET [taskCommentParentLink] = @taskCommentParentLink,
            [taskCommentOwner] = @taskCommentOwner,
            [taskCommentText] = @taskCommentText,
            [taskCommentModificationDate] = GETDATE(),
            [taskCommentModificatorId] = @taskCommentModificatorId,
            [taskCommentStatus] = @taskCommentStatus
        WHERE [taskCommentId] = @taskCommentId;
        SELECT * FROM [SQM_GENERAL].[TBL_TaskComments] WHERE [taskCommentId] = @taskCommentId;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- VERIFICACION FINAL
SELECT SCHEMA_NAME(schema_id) AS Esquema, name AS Tabla FROM sys.tables WHERE schema_id IN (SCHEMA_ID('SQM_SECURITY'), SCHEMA_ID('SQM_CATALOGS'), SCHEMA_ID('SQM_GENERAL')) ORDER BY Esquema, Tabla;
SELECT SCHEMA_NAME(schema_id) AS Esquema, name AS Procedimiento FROM sys.procedures WHERE name LIKE 'USP[_]%' ORDER BY Esquema, Procedimiento;

-- PRUEBAS DE VERIFICACION NO DESTRUCTIVAS
SELECT COUNT(*) AS TotalTablas FROM sys.tables
WHERE schema_id IN (SCHEMA_ID('SQM_SECURITY'), SCHEMA_ID('SQM_CATALOGS'), SCHEMA_ID('SQM_GENERAL'));
SELECT COUNT(*) AS TotalUSP FROM sys.procedures
WHERE name LIKE 'USP[_]%' AND schema_id IN (SCHEMA_ID('SQM_SECURITY'), SCHEMA_ID('SQM_CATALOGS'), SCHEMA_ID('SQM_GENERAL'));
EXEC [SQM_CATALOGS].[USP_Status] @Accion='LISTAR', @Pagina=1, @TamanoPagina=10;
EXEC [SQM_SECURITY].[USP_Roles] @Accion='LISTAR', @Pagina=1, @TamanoPagina=10;
-- Ejemplo de insercion (descomentar solo si deseas crear un registro):
-- EXEC [SQM_CATALOGS].[USP_Status] @Accion='INSERTAR', @statusName='Pendiente', @statusCreatorId=1, @statusEnable=1;
-- Ejemplo de actualizacion (usar ID existente y datos validos):
-- EXEC [SQM_CATALOGS].[USP_Status] @Accion='ACTUALIZAR', @statusId=1, @statusName='En progreso', @statusEnable=1;
