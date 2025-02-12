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
		WHERE object_id = OBJECT_ID(N'[cent].[EXT_USO_CARGA_QUINCENA_INSERT]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [cent].[EXT_USO_CARGA_QUINCENA_INSERT] AS'
END
GO

ALTER PROCEDURE [cent].[EXT_USO_CARGA_QUINCENA_INSERT] 
 @TIPO_CAMBIO DECIMAL(18,2)
 	
AS
BEGIN
	SET NOCOUNT ON;


declare @FECHA_ACTUAL DATETIME

declare @MES CHAR(3)
declare @GESTION CHAR(4)
declare @PERIODO CHAR(20)


SET @FECHA_ACTUAL =GETDATE()-1

--select  GETDATE()-48

declare @TIEMPO_LIMITE_COBRO INT

SET @TIEMPO_LIMITE_COBRO=(SELECT CONVERT(INT,[VALOR]) FROM [cent].[EXT_USO_PARAMETROS] WHERE PARAMETRO='TIEMPO_LIMITE_COBRO')

SET @MES=upper( CONVERT(varchar(3),@FECHA_ACTUAL,109));
SET @GESTION=SUBSTRING( CONVERT(varchar(8),@FECHA_ACTUAL,112),1,4);


SET @PERIODO=
case 
when SUBSTRING( CONVERT(varchar(8),@FECHA_ACTUAL,112),7,2)  between  1 AND 15
then CONVERT(VARCHAR(20), 'Q1-' +@MES+'-'+@GESTION)
ELSE CONVERT(VARCHAR(20), 'Q2-' +@MES+'-'+@GESTION)
end 


IF OBJECT_ID('tempdb..#TEMP') IS NOT NULL
    DROP TABLE #TEMP
IF OBJECT_ID('tempdb..#TEMP2') IS NOT NULL
    DROP TABLE #TEMP2

select count(CIC) as CANT_TRANS, CIC,PERIODO 
INTO #TEMP
from [cent].[EXT_USO_EXTERIOR_COBRO_COMISION]
where IMPORTE_BOL>(select convert(decimal(18,2),VALOR) from [cent].[EXT_USO_PARAMETROS] where PARAMETRO='LIMITE_TRANS_BOL')
AND CIC!=''
AND PERIODO=@PERIODO
group by CIC,PERIODO

-------------------------------------TARJETAS DE CREDITO------------------------------------
OPEN SYMMETRIC KEY skBCP_DEV DECRYPTION BY CERTIFICATE CertBCP_DEV

SELECT 
CIC
,sum(IMPORTE_USD) as TOTAL_USD
,sum(IMPORTE_BOL) AS TOTAL_BOL
,sum(IMPORTE_USD*PORCENTAJE_COMISION) AS COMISION_USD
,sum(IMPORTE_BOL*PORCENTAJE_COMISION) AS COMISION_BOL
,MONEDA_TARJETA AS MONEDA_COBRO

,sum (case 
when MONEDA_TARJETA='068' then IMPORTE_BOL*PORCENTAJE_COMISION
else IMPORTE_USD*PORCENTAJE_COMISION
end) AS TOTAL_COMISION_COBRO

,GLOSAUTILIZAR
,TARJETA_OFUSCADA
,CUENTA_TRANSACCION
,CANAL_TRANSACCION
,CONVERT(varchar,DECRYPTBYKEY(TARJETA_ENCRIPTADA)) AS TARJETA
INTO #TEMP2
FROM [cent].[EXT_USO_EXTERIOR_COBRO_COMISION]
where CANAL_TRANSACCION='CREDITO'
AND PERIODO=@PERIODO
AND CIC IN (SELECT CIC FROM #TEMP)
AND PERIODO not in (SELECT distinct [PERIODO] FROM [cent].[EXT_CLIENTES_COBRO_COMISION])
group by CUENTA_TRANSACCION,TARJETA_OFUSCADA,CONVERT(varchar,DECRYPTBYKEY(TARJETA_ENCRIPTADA)),CIC,MONEDA_TARJETA,GLOSAUTILIZAR,CANAL_TRANSACCION

 
-------------------------------------TARJETAS DE DEBITO------------------------------------
INSERT INTO #TEMP2
SELECT 
CIC
,sum(IMPORTE_USD) as TOTAL_USD
,sum(IMPORTE_BOL) AS TOTAL_BOL
,sum(IMPORTE_USD*PORCENTAJE_COMISION) AS COMISION_USD
,sum(IMPORTE_BOL*PORCENTAJE_COMISION) AS COMISION_BOL
,'068' AS MONEDA_COBRO
,sum (IMPORTE_BOL*PORCENTAJE_COMISION) AS TOTAL_COMISION_COBRO
,GLOSAUTILIZAR
,CUENTA_TRANSACCION as 'TARJETA_OFUSCADA'
,CUENTA_TRANSACCION
,CANAL_TRANSACCION
,'' AS TARJETA
FROM [cent].[EXT_USO_EXTERIOR_COBRO_COMISION]
where CANAL_TRANSACCION='DEBITO'
AND PERIODO=@PERIODO
AND CIC IN (SELECT CIC FROM #TEMP)
AND PERIODO not in (SELECT distinct [PERIODO] FROM [cent].[EXT_CLIENTES_COBRO_COMISION])
group by CUENTA_TRANSACCION,CIC,MONEDA_TARJETA,GLOSAUTILIZAR,CANAL_TRANSACCION

-------------------------------------TRANSFERENCIAS------------------------------------
INSERT INTO #TEMP2
SELECT 
CIC
,sum(IMPORTE_USD) as TOTAL_USD
,sum(IMPORTE_BOL) AS TOTAL_BOL
,sum(IMPORTE_USD*PORCENTAJE_COMISION) AS COMISION_USD
,sum(IMPORTE_BOL*PORCENTAJE_COMISION) AS COMISION_BOL
,'068' AS MONEDA_COBRO
,sum (IMPORTE_BOL*PORCENTAJE_COMISION) AS TOTAL_COMISION_COBRO
,GLOSAUTILIZAR
,CUENTA_TRANSACCION as 'TARJETA_OFUSCADA'
,CUENTA_TRANSACCION
,CANAL_TRANSACCION
,'' AS TARJETA
FROM [cent].[EXT_USO_EXTERIOR_COBRO_COMISION]
where CANAL_TRANSACCION='TRANSFERENCIA'
AND PERIODO=@PERIODO
AND CIC IN (SELECT CIC FROM #TEMP)
AND FLAG_COBRO=1
AND PERIODO not in (SELECT distinct [PERIODO] FROM [cent].[EXT_CLIENTES_COBRO_COMISION])
group by CUENTA_TRANSACCION,CIC,MONEDA_TARJETA,GLOSAUTILIZAR,CANAL_TRANSACCION
ORDER BY 1


  insert into cent.EXT_CLIENTES_COBRO_COMISION
  SELECT 
       ENCRYPTBYKEY(Key_GUID('skBCP_DEV'), CONVERT(varbinary(256), TARJETA))
      ,[TARJETA_OFUSCADA]
      ,@PERIODO
      ,[CIC]
      ,TOTAL_USD
      ,TOTAL_BOL
      ,[COMISION_USD]
      ,[COMISION_BOL]
      ,@TIPO_CAMBIO
      ,[MONEDA_COBRO]
      ,TOTAL_COMISION_COBRO
      ,0
      ,TOTAL_COMISION_COBRO
      ,0
      ,CONVERT(CHAR(8),GETDATE(),112)
      ,CONVERT(CHAR(8),GETDATE()+ @TIEMPO_LIMITE_COBRO,112)
      ,[GLOSAUTILIZAR]
	  ,CUENTA_TRANSACCION
      ,1
      ,''
      ,''
      ,''
      ,0
      ,[CANAL_TRANSACCION]
      ,GETDATE()
      ,GETDATE()
      ,'CENTINELA'
      ,''
      ,0
  FROM #TEMP2
 


  CLOSE SYMMETRIC KEY skBCP_DEV	

END




