USE [BD_NAZIR]
GO
/****** Object:  StoredProcedure [nazir].[EXT_USO_COMISION_MOVIM]    Script Date: 7/12/2024 4:06:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[nazir].[EXT_USO_COMISION_MOVIM]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [nazir].[EXT_USO_COMISION_MOVIM] AS'
END
GO

ALTER PROCEDURE [nazir].[EXT_USO_COMISION_MOVIM] 

@FECHA_INICIO varchar(8),
	@FECHA_FIN varchar(8),
	@FLAG_REPROCESO bit
AS 


IF(@FLAG_REPROCESO =1)
	BEGIN

	
SELECT CONVERT(CHAR(8),ATCUC086.[FECHA_CARGA], 112)  AS MV_FECCREARCHIVO
,ATCUC086.[FECTRX] AS MV_FECTRANSAC
,Case
when substring(CONVERT(CHAR(8),ATCUC086.[FECHA_CARGA], 112),7,2)  BETWEEN 1 and 15 
then 'Q1-' +upper( CONVERT(varchar(3),convert(date,[FECHA_CARGA]),109))+'-'+substring(CONVERT(CHAR(8),ATCUC086.[FECHA_CARGA], 112),1,4)
else 'Q2-' +upper(CONVERT(varchar(3),convert(date,[FECHA_CARGA]),109))+'-'+substring(CONVERT(CHAR(8),ATCUC086.[FECHA_CARGA], 112),1,4)
end as PERIODO_ACTUAL

,Case
when substring(ATCUC086.[FECTRX],7,2)  BETWEEN 1 and 15 
then 'Q1-' +upper( CONVERT(varchar(3),convert(date,ATCUC086.[FECTRX]),109))+'-'+substring(ATCUC086.[FECTRX],1,4)
else 'Q2-' +upper(CONVERT(varchar(3),convert(date,ATCUC086.[FECTRX]),109))+'-'+substring(ATCUC086.[FECTRX],1,4)
end as PERIODO_TRANS

			,(CASE	WHEN LEN (LTRIM (RTRIM (CTA.CIC)) ) = 12 AND (LTRIM (RTRIM (CTA.CIC)) ) NOT LIKE 'CLIA%' THEN ('    '+SUBSTRING(CTA.CIC,5,12))
				WHEN LEN (LTRIM (RTRIM (CTA.CIC)) ) = 8 THEN ('    '+LTRIM (RTRIM (CTA.CIC)) )
				WHEN LEN (LTRIM (RTRIM (CTA.CIC)) ) = 12 AND (LTRIM (RTRIM (CTA.CIC)) ) LIKE 'CLIA%' THEN CTA.CIC
					END ) AS MV_CIC
			
			,ATCUC086.[NUMCTA] AS MV_NROCUENTA
			,CONVERT(NVARCHAR(50), ATCUC086.NUMTAR) AS TARJETA_OFUSCADA
			,CONVERT(NVARCHAR(MAX), TEXTO) AS MV_NOMTRANSAC		

			,CODAUT	AS CODAUT 
			
			,ATCUC086.[MONLIQUIDAC] AS MONEDA_AFECTACION
			,CONVERT(DECIMAL(11,2),(CONVERT (decimal (11, 2), SUBSTRING (ATCUC086.[IMPLIQUIDAC],1,LEN (ATCUC086.[IMPLIQUIDAC])-2) + '.' + SUBSTRING (ATCUC086.[IMPLIQUIDAC],LEN (ATCUC086.[IMPLIQUIDAC])-1,2)) 
				 + CONVERT (decimal (11, 2), SUBSTRING (ATCUC086.MONTOS_ADICIONALES,1,LEN (ATCUC086.MONTOS_ADICIONALES)-2) + '.' + SUBSTRING (ATCUC086.MONTOS_ADICIONALES,LEN (ATCUC086.MONTOS_ADICIONALES)-1,2)) ))
			
			AS IMPORTE_AFECTACION

						
			,CASE		WHEN   IMPORIGEN <> '+0000000000' AND MONORIGEN <> MONLIQUIDAC		THEN CONVERT (decimal(19,2),CONVERT (NUMERIC,IMPORIGEN) /100)
						WHEN	IMPORIGEN = '+0000000000' AND IMPBALANCE <> '+0000000000' AND MONBALANCE <> MONLIQUIDAC	THEN CONVERT (decimal(19,2),CONVERT (NUMERIC,IMPBALANCE) /100)
						ELSE '0.00'
				END AS IMPORTE_ORIGINAL
			
			,CASE		WHEN   IMPORIGEN <> '+0000000000' AND MONORIGEN <> MONLIQUIDAC		THEN MONORIGEN
						WHEN	IMPORIGEN = '+0000000000' AND IMPBALANCE <> '+0000000000' AND MONBALANCE <> MONLIQUIDAC	THEN MONBALANCE
						ELSE ''
				END AS MONEDA_ORIGINAL
			,GETDATE() AS FECHA_REGISTRO
			
	  FROM  [BD_NAZIR].[nazir].[ATCUC086_MOVEMISOR] ATCUC086
	  INNER JOIN [BD_NAZIR].[nazir].[CUENTA] CTA
	  
	  ON ATCUC086.[NUMCTA] = CTA.NUMERO_CUENTA
	  
	  WHERE  ATCUC086.SCOPE ='4'
	  AND CONVERT(VARCHAR(8),ATCUC086.FECHA_CARGA,112) >=@FECHA_INICIO and CONVERT(VARCHAR(8),ATCUC086.FECHA_CARGA,112)<=@FECHA_FIN
	  ORDER BY 2
	
	

	END
	ELSE
	BEGIN

SELECT CONVERT(CHAR(8),ATCUC086.[FECHA_CARGA], 112)  AS MV_FECCREARCHIVO
,ATCUC086.[FECTRX] AS MV_FECTRANSAC
,Case
when substring(CONVERT(CHAR(8),ATCUC086.[FECHA_CARGA], 112),7,2)  BETWEEN 1 and 15 
then 'Q1-' +upper( CONVERT(varchar(3),convert(date,[FECHA_CARGA]),109))+'-'+substring(CONVERT(CHAR(8),ATCUC086.[FECHA_CARGA], 112),1,4)
else 'Q2-' +upper(CONVERT(varchar(3),convert(date,[FECHA_CARGA]),109))+'-'+substring(CONVERT(CHAR(8),ATCUC086.[FECHA_CARGA], 112),1,4)
end as PERIODO_ACTUAL

,Case
when substring(ATCUC086.[FECTRX],7,2)  BETWEEN 1 and 15 
then 'Q1-' +upper( CONVERT(varchar(3),convert(date,ATCUC086.[FECTRX]),109))+'-'+substring(ATCUC086.[FECTRX],1,4)
else 'Q2-' +upper(CONVERT(varchar(3),convert(date,ATCUC086.[FECTRX]),109))+'-'+substring(ATCUC086.[FECTRX],1,4)
end as PERIODO_TRANS

			,(CASE	WHEN LEN (LTRIM (RTRIM (CTA.CIC)) ) = 12 AND (LTRIM (RTRIM (CTA.CIC)) ) NOT LIKE 'CLIA%' THEN ('    '+SUBSTRING(CTA.CIC,5,12))
				WHEN LEN (LTRIM (RTRIM (CTA.CIC)) ) = 8 THEN ('    '+LTRIM (RTRIM (CTA.CIC)) )
				WHEN LEN (LTRIM (RTRIM (CTA.CIC)) ) = 12 AND (LTRIM (RTRIM (CTA.CIC)) ) LIKE 'CLIA%' THEN CTA.CIC
					END ) AS MV_CIC
			
			,ATCUC086.[NUMCTA] AS MV_NROCUENTA
			,CONVERT(NVARCHAR(50), ATCUC086.NUMTAR) AS TARJETA_OFUSCADA
			,CONVERT(NVARCHAR(MAX), TEXTO) AS MV_NOMTRANSAC		

			,CODAUT	AS CODAUT 
			
			,ATCUC086.[MONLIQUIDAC] AS MONEDA_AFECTACION
			,CONVERT(DECIMAL(11,2),(CONVERT (decimal (11, 2), SUBSTRING (ATCUC086.[IMPLIQUIDAC],1,LEN (ATCUC086.[IMPLIQUIDAC])-2) + '.' + SUBSTRING (ATCUC086.[IMPLIQUIDAC],LEN (ATCUC086.[IMPLIQUIDAC])-1,2)) 
				 + CONVERT (decimal (11, 2), SUBSTRING (ATCUC086.MONTOS_ADICIONALES,1,LEN (ATCUC086.MONTOS_ADICIONALES)-2) + '.' + SUBSTRING (ATCUC086.MONTOS_ADICIONALES,LEN (ATCUC086.MONTOS_ADICIONALES)-1,2)) ))
			
			AS IMPORTE_AFECTACION

						
			,CASE		WHEN   IMPORIGEN <> '+0000000000' AND MONORIGEN <> MONLIQUIDAC		THEN CONVERT (decimal(19,2),CONVERT (NUMERIC,IMPORIGEN) /100)
						WHEN	IMPORIGEN = '+0000000000' AND IMPBALANCE <> '+0000000000' AND MONBALANCE <> MONLIQUIDAC	THEN CONVERT (decimal(19,2),CONVERT (NUMERIC,IMPBALANCE) /100)
						ELSE '0.00'
				END AS IMPORTE_ORIGINAL
			
			,CASE		WHEN   IMPORIGEN <> '+0000000000' AND MONORIGEN <> MONLIQUIDAC		THEN MONORIGEN
						WHEN	IMPORIGEN = '+0000000000' AND IMPBALANCE <> '+0000000000' AND MONBALANCE <> MONLIQUIDAC	THEN MONBALANCE
						ELSE ''
				END AS MONEDA_ORIGINAL
		,GETDATE() AS FECHA_REGISTRO	
	  FROM  [BD_NAZIR].[nazir].[ATCUC086_MOVEMISOR] ATCUC086
	  INNER JOIN [BD_NAZIR].[nazir].[CUENTA] CTA
	  
	  ON ATCUC086.[NUMCTA] = CTA.NUMERO_CUENTA
	  
	  WHERE  ATCUC086.SCOPE ='4'
	  AND CONVERT(VARCHAR(8),ATCUC086.FECHA_CARGA,112) = CONVERT(CHAR(8), GETDATE()-1,112)
	  ORDER BY 2
	

	END


