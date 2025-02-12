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
		WHERE object_id = OBJECT_ID(N'[cent].[EXT_USO_EXTERIOR_TRANSF_EFE_UPDATE]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [cent].[EXT_USO_EXTERIOR_TRANSF_EFE_UPDATE] AS'
END
GO

ALTER PROCEDURE [cent].[EXT_USO_EXTERIOR_TRANSF_EFE_UPDATE]
	@ID_TRANSACCION INT
	,@PORCENTAJE_COMISION DECIMAL(18,2)
	,@TIPO_TRANSACCION VARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE [EXT_USO_EXTERIOR_COBRO_COMISION] SET
	NOMBRE_COMERCIO='NO APLICA'
	,PORCENTAJE_COMISION=@PORCENTAJE_COMISION
	,TIPO_TRANSACCION=@TIPO_TRANSACCION

	WHERE ID_TRANSACCION=@ID_TRANSACCION
	

END


