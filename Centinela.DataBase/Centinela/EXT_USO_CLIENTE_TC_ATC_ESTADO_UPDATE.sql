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
		WHERE object_id = OBJECT_ID(N'[cent].[EXT_USO_CLIENTE_TC_ATC_ESTADO_UPDATE]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [cent].[EXT_USO_CLIENTE_TC_ATC_ESTADO_UPDATE] AS'
END
GO

ALTER PROCEDURE [cent].[EXT_USO_CLIENTE_TC_ATC_ESTADO_UPDATE] 
 
 AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [cent].[EXT_CLIENTES_COBRO_COMISION]
	SET 
	PENDIENTE=1
	,[FECHA_ACTUALIZACION] = getdate()
    ,[ULTIMO_ESTADO] = 'SEND_ATC'
    ,[ULTIMO_ESTADO_DESC] ='ENVIO ARCHIVO ATC'
    ,[ULTIMA_RESPUESTA] = ''
    ,[INTENTOS] = [INTENTOS]+1

	WHERE   CANAL_TRANSACCION='CREDITO'
	AND PENDIENTE=0
	and RESTANTE>0
	
END




