USE [BCBEFT]
GO

/****** Object:  View [dbo].[VIEW_TXNLOG_COMISIONES_EXTERIOR_REVERSION]    Script Date: 7/12/2024 4:55:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VIEW_TXNLOG_COMISIONES_EXTERIOR_REVERSION]
AS
SELECT pan AS NRO_TARJETA
         ,CONVERT(decimal(18,2), amount_txn)/100 as IMPORTE_ORIGEN
		 ,cur_code_txn as MONEDA_ORIGEN
		 
		
         ,CONVERT(nvarchar(max),  SUBSTRING( name_local,1,LEN(name_local)-2)) AS UBICACION 
		 ,SUBSTRING( LTRIM(RTRIM(name_local)),LEN(LTRIM(RTRIM(name_local)))-1,3) AS PAIS_ORIGEN 
         --,acq_country_code AS CODIGO_PAIS
		 ,transdate as FECHA_TRANSACCION
		 ,date_local as FECHA_LOCAL
		
		

		 ,GETDATE() FECHA_REGISTRO
		 ,case 
when substring(transdate,7,2)  BETWEEN 1 and 15 
then 'Q1-' +upper( CONVERT(varchar(3),convert(date,transdate),109))+'-'+substring(transdate,1,4)
else 'Q2-' +upper(CONVERT(varchar(3),convert(date,transdate),109))+'-'+substring(transdate,1,4)
end as PERIODO_ACTUAL

		 ,case 
when substring(date_local,7,2)  BETWEEN 1 and 15 
then 'Q1-' +upper( CONVERT(varchar(3),convert(date,date_local),109))+'-'+substring(date_local,1,4)
else 'Q2-' +upper(CONVERT(varchar(3),convert(date,date_local),109))+'-'+substring(date_local,1,4)
end as PERIODO_TRANSACCION


,msgtype as MSGTYPE
,trace AS TRACE
,refnum AS REFNUM


  FROM [BCBEFT].[dbo].[txnlog]
  
  where msgtype='400' and  LEFT(pan,6)<>'449192' and [acq_country_code]<>'68'
 
GO


