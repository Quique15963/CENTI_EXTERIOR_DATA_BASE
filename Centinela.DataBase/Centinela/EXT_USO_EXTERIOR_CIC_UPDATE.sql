USE [BD_CENTINELA]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[cent].[EXT_USO_EXTERIOR_CIC_UPDATE]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [cent].[EXT_USO_EXTERIOR_CIC_UPDATE] AS'
END
GO

ALTER PROCEDURE [cent].[EXT_USO_EXTERIOR_CIC_UPDATE]
	@CIC VARCHAR(12),
	@NRO_CUENTA VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE [cent].[EXT_USO_EXTERIOR_COBRO_COMISION] 
	SET CIC=@CIC
	WHERE ltrim(rtrim(CUENTA_TRANSACCION))=ltrim(rtrim(@NRO_CUENTA))
	AND CONVERT(CHAR(8),FECHA_REGISTRO,112)=CONVERT(CHAR(8),GETDATE(),112)

end	


