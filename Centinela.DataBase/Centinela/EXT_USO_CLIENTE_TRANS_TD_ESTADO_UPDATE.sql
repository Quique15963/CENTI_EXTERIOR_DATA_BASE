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
		WHERE object_id = OBJECT_ID(N'[cent].[EXT_USO_CLIENTE_TRANS_TD_ESTADO_UPDATE]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [cent].[EXT_USO_CLIENTE_TRANS_TD_ESTADO_UPDATE] AS'
END
GO

ALTER PROCEDURE [cent].[EXT_USO_CLIENTE_TRANS_TD_ESTADO_UPDATE]
	  @ID_OPERACION int,
	  @ULTIMO_ESTADO nvarchar(10),
      @ULTIMO_ESTADO_DESC nvarchar(max),
      @ULTIMA_RESPUESTA nvarchar(max),
      @INTENTOS int
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE [cent].EXT_CLIENTES_COBRO_COMISION
   SET
	  [FECHA_ACTUALIZACION] = getdate()
      ,[ULTIMO_ESTADO] = @ULTIMO_ESTADO
      ,[ULTIMO_ESTADO_DESC] = @ULTIMO_ESTADO_DESC
      ,[ULTIMA_RESPUESTA] = @ULTIMA_RESPUESTA
      ,[INTENTOS] = @INTENTOS
 WHERE ID_OPERACION=@ID_OPERACION


END


