USE [master]
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

IF NOT EXISTS (
		SELECT name
		FROM master.sys.server_principals
		WHERE name = 'UsrBD_CENT'
	)
BEGIN
	CREATE LOGIN [UsrBD_CENT]
		WITH PASSWORD = N'$(_v_PasswordUserMiniRepext)'
			,DEFAULT_DATABASE = [MiniRepExt] 
			,CHECK_EXPIRATION = OFF
END
GO

USE [MiniRepExt]
GO

IF NOT EXISTS (
		SELECT [name]
		FROM [sys].[database_principals]
		WHERE [type] = N'S'
			AND [name] = N'UsrBD_CENT'
		)
BEGIN
	CREATE USER [UsrBD_CENT]
	FOR LOGIN [UsrBD_CENT]
	WITH DEFAULT_SCHEMA = [armelin]
END
GO

USE [MiniRepExt]
GO

GRANT SELECT
	ON SCHEMA::armelin
	TO [UsrBD_CENT];

GRANT EXECUTE
	ON SCHEMA::armelin
	TO [UsrBD_CENT];

GRANT SELECT
	ON SCHEMA::MinRepxt
	TO [UsrBD_CENT];

GRANT EXECUTE
	ON SCHEMA::MinRepxt
	TO [UsrBD_CENT];
GO

USE [master]
GO

GRANT CONNECT SQL
	TO [UsrBD_CENT]
GO


