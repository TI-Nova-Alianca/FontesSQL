SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author     : Robert Koch
-- Create date: 24/06/2009
-- Description:	Busca o codigo filho do produto informado.
-- =============================================
-- Historico de alteracoes:
-- 01/03/2010 - Robert - Tabela SB1020 eliminada. Passa a apontar para SB1010.
--                     - Criado tratamento para empresa 10.
-- 07/11/2015 - Robert - Tratamento por empresa desabilitado (todas usam o cadastro da empresa 01).
--                     - Funcao renomeada de VA_ProdFilho para VA_FProdFilho.
--                     - Nao testa mais a posicao inicial do codigo. Verifica apenas o campo B1_CODPAI.
--

ALTER FUNCTION [dbo].[VA_ProdFilho]
(
	@ProdOri AS VARCHAR (15)
--	@Empresa as varchar (2)
)
RETURNS Varchar (15)
AS
BEGIN
	Declare @Ret as varchar (15)
	
	-- Conteudo default eh o proprio codigo
	set @Ret = @ProdOri
/*	
	if SUBSTRING (@ProdOri,1,1) != '8' AND @ProdOri != ''
	begin
		set @Ret = (
		case @Empresa
			when '01' then (SELECT B1_COD FROM SB1010 WHERE B1_FILIAL = '  ' AND B1_CODPAI = @ProdOri AND D_E_L_E_T_ = '')
			when '02' then (SELECT B1_COD FROM SB1010 WHERE B1_FILIAL = '  ' AND B1_CODPAI = @ProdOri AND D_E_L_E_T_ = '')
			when '03' then (SELECT B1_COD FROM SB1010 WHERE B1_FILIAL = '  ' AND B1_CODPAI = @ProdOri AND D_E_L_E_T_ = '')
			when '04' then (SELECT B1_COD FROM SB1010 WHERE B1_FILIAL = '  ' AND B1_CODPAI = @ProdOri AND D_E_L_E_T_ = '')
			when '10' then (SELECT B1_COD FROM SB1010 WHERE B1_FILIAL = '  ' AND B1_CODPAI = @ProdOri AND D_E_L_E_T_ = '')
			when '90' then (SELECT B1_COD FROM SB1010 WHERE B1_FILIAL = '  ' AND B1_CODPAI = @ProdOri AND D_E_L_E_T_ = '')
		end)
	END
*/
	set @Ret = (SELECT B1_COD FROM SB1010 WHERE B1_FILIAL = '  ' AND B1_CODPAI = @ProdOri AND D_E_L_E_T_ = '')
    if @Ret = ''
        SET @Ret = @ProdOri;

	RETURN @Ret
END
GO
