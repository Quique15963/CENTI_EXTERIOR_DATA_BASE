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
		WHERE object_id = OBJECT_ID(N'[cent].[EXT_USO_CLIENTE_GENERAR_ARCHIVO_ATC_GET]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [cent].[EXT_USO_CLIENTE_GENERAR_ARCHIVO_ATC_GET] AS'
END
GO

ALTER PROCEDURE [cent].[EXT_USO_CLIENTE_GENERAR_ARCHIVO_ATC_GET] 
 
 AS
BEGIN
	SET NOCOUNT ON;

SELECT	
		Adjuntment =				'AJ',
		GeneralAccountNumber =		RIGHT('00000000000000000000' + LTRIM(RTRIM([CUENTA_TRANSACCION])), 20),
		CardNumber =				'0000000000000000000',
		Operation =					'D',
		CurrencyCode =				MONEDA_COBRO,
		AdjustmentAmount =			CONVERT(decimal(12, 6),sum( RESTANTE)),
		AdjustmentDate =			REPLACE(CONVERT(varchar(10),GETDATE(),103), '/', ''),
		AccountingCategoryCode =	CASE MONEDA_COBRO WHEN '068' THEN '0062' ELSE '0095' END,
		StatementCategoryCode =		'0144',
		BalanceCategoryCode =		'0104',
		AdditionalInformation =		REPLICATE(' ', 120),
		ExternalAdjustmentCode =	REPLICATE(' ', 20),
		FinancialCategoryCode =		'0604',
		PaymentBehavior =			'0',
		Filler =					REPLICATE(' ', 49),
		AdjustmentCode =			REPLICATE(' ', 20),
		ErrorCode =					REPLICATE(' ', 3),
		periodo=PERIODO,
		cuentaNazir=[CUENTA_TRANSACCION]

	FROM [cent].[EXT_CLIENTES_COBRO_COMISION]
	WHERE   CANAL_TRANSACCION='CREDITO'
	AND PENDIENTE=0
	and RESTANTE>0
	group by [CUENTA_TRANSACCION],MONEDA_COBRO,PERIODO
	order by 
	[CUENTA_TRANSACCION]
END




