SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author     : Robert Koch
-- Create date: 24/06/2009
-- Description:	Calcula quantidade de unidades correspondente
--              à quantidade de caixas informada. Utilizada
--              principalmente para converter venda de caixas
--              para garrafas ou bags.
-- =============================================
-- Historico de alteracoes:
-- 01/03/2010 - Robert - Tabela SB1020 eliminada. Passa a apontar para SB1010.
--                     - Criado tratamento para empresa 10.
-- 07/11/2015 - Robert - Desabilitado controle por empresa (todas olham na empresa 01).
--

ALTER FUNCTION [dbo].[VA_FQtUnid]
(
	@ProdOri AS VARCHAR (15),
	@QuantOri AS float--,
	--@Empresa as varchar (2)
)
RETURNS float
AS
BEGIN
	DECLARE @Ret as float
	declare @QtEmb as float
	DECLARE @ProdFilho as varchar (15)
	set @Ret = @QuantOri
	set @ProdFilho = dbo.VA_ProdFilho (@ProdOri)--, @Empresa)
	if @ProdFilho != @ProdOri
	begin
		set @QtEmb = (
		/*
		case @Empresa
			when '01' then (*/select B1_QTDEMB from SB1010 where B1_FILIAL = '  ' and B1_COD = @ProdOri and D_E_L_E_T_ = '')
			/*
			when '02' then (select B1_QTDEMB from SB1010 where B1_FILIAL = '  ' and B1_COD = @ProdOri and D_E_L_E_T_ = '')
			when '03' then (select B1_QTDEMB from SB1010 where B1_FILIAL = '  ' and B1_COD = @ProdOri and D_E_L_E_T_ = '')
			when '04' then (select B1_QTDEMB from SB1010 where B1_FILIAL = '  ' and B1_COD = @ProdOri and D_E_L_E_T_ = '')
			when '10' then (select B1_QTDEMB from SB1010 where B1_FILIAL = '  ' and B1_COD = @ProdOri and D_E_L_E_T_ = '')
			when '90' then (select B1_QTDEMB from SB1010 where B1_FILIAL = '  ' and B1_COD = @ProdOri and D_E_L_E_T_ = '')
		end
		)*/
		set @Ret = @QuantOri * case @QtEmb When 0 then 1 else @QtEmb end
	end
	RETURN @Ret
END
GO
