SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author     : Robert Koch
-- Create date: 04/08/2008
-- Description:	Busca o codigo pai do produto informado.
-- =============================================
-- Historico de alteracoes:
-- 01/03/2010 - Robert - Tabela SB1020 eliminada. Passa a apontar para SB1010.
--                     - Criado tratamento para empresa 10.
-- 04/08/2010 - Robert - Caso nao encontrasse o codigo do pai, retornava NULL.
-- 07/11/2015 - Robert - Tratamento por empresa desabilitado (todas usam o cadastro da empresa 01).
--                     - Funcao renomeada de VA_ProdPai para VA_FProdPai.
--                     - Nao testa mais a posicao inicial do codigo. Verifica apenas o campo B1_CODPAI.

ALTER FUNCTION [dbo].[VA_FProdPai]
(
	@ProdOri  AS VARCHAR(15)
--	@Empresa  AS VARCHAR(2)
)
RETURNS VARCHAR(15)
AS

BEGIN
	DECLARE @Ret AS VARCHAR(15)
	
	-- Conteudo default eh o proprio codigo
	SET @Ret = @ProdOri
	
	--IF SUBSTRING(@ProdOri, 1, 1) = '8'
	--BEGIN
	    -- Olha sempre na tabela da empresa 01 por que a tabela eh compartilhada.
	    SET @Ret = (
	            SELECT B1_CODPAI
	            FROM   SB1010
	            WHERE  B1_FILIAL = '  '
	                   AND B1_COD = @ProdOri
	                   AND D_E_L_E_T_ = ''
	        );
	    IF @Ret = ''
	    --BEGIN
	        SET @Ret = @ProdOri;
	    --END
	--END
	
	RETURN @Ret
END
GO
