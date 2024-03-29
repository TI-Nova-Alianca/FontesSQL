
-- Descricao: Verifica problemas de integridade entre tabelas de saldos em estoque.
-- Autor....: Robert Koch
-- Data.....: 18/12/2020
--
-- Historico de alteracoes:
-- 13/04/2021 - Robert - Melhoradas mensagens (passa a mostrar também os saldos encontrados).
-- 18/06/2021 - Robert - Melhorias para considerar saldo a enderecar.
-- 10/09/2021 - Robert - Melhorada mensagem de retorno.
-- 12/09/2021 - Robert - Trocada funcao CAST por FORMAT na mensagem de retorno (trata melhor valores grandes).
-- 05/09/2023 - Robert - Trocada funcao ROUND por CAST AS DECIMAL por que com ROUND o resultado continua sendo um FLOAT (https://stackoverflow.com/questions/71512718/integer-division-round-off-to-2-decimal-places-in-sql-server)
--                     - Pequena melhoria na formatacao da string de retorno.
--

ALTER PROCEDURE [dbo].[VA_SP_VERIFICA_ESTOQUES]
(
	@IN_FILIAL VARCHAR (2)
	,@IN_PRODUTO VARCHAR (15)
	,@IN_ALMOX VARCHAR (2)
) AS
BEGIN
	-- DEFINE VARIAVEIS PARA USO NAS QUERIES, PERMITINDO QUE A PROCEDURE RECEBA PARAMETROS 'NULL' E RETORNE TODAS AS SITUACOES.
	DECLARE @FILINI   VARCHAR (2)  = CASE WHEN @IN_FILIAL  IS NOT NULL THEN @IN_FILIAL  ELSE ''   END
	DECLARE @FILFIM   VARCHAR (2)  = CASE WHEN @IN_FILIAL  IS NOT NULL THEN @IN_FILIAL  ELSE 'zz' END
	DECLARE @PRODINI  VARCHAR (15) = CASE WHEN @IN_PRODUTO IS NOT NULL THEN @IN_PRODUTO ELSE ''   END
	DECLARE @PRODFIM  VARCHAR (15) = CASE WHEN @IN_PRODUTO IS NOT NULL THEN @IN_PRODUTO ELSE 'zzzzzzzzzzzzzzz' END
	DECLARE @ALMOXINI VARCHAR (2)  = CASE WHEN @IN_ALMOX   IS NOT NULL THEN @IN_ALMOX   ELSE ''   END
	DECLARE @ALMOXFIM VARCHAR (2)  = CASE WHEN @IN_ALMOX   IS NOT NULL THEN @IN_ALMOX   ELSE 'zz' END

-- GERA LISTA DE TODAS AS COMBINACOES DE FILIAL X PRODUTO X ALMOXARIFADO, PARA PODER BUSCAR ITENS QUE EXISTEM NUMA TABELA E NAO NAS OUTRAS.
;WITH PROD_AX AS (SELECT B2_FILIAL AS FILIAL, B2_COD     AS PROD, B2_LOCAL AS AX FROM SB2010 WHERE D_E_L_E_T_ = '' AND B2_FILIAL BETWEEN @FILINI AND @FILFIM AND B2_COD     BETWEEN @PRODINI AND @PRODFIM AND B2_LOCAL BETWEEN @ALMOXINI AND @ALMOXFIM
            UNION SELECT B8_FILIAL AS FILIAL, B8_PRODUTO AS PROD, B8_LOCAL AS AX FROM SB8010 WHERE D_E_L_E_T_ = '' AND B8_FILIAL BETWEEN @FILINI AND @FILFIM AND B8_PRODUTO BETWEEN @PRODINI AND @PRODFIM AND B8_LOCAL BETWEEN @ALMOXINI AND @ALMOXFIM
            UNION SELECT BF_FILIAL AS FILIAL, BF_PRODUTO AS PROD, BF_LOCAL AS AX FROM SBF010 WHERE D_E_L_E_T_ = '' AND BF_FILIAL BETWEEN @FILINI AND @FILFIM AND BF_PRODUTO BETWEEN @PRODINI AND @PRODFIM AND BF_LOCAL BETWEEN @ALMOXINI AND @ALMOXFIM
)
, SALDOS AS (
SELECT B1_COD, B1_DESC, B1_RASTRO, B1_LOCALIZ, FILIAL, AX, B1_UM
	   ,ISNULL((SELECT
				SUM (CAST (B2_QATU AS DECIMAL (14, 4)))  -- Atualmente (05/09/2023) usamos 4 decimais em todos os campos de quantidade.
			FROM SB2010 SB2
			WHERE SB2.D_E_L_E_T_ = ''
			AND SB2.B2_FILIAL = PROD_AX.FILIAL
			AND SB2.B2_COD = PROD_AX.PROD
			AND SB2.B2_LOCAL = PROD_AX.AX)
		, 0) AS SALDO_SB2
	   ,ISNULL((SELECT
				SUM (CAST (B2_QACLASS AS DECIMAL (14, 4)))  -- Atualmente (05/09/2023) usamos 4 decimais em todos os campos de quantidade.
			FROM SB2010 SB2
			WHERE SB2.D_E_L_E_T_ = ''
			AND SB2.B2_FILIAL = PROD_AX.FILIAL
			AND SB2.B2_COD = PROD_AX.PROD
			AND SB2.B2_LOCAL = PROD_AX.AX)
		, 0) AS SALDO_A_ENDERECAR
	   ,ISNULL((SELECT
				SUM (CAST (BF_QUANT AS DECIMAL (14, 4)))  -- Atualmente (05/09/2023) usamos 4 decimais em todos os campos de quantidade.
			FROM SBF010 SBF
			WHERE SBF.D_E_L_E_T_ = ''
			AND SBF.BF_FILIAL = PROD_AX.FILIAL
			AND SBF.BF_PRODUTO = PROD_AX.PROD
			AND SBF.BF_LOCAL = PROD_AX.AX)
		, 0) AS SALDO_SBF
	   ,ISNULL((SELECT
				SUM (CAST (B8_SALDO AS DECIMAL (14, 4)))  -- Atualmente (05/09/2023) usamos 4 decimais em todos os campos de quantidade.
			FROM SB8010 SB8
			WHERE SB8.D_E_L_E_T_ = ''
			AND SB8.B8_FILIAL = PROD_AX.FILIAL
			AND SB8.B8_PRODUTO = PROD_AX.PROD
			AND SB8.B8_LOCAL = PROD_AX.AX)
		, 0) AS SALDO_SB8
	FROM PROD_AX, SB1010 SB1
	WHERE SB1.D_E_L_E_T_ = ''
	AND SB1.B1_FILIAL = '  '
	AND SB1.B1_COD = PROD_AX.PROD
)
, PROBLEMAS AS (
SELECT *
/*
   ,RTRIM (CASE WHEN B1_RASTRO = 'L' AND SALDO_SB2 != SALDO_SB8 THEN 'SLD.AX (' + FORMAT (SALDO_SB2, 'G') + ' ' + B1_UM + ') DIFERE DO SLD.LOTES (' + FORMAT (SALDO_SB8, 'G') + ' ' + B1_UM + '); ' ELSE ' ' END
   +CASE WHEN B1_LOCALIZ = 'S' AND (SALDO_SB2 - SALDO_A_ENDERECAR) != SALDO_SBF THEN 'SLD.AX-A ENDER. (' + FORMAT (SALDO_SB2 - SALDO_A_ENDERECAR, 'G') + ' ' + B1_UM + ') DIFERE DO SLD.ENDERECOS (' + FORMAT (SALDO_SBF, 'G') + ' ' + B1_UM + '); ' ELSE ' ' END
   +CASE WHEN B1_RASTRO != 'L' AND SALDO_SB8 != 0 THEN 'NAO CONTROLA LOTES, MAS TEM LOTES COM SALDO (' + CAST (SALDO_SB8 AS VARCHAR (18)) + ' ' + B1_UM + '); ' ELSE ' ' END
   +CASE WHEN B1_LOCALIZ != 'S' AND SALDO_SBF != 0 THEN 'NAO CONTROLA ENDERECAMENTO, MAS TEM ENDERECOS COM SALDO (' + FORMAT (SALDO_SBF, 'G') + ' ' + B1_UM + ') ' ELSE ' ' END
*/
	,RTRIM (CASE WHEN B1_RASTRO = 'L' AND SALDO_SB2 != SALDO_SB8
		THEN 'SLD.AX (' + FORMAT (SALDO_SB2, 'G') + ' ' + B1_UM + ') DIFERE DO SLD.LOTES (' + FORMAT (SALDO_SB8, 'G') + ' ' + B1_UM + '); '
		ELSE ' '
		END
   +CASE WHEN B1_LOCALIZ = 'S' AND (SALDO_SB2 - SALDO_A_ENDERECAR) != SALDO_SBF
		THEN 'SLD.ATUAL - ENDERECAR(' + FORMAT (SALDO_SB2 - SALDO_A_ENDERECAR, 'G') + ' ' + B1_UM + ')'
			+ ' DIF.SLD.ENDERECOS(' + FORMAT (SALDO_SBF, 'G') + ' ' + B1_UM + '); '
		ELSE ' '
		END
   +CASE WHEN B1_RASTRO != 'L' AND SALDO_SB8 != 0
		THEN 'NAO CONTROLA LOTES, MAS TEM LOTES COM SALDO (' + CAST (SALDO_SB8 AS VARCHAR (18)) + ' ' + B1_UM + '); '
		ELSE ' '
		END
   +CASE WHEN B1_LOCALIZ != 'S' AND SALDO_SBF != 0
		THEN 'NAO CONTROLA ENDERECAMENTO, MAS TEM ENDERECOS COM SALDO (' + FORMAT (SALDO_SBF, 'G') + ' ' + B1_UM + ') '
		ELSE ' '
		END
)
   AS PROBLEMAS
   FROM SALDOS
)
SELECT *
FROM PROBLEMAS
WHERE PROBLEMAS != ''
ORDER BY B1_COD

END

