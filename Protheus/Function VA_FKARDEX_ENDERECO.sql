
-- Descricao: Retorna tabela com movimentacao de produto x lote (kardex).
-- Autor....: Robert Koch
-- Data.....: 18/05/2018
--
-- Historico de alteracoes:
--

ALTER FUNCTION [dbo].[VA_FKARDEX_ENDERECO]
-- PARAMETROS DE CHAMADA
(
	@FILIAL   AS VARCHAR(2),
	@PRODUTO  AS VARCHAR(15),
	@LOTE     AS VARCHAR(10),
	@ENDERECO AS VARCHAR(15),
	@DATAINI  AS VARCHAR(8),
	@DATAFIM  AS VARCHAR(8)
)
RETURNS TABLE
AS

	RETURN 

	WITH C AS (
	              -- SALDOS INICIAIS
	              SELECT '1' AS TIPO_REG,
	                     dbo.VA_FSALDOENDERECO(@FILIAL, @PRODUTO, @LOTE, @ENDERECO, @DATAINI -1) AS 
                         QT_ENTRADA,
	                     0 AS QT_SAIDA,
	                     '' AS DATA,
	                     '' AS DOC,
	                     '' AS SERIE,
	                     '' AS NUMSEQ,
	                     'SALDO INICIAL' AS MOVIMENTO,
	                     '' AS CLIFOR,
	                     '' AS LOJA,
	                     '' AS NOME,
	                     '' AS OP,
	                     '' AS TES,
	                     '' AS CFOP,
						 '' AS ALMOX,
						 '' AS ENDERECO,
	                     '' AS ETIQUETA,
	                     '' AS USUARIO,
	                     '' AS MOTIVO,
	                     '' AS NF_ORIG,
	                     '' AS DATA_INCLUSAO,
	                     '' AS HORA_INCLUSAO,
						 '' AS SEQUENCIA

	              UNION ALL
	              
	              SELECT '2' AS TIPO_REG,
	                     CASE WHEN DB_TM <= '499' THEN DB_QUANT ELSE 0 END AS QT_ENTRADA,
	                     CASE WHEN DB_TM >  '499' THEN DB_QUANT ELSE 0 END AS QT_SAIDA,
	                     DB_DATA AS DATA,
	                     DB_DOC AS DOC,
	                     DB_SERIE AS SERIE,
	                     DB_NUMSEQ AS NUMSEQ,
	                     CASE WHEN DB_ORIGEM = 'SC2' AND SD3.D3_TM > '499' THEN 'CONSUMO EM OP'
							ELSE
								CASE WHEN DB_ORIGEM = 'SD1' THEN 'ENTRADA NF'
								ELSE 
									CASE WHEN DB_ORIGEM = 'SD3' AND SDB.DB_TM <= '499' AND ISNULL (SD3.D3_CF, '') LIKE 'PR%' THEN 'PRODUCAO'
									ELSE 'ORIG:' + DB_ORIGEM 
									END 
								END 
							END AS MOVIMENTO,
	                     DB_CLIFOR AS CLIFOR,
	                     DB_LOJA AS LOJA,
	                     '' AS NOME,
	                     ISNULL (SD3.D3_OP, '') AS OP,
	                     SDB.DB_TM AS TES,
	                     '' AS CFOP,
						 DB_LOCAL AS ALMOX,
						 DB_LOCALIZ AS ENDERECO,
	                     ISNULL (SD3.D3_VAETIQ, '') AS ETIQUETA,
	                     DB_VAUSER AS USUARIO,
	                     ISNULL (D3_VAMOTIV, '') AS MOTIVO,
	                     '' AS NF_ORIG,
	                     ISNULL (SD3.D3_VADTINC, '') AS DATA_INCLUSAO,
	                     ISNULL (SD3.D3_VAHRINC, '') AS HORA_INCLUSAO,
						 CAST (SDB.R_E_C_N_O_ AS CHAR) AS SEQUENCIA
				    FROM SDB010 SDB
					     LEFT JOIN SD3010 SD3
						 ON (SD3.D_E_L_E_T_ = ''
						 AND SD3.D3_FILIAL = SDB.DB_FILIAL
						 AND SD3.D3_COD = SDB.DB_PRODUTO
						 AND SD3.D3_NUMSEQ = SDB.DB_NUMSEQ
						 AND SD3.D3_ESTORNO != 'S'
						 AND SD3.D3_TM = SDB.DB_TM
						 AND SD3.D3_LOTECTL = SDB.DB_LOTECTL
						 AND SD3.D3_LOCALIZ = SDB.DB_LOCALIZ)
				   WHERE SDB.D_E_L_E_T_ = ''
				     AND SDB.DB_FILIAL = @FILIAL
					 AND SDB.DB_PRODUTO = @PRODUTO
					 AND SDB.DB_LOTECTL = @LOTE
					 AND SDB.DB_LOCALIZ = @ENDERECO
					 AND SDB.DB_DATA BETWEEN @DATAINI AND @DATAFIM
					 AND SDB.DB_ESTORNO != 'S'
	          )
SELECT TOP 100 PERCENT 
       ROW_NUMBER() OVER(ORDER BY C.TIPO_REG, C.DATA, C.NUMSEQ, C.DOC, C.SEQUENCIA) AS LINHA,
	   C.SEQUENCIA,
       dbo.VA_DTOC (C.DATA) AS DATA,
       C.DOC,
       C.SERIE,
       C.QT_ENTRADA,
       C.QT_SAIDA,
       SUM(C2.QT_ENTRADA - C2.QT_SAIDA) AS SALDO,
       C.NUMSEQ,
       C.MOVIMENTO,
       C.OP,
       C.TES,
       C.CFOP,
	   C.ALMOX,
	   C.ENDERECO,
       C.ETIQUETA,
       C.USUARIO,
       C.CLIFOR,
       C.LOJA,
       C.NOME,
       C.MOTIVO,
       C.NF_ORIG,
       dbo.VA_DTOC (C.DATA_INCLUSAO) AS DATA_INCLUSAO,
       C.HORA_INCLUSAO
FROM   C
       -- FAZ UM JOIN COM A PROPRIA TABELA PARA COMPOR O SALDO
       LEFT JOIN C AS C2
            ON  (
					C2.TIPO_REG + C2.DATA + C2.NUMSEQ + C2.DOC + C2.SEQUENCIA <= C.TIPO_REG + C.DATA + C.NUMSEQ + C.DOC + C.SEQUENCIA
                )
GROUP BY
       C.TIPO_REG,
       C.DATA,
       C.DOC,
       C.SERIE,
       C.QT_ENTRADA,
       C.QT_SAIDA,
       C.NUMSEQ,
       C.MOVIMENTO,
       C.CLIFOR,
       C.LOJA,
       C.NOME,
       C.OP,
       C.TES,
       C.CFOP,
	   C.ALMOX,
	   C.ENDERECO,
       C.ETIQUETA,
       C.USUARIO,
       C.MOTIVO,
       C.NF_ORIG,
       C.DATA_INCLUSAO,
       C.HORA_INCLUSAO,
	   C.SEQUENCIA
ORDER BY
       C.TIPO_REG,
       C.DATA,
       C.NUMSEQ,
	   C.DOC


