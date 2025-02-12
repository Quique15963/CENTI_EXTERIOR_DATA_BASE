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
		WHERE object_id = OBJECT_ID(N'[cent].[EXT_USO_EXTERIOR_TRANSF_EFE_PENDIENTE_GET]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [cent].[EXT_USO_EXTERIOR_TRANSF_EFE_PENDIENTE_GET] AS'
END
GO

ALTER PROCEDURE [cent].[EXT_USO_EXTERIOR_TRANSF_EFE_PENDIENTE_GET]
	@SERVICIO INT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT *
,(SELECT convert(decimal(18,2),VALOR) FROM [cent].[EXT_USO_PARAMETROS] WHERE PARAMETRO='PORCENTAJE_COM_EFE_TRANSF' )
AS 'COM_EFE'
FROM [BD_CENTINELA].[cent].[EXT_USO_EXTERIOR_COBRO_COMISION] WHERE CANAL_TRANSACCION='TRANSFERENCIA'
AND NOMBRE_COMERCIO !='NO APLICA' and CIC !=''
	

END


