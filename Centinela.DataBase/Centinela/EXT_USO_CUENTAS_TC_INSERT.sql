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
		WHERE object_id = OBJECT_ID(N'[cent].[EXT_USO_CUENTAS_TC_INSERT]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [cent].[EXT_USO_CUENTAS_TC_INSERT] AS'
END
GO

ALTER PROCEDURE [cent].[EXT_USO_CUENTAS_TC_INSERT]
	@CUENTA_TRANSACCION VARCHAR(20)
	,@PERIODO VARCHAR(20)
	,@ULTIMA_RESPUESTA NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;


	IF(@ULTIMA_RESPUESTA='000')
	BEGIN
	
insert into [cent].[EXT_CUENTAS_COBRO_COMISION]
SELECT
       [CIC]
      ,CUENTA_TRANSACCION
      ,MONEDA_COBRO
      ,RESTANTE
      ,[TIPO_CAMBIO]
      ,GLOSAUTILIZAR
      ,[SERVICIO]
      ,[ID_OPERACION]
      ,1
      ,''
      ,''
      ,getdate()
      ,0
      ,''
      ,''
      ,''
      ,null
  FROM cent.EXT_CLIENTES_COBRO_COMISION 
where CUENTA_TRANSACCION=@CUENTA_TRANSACCION
AND PERIODO=@PERIODO



update cent.EXT_CLIENTES_COBRO_COMISION 
set 
    PENDIENTE=1
    ,[FECHA_ACTUALIZACION] = getdate()
    ,[ULTIMO_ESTADO] = 'READ_ATC'
    ,[ULTIMO_ESTADO_DESC] ='LECTURA ARCHIVO ATC'
    ,[ULTIMA_RESPUESTA] = @ULTIMA_RESPUESTA
	,PROCESADO=RESTANTE
	,RESTANTE=0
	
where CUENTA_TRANSACCION=@CUENTA_TRANSACCION
AND PERIODO=@PERIODO
	
	END
	ELSE
	BEGIN
	
update cent.EXT_CLIENTES_COBRO_COMISION 
set 
    PENDIENTE=1
    ,[FECHA_ACTUALIZACION] = getdate()
    ,[ULTIMO_ESTADO] = 'READ_ATC'
    ,[ULTIMO_ESTADO_DESC] ='LECTURA ARCHIVO ATC'
    ,[ULTIMA_RESPUESTA] = @ULTIMA_RESPUESTA
	
where CUENTA_TRANSACCION=@CUENTA_TRANSACCION
AND PERIODO=@PERIODO

	END 

END


