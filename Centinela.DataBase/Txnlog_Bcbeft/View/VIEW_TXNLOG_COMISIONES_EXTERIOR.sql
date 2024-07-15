USE [BCBEFT]
GO

/****** Object:  View [dbo].[VIEW_TXNLOG_COMISIONES_EXTERIOR]    Script Date: 7/12/2024 4:54:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VIEW_TXNLOG_COMISIONES_EXTERIOR]
AS
SELECT pan AS NRO_TARJETA
         ,CONVERT(decimal(18,2), amount_txn)/100 as IMPORTE_ORIGEN
		 ,cur_code_txn as MONEDA_ORIGEN
         ,CONVERT(decimal(18,2), amount_sttl)/100 as IMPORTE_VISA
		 ,cur_code_sttl as MONEDA_VISA
         ,CONVERT(decimal(18,2), amount_cardhold)/100 as IMPORTE_AFECTACION_HOST
		 ,cur_code_cardhold as MONEDA_AFECTACION_HOST
         
		 ,CASE 
		 WHEN LEFT( RIGHT( '000'+convert(varchar(3),pos_entry_mode),3),2)IN('10','01') THEN 'COMPRAS POR INTERNET'
		 WHEN LEFT( RIGHT( '000'+convert(varchar(3),pos_entry_mode),3),2)IN('05','07') AND  merchant   not in ('6010','6011') THEN 'PAGOS POR POS'
		 WHEN LEFT( RIGHT( '000'+convert(varchar(3),pos_entry_mode),3),2)IN('05','07') AND  merchant  in ('6010','6011') THEN 'CAJERO'
		else 	'PAGOS POR POS'		  
		 END AS TIPO_TRANSACCION
         ,CONVERT(nvarchar(max),  SUBSTRING( name_local,1,LEN(name_local)-2)) AS UBICACION 
		 ,SUBSTRING( LTRIM(RTRIM(name_local)),LEN(LTRIM(RTRIM(name_local)))-1,3) AS PAIS_ORIGEN 
         --,acq_country_code AS CODIGO_PAIS
		 ,transdate as FECHA_TRANSACCION
		 , CASE WHEN LEFT(pan,6)='449192' THEN 'DEBITO'
		 ELSE 'CREDITO' END AS TIPO_TARJETA
		 ,substring(acct_1, 1,18) as CUENTA
		 ,substring(acct_1, LEN(acct_1)-2,3) as MONEDA_CUENTA
		 --,convrate_sttl
		 --,convrate_cardhold
		 ,GETDATE() FECHA_REGISTRO
		 ,case 
when substring(transdate,7,2)  BETWEEN 1 and 15 
then 'Q1-' +upper( CONVERT(varchar(3),convert(date,transdate),109))+'-'+substring(transdate,1,4)
else 'Q2-' +upper(CONVERT(varchar(3),convert(date,transdate),109))+'-'+substring(transdate,1,4)
end as PERIODO
,msgtype as MSGTYPE
,trace AS TRACE
,refnum AS REFNUM
,auth as AUTH
,reversal AS REVERSAL

  FROM [BCBEFT].[dbo].[txnlog]
  
  where resp_code='00' AND reversal='0'  and msgtype<>'400' and [acq_country_code]<>'68'
  AND  LEFT( RIGHT( '000000'+convert(varchar(6),prcode),6),2) in ('00','01','40','41')
  
  
GO


