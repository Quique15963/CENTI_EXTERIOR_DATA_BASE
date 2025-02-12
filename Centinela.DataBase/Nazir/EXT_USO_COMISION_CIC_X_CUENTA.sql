USE [BD_NAZIR]
GO
/****** Object:  StoredProcedure [nazir].[EXT_USO_COMISION_CIC_X_CUENTA]    Script Date: 7/11/2024 3:49:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[nazir].[EXT_USO_COMISION_CIC_X_CUENTA]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [nazir].[EXT_USO_COMISION_CIC_X_CUENTA] AS'
END
GO

ALTER PROCEDURE [nazir].[EXT_USO_COMISION_CIC_X_CUENTA] 

@NUMERO_CUENTA VARCHAR(26)
AS 
SELECT * FROM [BD_NAZIR].[nazir].[CUENTA] where ltrim(rtrim(NUMERO_CUENTA))=ltrim(rtrim(@NUMERO_CUENTA))

