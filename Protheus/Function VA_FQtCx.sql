SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author     : Robert Koch
-- Create date: 22/07/2008
-- Description:	Calcula quantidade de caixas correspondente
--              à quantidade de unidades informada. Utilizada
--              principalmente para converter venda de garrafas para caixas.
-- =============================================
-- Historico de alteracoes:
-- 01/03/2010 - Robert  - Tabela SB1020 eliminada. Passa a apontar para SB1010.
--                      - Criado tratamento para empresa 10.
-- 07/11/2015 - Robert  - Tratamento por empresa desabilitado (todas olham na 01).
--                      - Funcao renomeada de VA_QTCX para VA_FQtCx.
--                      - Nao verifica mais a primeira posicao do codigo. Usa a funcao VA_FProdPai.

ALTER FUNCTION [dbo].[VA_FQtCx]
(
	@ProdOri AS VARCHAR (15),
	@QuantOri AS float
--	@Empresa as varchar (2)
)
RETURNS float
AS
BEGIN
	DECLARE @Ret as float
	declare @QtEmb as float
	DECLARE @ProdPai as varchar (15)
	set @Ret = @QuantOri
	--if substring (@ProdOri, 1, 1) = '8'
	--begin
		set @ProdPai = dbo.VA_FProdPai (@ProdOri) --, @Empresa)
		if @ProdPai = @ProdOri
			set @Ret = @QuantOri
		else
		begin
			set @QtEmb = (select isnull(B1_QTDEMB,0) from SB1010 where B1_FILIAL = '  ' and B1_COD = @ProdPai and D_E_L_E_T_ = '')
			set @Ret = @QuantOri / case @QtEmb When 0 then 1 else @QtEmb end
		end
	--end
	RETURN @Ret
END
;
GO
