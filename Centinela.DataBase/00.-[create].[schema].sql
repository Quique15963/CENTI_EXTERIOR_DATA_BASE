USE [MiniRepExt]
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

IF NOT EXISTS (
		SELECT *
		FROM sys.schemas
		WHERE name = 'cent'
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE SCHEMA cent AUTHORIZATION dbo'
END
GO
