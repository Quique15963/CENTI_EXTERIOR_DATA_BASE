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
		WHERE object_id = OBJECT_ID(N'[cent].[EXT_USO_CLIENTE_TRANS_TD_PENDIENTES_GET]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [cent].[EXT_USO_CLIENTE_TRANS_TD_PENDIENTES_GET] AS'
END
GO

ALTER PROCEDURE [cent].[EXT_USO_CLIENTE_TRANS_TD_PENDIENTES_GET] --1
	@SERVICIO	int
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT * FROM [cent].[EXT_CLIENTES_COBRO_COMISION]

	WHERE     
		PENDIENTE = 0 
	AND SERVICIO = @SERVICIO 
	AND FECHA_FIN_COBRO >= CONVERT(VARCHAR(8), GETDATE(), 112)
	AND CANAL_TRANSACCION !='CREDITO'


END
