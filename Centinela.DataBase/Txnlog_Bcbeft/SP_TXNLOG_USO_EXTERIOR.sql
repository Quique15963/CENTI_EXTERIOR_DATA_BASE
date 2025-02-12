USE [BCBEFT]
GO
/****** Object:  StoredProcedure [dbo].[SP_TXNLOG_USO_EXTERIOR]    Script Date: 7/12/2024 4:43:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================
-- Author:		Marlene Mamani Ale
-- Create date: 23/03/2016
-- Description:	Busquedad de la tabla TxnLog				
-- ===========================================================================

IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SP_TXNLOG_USO_EXTERIOR]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_TXNLOG_USO_EXTERIOR] AS'
END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

ALTER PROCEDURE [dbo].[SP_TXNLOG_USO_EXTERIOR]
	
	@FECHA_INICIO varchar(8),
	@FECHA_FIN varchar(8),
	@FLAG_REPROCESO bit
	

AS
BEGIN
	
	IF(@FLAG_REPROCESO =1)
	BEGIN
		select * from [dbo].[VIEW_TXNLOG_COMISIONES_EXTERIOR]
	where FECHA_TRANSACCION >=@FECHA_INICIO and FECHA_TRANSACCION<=@FECHA_FIN
	END
	ELSE
	BEGIN
	select * from [dbo].[VIEW_TXNLOG_COMISIONES_EXTERIOR]
	where FECHA_TRANSACCION = CONVERT(CHAR(8), GETDATE()-1,112)
	END

	

END





