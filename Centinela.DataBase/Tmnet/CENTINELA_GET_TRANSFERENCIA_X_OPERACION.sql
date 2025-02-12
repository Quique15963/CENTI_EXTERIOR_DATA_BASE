USE [DB_BCPTRANSACTOR]
GO
/****** Object:  StoredProcedure [dbo].[CENTINELA_GET_TRANSFERENCIA_X_OPERACION]    Script Date: 7/11/2024 3:32:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================
-- Autor:		S60547
-- Fecha Modificación: 2016/08/20
-- Descripción:	SP que retorna información de la operación enviada al exterior de Transactor, considerando los criterios 
--				de búsqueda el Nro. Liquidación y Fecha de la operación. 
-- ============================================================================================

IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[CENTINELA_GET_TRANSFERENCIA_X_OPERACION]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CENTINELA_GET_TRANSFERENCIA_X_OPERACION] AS'
END
GO

ALTER PROCEDURE [dbo].[CENTINELA_GET_TRANSFERENCIA_X_OPERACION] 
	@OPERACION nVARCHAR(100),
	@FECHA VARCHAR(8)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT b.* FROM [dbo].[TB_TRA_CONTROL_SWIF] a
inner join [dbo].[TB_TRA_ITF_GENERADO] b
on ltrim(rtrim(a.NroLiquidacion))= ltrim(trim(b.NROLIQUIDACION))
and convert(char(8),a.Fecha,112)= b.FECHA
where 
CAUSAL='TRAEX'
and FPAGO='EFE'
AND convert(char(8),a.Fecha,112)=@FECHA
AND NroOperacionServicio=@OPERACION


END


