USE [APOM]
GO
/****** Object:  StoredProcedure [napom].[APOM_GET_TRANSACCIONES_COMPLETADAS]    Script Date: 7/12/2024 4:19:22 PM ******/
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
		WHERE object_id = OBJECT_ID(N'[napom].[APOM_GET_TRANSACCIONES_COMPLETADAS]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [napom].[APOM_GET_TRANSACCIONES_COMPLETADAS] AS'
END
GO

ALTER PROCEDURE [napom].[APOM_GET_TRANSACCIONES_COMPLETADAS] 
    	@FECHA_INICIO varchar(8),
		@FECHA_FIN varchar(8),
		@FLAG_REPROCESO bit

AS
BEGIN

		IF(@FLAG_REPROCESO =1)
			BEGIN

	
		SELECT
		'' as 'NRO_TARJETA'
		,IMPORTE_TRANS as 'IMPORTE_ORIGEN'
		,MONEDA_TRANS as 'MONEDA_ORIGEN'
		,MONTO_DOLAR_TRANS as 'IMPORTE_USD'
		,'840' as 'MONEDA_USD'
		,MONTO_DOLAR_TRANS*TIPO_CAMBIO_CTA as 'IMPORTE_BOL'
		,TIPO_CAMBIO_CTA
		,'068' as 'MONEDA_BOL'
		,'TRANSFERENCIA DEBITO EN CUENTA' AS 'TIPO_TRANSACCION'
		,case
		when a.OPERACION like '9%' AND FISCAL_OPER NOT IN ('CredinetWeb') AND OBSERVACION_FISCAL IS NOT NULL
		 then convert(Nvarchar,a.OPERACION)
		else 'NO APLICA' END
		AS UBICACION

		,'BO' AS PAIS_ORIGEN
		,convert(varchar(8), FECH_REV_FISCAL)  AS 'FECHA_TRANSACCION'
		,'TRANSFERENCIA' AS 'TIPO_TARJETA'
		,CTA_COMISION_OPER AS 'CUENTA'
		, case
		when 
		substring(CTA_COMISION_OPER, LEN(CTA_COMISION_OPER)-2,1) ='3' then '068'
		else '840' end AS 'MONEDA_CUENTA'
		,GETDATE() FECHA_REGISTRO

		,case 
		when substring(FECH_REV_FISCAL,7,2)  BETWEEN 1 and 15 
		then CONVERT(VARCHAR(20), 'Q1-' +upper( CONVERT(varchar(3),convert(date,FECH_REV_FISCAL),109))+'-'+substring(FECH_REV_FISCAL,1,4))
		else CONVERT(VARCHAR(20), 'Q2-' +upper(CONVERT(varchar(3),convert(date,FECH_REV_FISCAL),109))+'-'+substring(FECH_REV_FISCAL,1,4))
		end as PERIODO


		FROM [APOM].[dbo].[APOM_OPERACION_ENVIADAS_HISTORICA] a
		inner join [APOM].[dbo].APOM_TRANSFERENCIAS_ENVIADAS_HISTORICA b on a.OPERACION=b.OPERACION 
		inner join [APOM].[dbo].APOM_CUENTA_ENVIADAS_HISTORICA c on a.OPERACION=c.OPERACION 
		where a.ESTADO_OPER='E' and b.ESTADO_TRANS=7 
		and FECH_REV_FISCAL >=@FECHA_INICIO and FECH_REV_FISCAL<=@FECHA_FIN
			end
			else
			begin

	
		SELECT
		'' as 'NRO_TARJETA'
		,IMPORTE_TRANS as 'IMPORTE_ORIGEN'
		,MONEDA_TRANS as 'MONEDA_ORIGEN'
		,MONTO_DOLAR_TRANS as 'IMPORTE_USD'
		,'840' as 'MONEDA_USD'
		,MONTO_DOLAR_TRANS*TIPO_CAMBIO_CTA as 'IMPORTE_BOL'
		,TIPO_CAMBIO_CTA
		,'068' as 'MONEDA_BOL'
		,'TRANSFERENCIA DEBITO EN CUENTA' AS 'TIPO_TRANSACCION'
		,case
		when a.OPERACION like '9%' AND FISCAL_OPER NOT IN ('CredinetWeb') AND OBSERVACION_FISCAL IS NOT NULL
		 then convert(Nvarchar,a.OPERACION)
		else 'NO APLICA' END
		AS UBICACION

		,'BO' AS PAIS_ORIGEN
		,convert(varchar(8), FECH_REV_FISCAL)  AS 'FECHA_TRANSACCION'
		,'TRANSFERENCIA' AS 'TIPO_TARJETA'
		,CTA_COMISION_OPER AS 'CUENTA'
		, case
		when 
		substring(CTA_COMISION_OPER, LEN(CTA_COMISION_OPER)-2,1) ='3' then '068'
		else '840' end AS 'MONEDA_CUENTA'
		,GETDATE() FECHA_REGISTRO

		,case 
		when substring(FECH_REV_FISCAL,7,2)  BETWEEN 1 and 15 
		then CONVERT(VARCHAR(20), 'Q1-' +upper( CONVERT(varchar(3),convert(date,FECH_REV_FISCAL),109))+'-'+substring(FECH_REV_FISCAL,1,4))
		else CONVERT(VARCHAR(20), 'Q2-' +upper(CONVERT(varchar(3),convert(date,FECH_REV_FISCAL),109))+'-'+substring(FECH_REV_FISCAL,1,4))
		end as PERIODO


		FROM [APOM].[dbo].[APOM_OPERACION_ENVIADAS_HISTORICA] a
		inner join [APOM].[dbo].APOM_TRANSFERENCIAS_ENVIADAS_HISTORICA b on a.OPERACION=b.OPERACION 
		inner join [APOM].[dbo].APOM_CUENTA_ENVIADAS_HISTORICA c on a.OPERACION=c.OPERACION 
		where a.ESTADO_OPER='E' and b.ESTADO_TRANS=7 
		and FECH_REV_FISCAL =CONVERT(char(8),  GETDATE()-1,112)
	END


--AND FECH_REV_FISCAL =
--CASE 
--WHEN LTRIM(RTRIM(@FECHA_TRANSACCION))='' THEN convert(char(8), getdate()-1,112)
--ELSE @FECHA_TRANSACCION END


END 