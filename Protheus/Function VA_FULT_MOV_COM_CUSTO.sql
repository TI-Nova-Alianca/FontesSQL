
-- =============================================
-- Author     : Robert Koch
-- Create date: 22/07/2008
-- Description:	Busca custo do ultimo movimento com custo medio valido.
--              Util para casos em que o medio ainda nao foi calculado.
-- =============================================
-- Historico de alteracoes:
--

ALTER FUNCTION [dbo].[VA_FULT_MOV_COM_CUSTO]
(
	@FILIAL   AS VARCHAR(2),
	@PRODUTO  AS VARCHAR(15),
	@DATA     VARCHAR(8)
)
RETURNS TABLE
AS

RETURN
	SELECT TOP 1 *
	--TOP 100 PERCENT *
	FROM (
	SELECT TOP 1 D1_CUSTO / D1_QUANT AS CUSTO, 'SD1' AS ORIGEM, D1_SEQCALC AS SEQCALC, SD1.D1_EMISSAO AS EMISSAO
	FROM   SD1010 SD1
	WHERE  SD1.D_E_L_E_T_ = ''
	       AND SD1.D1_FILIAL = @FILIAL
	       AND SD1.D1_COD = @PRODUTO
	       AND SD1.D1_EMISSAO <= @DATA
	       AND SD1.D1_QUANT > 0
	ORDER BY SD1.D1_SEQCALC DESC
	UNION ALL
	SELECT TOP 1 D2_CUSTO1 / D2_QUANT AS CUSTO, 'SD2' AS ORIGEM, D2_SEQCALC AS SEQCALC, SD2.D2_EMISSAO AS EMISSAO
	FROM   SD2010 SD2
	WHERE  SD2.D_E_L_E_T_ = ''
	       AND SD2.D2_FILIAL = @FILIAL
	       AND SD2.D2_COD = @PRODUTO
	       AND SD2.D2_EMISSAO <= @DATA
	       AND SD2.D2_QUANT > 0
	ORDER BY SD2.D2_SEQCALC DESC
	UNION ALL
	SELECT TOP 1 D3_CUSTO1 / D3_QUANT AS CUSTO, 'SD3' AS ORIGEM, D3_SEQCALC AS SEQCALC, SD3.D3_EMISSAO AS EMISSAO
	FROM   SD3010 SD3
	WHERE  SD3.D_E_L_E_T_ = ''
	       AND SD3.D3_FILIAL = @FILIAL
	       AND SD3.D3_COD = @PRODUTO
	       AND SD3.D3_EMISSAO <= @DATA
	       AND SD3.D3_QUANT > 0
	ORDER BY SD3.D3_SEQCALC DESC
	) AS SUB
	ORDER BY SEQCALC DESC

--GO
--SELECT * FROM dbo.VA_FULT_MOV_COM_CUSTO ('07', '2205           ', '20121231')

