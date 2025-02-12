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
		WHERE object_id = OBJECT_ID(N'[cent].[EXT_USO_CUENTAS_TRANSF_TD_INSERT]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [cent].[EXT_USO_CUENTAS_TRANSF_TD_INSERT] AS'
END
GO

ALTER PROCEDURE [cent].[EXT_USO_CUENTAS_TRANSF_TD_INSERT]
		    @ID_OPERACION bigint
		   ,@CIC varchar(12)
           ,@CUENTA_DEBITO varchar(26)
           ,@MONEDA char(3)
           ,@MONTO decimal(18,2)
           ,@TIPO_CAMBIO decimal(18,2)
           ,@GLOSA varchar(20)
           ,@SERVICIO int
           ,@REQUEST_BIZTALK nvarchar(max)
           ,@RESPONSE_BIZTALK nvarchar(max)
		   ,@COD_EXTORNO nvarchar(max)
		   ,@PROCESADO decimal(18,2)
		   ,@RESTANTE decimal(18,2)
		   ,@PENDIENTE int
		   ,@ULTIMO_ESTADO nvarchar(10)
		   ,@ULTIMO_ESTADO_DESC nvarchar(max)
		   ,@ULTIMA_RESPUESTA nvarchar(max)
		   ,@INTENTOS int
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE [cent].EXT_CLIENTES_COBRO_COMISION
   SET 
      
       [PROCESADO] = @PROCESADO
      ,[RESTANTE] = @RESTANTE
      ,[PENDIENTE] = @PENDIENTE
      ,[FECHA_ACTUALIZACION] = GETDATE()
      ,[ULTIMO_ESTADO] = @ULTIMO_ESTADO
      ,[ULTIMO_ESTADO_DESC] = @ULTIMO_ESTADO_DESC
      ,[ULTIMA_RESPUESTA] = @ULTIMA_RESPUESTA
      ,[INTENTOS] = @INTENTOS
 WHERE  ID_OPERACION=@ID_OPERACION


	
INSERT INTO [cent].EXT_CUENTAS_COBRO_COMISION
           ([CIC]
           ,[CUENTA_DEBITO]
           ,[MONEDA]
           ,[MONTO]
           ,[TIPO_CAMBIO]
           ,[GLOSA]
           ,[SERVICIO]
           ,[ID_OPERACION]
           ,[INTENTO]
           ,[REQUEST_BIZTALK]
           ,[RESPONSE_BIZTALK]
           ,[FECHA_REGISTRO]
           ,[EXTORNO]
           ,[COD_EXTORNO]
           ,[REQUEST_BIZTALK_EXTORNO]
           ,[RESPONSE_BIZTALK_EXTORNO]
           ,[FECHA_EXTORNO])
     VALUES
           (
		    @CIC
           ,@CUENTA_DEBITO
           ,@MONEDA
           ,@MONTO
           ,@TIPO_CAMBIO
           ,@GLOSA
           ,@SERVICIO
           ,@ID_OPERACION
           ,@INTENTOS
           ,@REQUEST_BIZTALK
           ,@RESPONSE_BIZTALK
           ,GETDATE()
           ,0
           ,@COD_EXTORNO
           ,''
           ,''
           ,GETDATE()
		   
		   )
END

