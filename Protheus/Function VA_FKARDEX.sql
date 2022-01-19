SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- Descricao: Retorna tabela com movimentacao de produto (kardex).
--            Criado para der mais detalhado que o kardex padrao do Protheus.
-- Autor....: Robert Koch
-- Data.....: 15/01/2015
--
-- Historico de alteracoes:
-- 26/01/2015 - Robert - Incluida coluna SERIE das notas.
-- 02/02/2015 - Robert - Incluida coluna de data de contabilizacao.
--                     - Busca nome contato loja quando existir no D3_VACTZZ7.
-- 20/02/2015 - Robert - Passa a considerar campo D3_VAPEROP.
-- 14/04/2015 - Robert - Passa a considerar apenas RE4/DE4 na clausula NOT EXISTS que filtra transferencias de enderecos.
-- 07/05/2015 - Robert - Coluna data de contabilizacao removida.
--                     - Criadas colunas de data e hora de inclusao do movimento.
-- 22/08/2016 - Robert - Coluna inicial usada para ordenacao renomeada de 'ROW_NUMBER' para 'LINHA' pois ocasionava conflito com a funcao ROW_NUMBER do SQL quando usada posteriormente em outras queries.
-- 08/09/2016 - Robert - Passa a usar a coluna D2_ITEM junto com D2_NUMSEQ para identificar registros unicos.
-- 26/04/2017 - Robert - Incluida coluna com o lote.
-- 25/07/2017 - Robert - Alteracao ordenacao final de C.TIPO_REG, C.DATA, C.DOC, C.NUMSEQ para C.TIPO_REG, C.DATA, C.NUMSEQ, C.DOC
-- 17/05/2018 - Robert - Incluida coluna SEQUENCIA (para casos de mais de um movimento com mesmo NUMSEQ, por exemplo req. de diferentes lotes na mesma OP)
-- 04/12/2020 - Robert - Nao diferenciava se era produto origem ou destino no texto "transformado em..." no historico da movimentacao, quando D3_CF era RE4 ou DE4.
-- 18/08/2021 - Robert - Ajustado para mostrar DEVOL quando movimento DE% com D3_OP nao vazio (casos bastante raros) - GLPI 10753.
--

ALTER FUNCTION [dbo].[VA_FKARDEX]
-- PARAMETROS DE CHAMADA
(
	@FILIAL   AS VARCHAR(2),
	@PRODUTO  AS VARCHAR(15),
	@ALMOX    AS VARCHAR(2),
	@DATAINI  AS VARCHAR(8),
	@DATAFIM  AS VARCHAR(8)
)
RETURNS TABLE
AS


	RETURN 

	WITH C AS (
	              -- SALDOS INICIAIS
	              SELECT '1' AS TIPO_REG,
	                     dbo.VA_SALDOESTQ(@FILIAL, @PRODUTO, @ALMOX, @DATAINI -1) AS 
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
						 '' AS LOTE,
	                     '' AS ETIQUETA,
	                     '' AS USUARIO,
	                     '' AS MOTIVO,
	                     '' AS NF_ORIG,
	                     '' AS DATA_INCLUSAO,
	                     '' AS HORA_INCLUSAO,
	                     --'' AS ID_DEVOLUCAO,
						 '' AS SEQUENCIA
	              
	              UNION ALL
	              
	              -- NOTAS DE ENTRADA
	              SELECT '2' AS TIPO_REG,
	                     D1_QUANT AS QT_ENTRADA,
	                     0 AS QT_SAIDA,
	                     D1_DTDIGIT,
	                     D1_DOC,
	                     D1_SERIE,
	                     D1_NUMSEQ,
	                     'NF ' + CASE D1_TIPO
	                                  WHEN 'N' THEN 'ENTRADA'
	                                  WHEN 'D' THEN 'DEVOL'
	                                  WHEN 'B' THEN 'BENEF'
	                                  WHEN 'C' THEN 'COMPL/FRT'
	                                  WHEN 'P' THEN 'IPI'
	                                  WHEN 'I' THEN 'ICMS'
	                             END + CASE SF4.F4_PODER3
	                                        WHEN 'R' THEN ' (REMESSA 3os)'
	                                        WHEN 'D' THEN ' (DEVOL.3os)'
	                                        ELSE ''
	                                   END AS HIST,
	                     D1_FORNECE,
	                     D1_LOJA,
	                     CASE 
	                          WHEN D1_TIPO IN ('B', 'D') THEN A1_NOME
	                          ELSE A2_NOME
	                     END AS NOME,
	                     D1_OP AS OP,
	                     D1_TES,
	                     D1_CF,
						 D1_LOTECTL,
	                     '' AS ETIQUETA,
	                     F1_VAUSER AS USUARIO,
	                     CASE 
	                          WHEN SD1.D1_TIPO = 'D' THEN ISNULL(
	                                   (
	                                       SELECT 'Mot.Dev:' + RTRIM(ZX5.ZX5_02DESC)
	                                       FROM   ZX5010 ZX5
	                                       WHERE  ZX5.D_E_L_E_T_ = ''
	                                              AND ZX5.ZX5_FILIAL = '  '
	                                              AND ZX5.ZX5_TABELA = '02'
	                                              AND ZX5.ZX5_02MOT = SD1.D1_MOTDEV
	                                   ),
	                                   ''
	                               )
	                          ELSE ''
	                     END +
	                     CASE SD1.D1_OBS
	                          WHEN '' THEN ''
	                          ELSE 'Obs.NF:' + RTRIM(D1_OBS)
	                     END AS MOTIVO,
	                     D1_NFORI AS NF_ORIG,
	                     F1_VADTINC AS DATA_INCLUSAO,
	                     F1_VAHRINC AS HORA_INCLUSAO,
	                     --SD1.D1_IDZAB AS ID_DEVOLUCAO,
						 SD1.D1_ITEM AS SEQUENCIA
	              FROM   SF4010 SF4,
	                     SF1010 SF1,
	                     SD1010 SD1
	                     LEFT JOIN SA1010 SA1
	                          ON  (
	                                  SA1.D_E_L_E_T_ = ''
	                                  AND SA1.A1_FILIAL = '  '
	                                  AND SA1.A1_COD = D1_FORNECE
	                                  AND SA1.A1_LOJA = D1_LOJA
	                              )
	                     LEFT JOIN SA2010 SA2
	                          ON  (
	                                  SA2.D_E_L_E_T_ = ''
	                                  AND SA2.A2_FILIAL = '  '
	                                  AND SA2.A2_COD = D1_FORNECE
	                                  AND SA2.A2_LOJA = D1_LOJA
	                              )
	              WHERE  SD1.D_E_L_E_T_ != '*'
	                     AND SD1.D1_FILIAL = @FILIAL
	                     AND SD1.D1_DTDIGIT BETWEEN @DATAINI AND @DATAFIM
	                     AND SD1.D1_COD = @PRODUTO
	                     AND SD1.D1_LOCAL = @ALMOX
	                     AND SD1.D1_QUANT != 0 -- PARA NAO TRAZER NF DE COMPLEMENTO DE PRECO, POR EXEMPLO
	                     AND SF4.D_E_L_E_T_ != '*'
	                     AND SF4.F4_FILIAL = '  '
	                     AND SF4.F4_CODIGO = SD1.D1_TES
	                     AND SF4.F4_ESTOQUE = 'S'
	                     AND SF1.D_E_L_E_T_ != '*'
	                     AND SF1.F1_FILIAL = SD1.D1_FILIAL
	                     AND SF1.F1_DOC = SD1.D1_DOC
	                     AND SF1.F1_SERIE = SD1.D1_SERIE
	                     AND SF1.F1_FORNECE = SD1.D1_FORNECE
	                     AND SF1.F1_LOJA = SD1.D1_LOJA
	              
	              UNION ALL
	              
	              --MOVIMENTOS INTERNOS
	              SELECT '2' AS TIPO_REG,
	                     CASE 
	                          WHEN SD3.D3_TM < '5' THEN SD3.D3_QUANT
	                          ELSE 0
	                     END AS QT_ENTRADA,
	                     CASE 
	                          WHEN SD3.D3_TM >= '5' THEN SD3.D3_QUANT
	                          ELSE 0
	                     END AS QT_SAIDA,
	                     SD3.D3_EMISSAO,
	                     SD3.D3_DOC,
	                     '' AS SERIE,
	                     SD3.D3_NUMSEQ,
	                     /*
	                     0   manual (apropriação pelo real)
	                     1   automática (apropriação pelo real)
	                     2   automática de materiais com apropriação pelo standard (processo OP)
	                     3   manual de materiais com apropriação pelo standard (armazém processo)
	                     4   transferência
	                     5   automática na NF de entrada direto para OP
	                     6   manual de materiais (valorizada)
	                     7   desmontagens
	                     8   integração Módulo de Exportação.
	                     */
	                     CASE 
	                          WHEN SD3.D3_CF LIKE 'PR%' THEN 'PRODUCAO'
	                          WHEN SUBSTRING(SD3.D3_CF, 3, 1) = '7' THEN 
	                               'DESMONTAGEM'
	                          WHEN SUBSTRING(SD3.D3_CF, 3, 1) = '4'
	              AND CONTRAPARTIDA.D3_COD != SD3.D3_COD THEN 'TRANSFORMADO ' + CASE WHEN SD3.D3_CF LIKE 'RE%' THEN 'EM ' ELSE 'DE ' END
	                  + RTRIM(CONTRAPARTIDA.D3_COD) + ' NO ALM.' + CONTRAPARTIDA.D3_LOCAL

	                  WHEN SUBSTRING(SD3.D3_CF, 3, 1) = '4'
	              AND CONTRAPARTIDA.D3_COD = SD3.D3_COD THEN 'TRANSF.' + CASE 
	                                                                          SUBSTRING(SD3.D3_CF, 1, 2)
	                                                                          WHEN 
	                                                                               'RE' THEN 
	                                                                               'PARA'
	                                                                          ELSE 
	                                                                               'DO'
	                                                                     END +
	                  ' ALM.' + CONTRAPARTIDA.D3_LOCAL

	                  WHEN SUBSTRING(SD3.D3_CF, 1, 2) IN ('RE', 'DE') AND SD3.D3_OP != ''
					  THEN CASE WHEN SUBSTRING(SD3.D3_CF, 1, 2) = 'RE' THEN 'CONSUMO ' ELSE 'DEVOL.' END + CASE WHEN SUBSTRING(SD3.D3_CF, 3, 1) = '0'
						THEN 
	                                'MANUAL'
	                            ELSE 'AUTOMATICO'
	                    END + ' OP' + CASE SD3.D3_VAPEROP
	                                        WHEN 
	                                            'S' THEN 
	                                            ' (PERDA)'
	                                        ELSE 
	                                            ''
	                                    END + CASE 
	                                                SUBSTRING(SD3.D3_CF, 3, 1)
	                                                WHEN 
	                                                    '5' THEN 
	                                                    ' (NF ENTRADA DIRETO PARA OP)'
	                                                ELSE 
	                                                    ''
	                                        END
	                  
					  WHEN SUBSTRING(SD3.D3_CF, 1, 2) IN ('RE', 'DE') AND SD3.D3_TM IN ('499', '999')
					  THEN 'INTERNO'
	                  
					  WHEN SUBSTRING(SD3.D3_CF, 1, 2) IN ('RE', 'DE') AND SD3.D3_OP = ''
					  THEN RTRIM(SF5.F5_TEXTO)
	                  ELSE ''
	                  END 
	                  + CASE 
	                         WHEN SD3.D3_VANFRD != '' THEN ' (ref.NF ' + SD3.D3_VANFRD 
	                              + ')'
	                         ELSE ''
	                    END
	                  AS MOVIMENTO,
	              '' AS CLIFOR,
	              '' AS LOJA,
	              ISNULL(
	                  CASE SD3.D3_VACTZZ7
	                       WHEN '' THEN ''
	                       ELSE (
	                                SELECT 'Contato loja: ' + SD3.D3_VACTZZ7 + 
	                                       ' (' + RTRIM(SU5.U5_CONTAT) + ')'
	                                FROM   SU5010 SU5
	                                WHERE  SU5.D_E_L_E_T_ = ''
	                                       AND SU5.U5_FILIAL = '  '
	                                       AND SU5.U5_CODCONT = SD3.D3_VACTZZ7
	                            )
	                  END,
	                  ''
	              ) AS NOME,
	              SD3.D3_OP,
	              SD3.D3_TM,
	              SD3.D3_CF,
				  SD3.D3_LOTECTL,
	              SD3.D3_VAETIQ,
	              SD3.D3_USUARIO AS USUARIO,
	              SD3.D3_VAMOTIV AS MOTIVO,
	              '' AS NF_ORIG,
	              SD3.D3_VADTINC AS DATA_INCLUSAO,
	              SD3.D3_VAHRINC AS HORA_INCLUSAO,
	              --'' AS ID_DEVOLUCAO,
				  SD3.D3_TRT + SD3.D3_MSIDENT AS SEQUENCIA
	              FROM SD3010 SD3
	              LEFT JOIN SD3010 CONTRAPARTIDA -- ORIGEM/DESTINO, QUANDO FOR TRANSFERENCIA
	              ON (
	                  CONTRAPARTIDA.D_E_L_E_T_ != '*'
	                  AND CONTRAPARTIDA.D3_FILIAL = SD3.D3_FILIAL
	                  AND CONTRAPARTIDA.D3_ESTORNO != 'S'
	                  AND CONTRAPARTIDA.D3_NUMSEQ = SD3.D3_NUMSEQ
	                  AND SUBSTRING(CONTRAPARTIDA.D3_CF, 3, 1) = '4'
	                  AND CONTRAPARTIDA.R_E_C_N_O_ != SD3.R_E_C_N_O_
	              )
	              LEFT JOIN SF5010 SF5 ON (
	                  SF5.D_E_L_E_T_ = ''
	                  AND SF5.F5_FILIAL = '  '
	                  AND SF5.F5_CODIGO = SD3.D3_TM
	              )
	              WHERE SD3.D_E_L_E_T_ != '*'
	              AND SD3.D3_FILIAL = @FILIAL
	              AND SD3.D3_ESTORNO != 'S'
	              AND SD3.D3_EMISSAO BETWEEN @DATAINI AND @DATAFIM
	              AND SD3.D3_COD = @PRODUTO
	              AND SD3.D3_LOCAL = @ALMOX
	                  -- DESCARTA TRANSFERENCIAS DE ENDERECOS
	              AND NOT EXISTS (
	                      SELECT *
	                      FROM   SD3010 B
	                      WHERE  B.D_E_L_E_T_ != '*'
	                             AND B.D3_FILIAL = SD3.D3_FILIAL
	                             AND B.D3_ESTORNO != 'S'
	                             AND B.D3_COD = SD3.D3_COD
	                             AND B.D3_LOCAL = SD3.D3_LOCAL
	                             AND B.D3_NUMSEQ = SD3.D3_NUMSEQ
	                             AND B.D3_CF IN ('RE4', 'DE4')
	                             AND B.R_E_C_N_O_ != SD3.R_E_C_N_O_
	                  )
	                  
	                  UNION ALL
	                  
	                  -- NOTAS DE SAIDA
	                  SELECT '2' AS TIPO_REG,
	                         0 AS QT_ENTRADA,
	                         D2_QUANT AS QT_SAIDA,
	                         D2_EMISSAO,
	                         D2_DOC,
	                         D2_SERIE,
	                         D2_NUMSEQ + SD2.D2_ITEM,  -- PEGUEI CASOS DE 2 ITENS NA NOTA COM MESMO NUMSEQ (CUPOM 022012 FILIAL 13)
	                         CASE 
	                              WHEN SD2.D2_SERIE LIKE 'CL%' THEN 
	                                   'CUPOM FISCAL'
	                              ELSE 'NF ' + CASE D2_TIPO
	                                                WHEN 'N' THEN 'SAIDA'
	                                                WHEN 'D' THEN 'DEVOL'
	                                                WHEN 'B' THEN 'BENEF'
	                                                WHEN 'C' THEN 'COMPL'
	                                                WHEN 'P' THEN 'IPI'
	                                                WHEN 'I' THEN 'ICMS'
	                                           END
	                         END + CASE SF4.F4_PODER3
	                                    WHEN 'R' THEN ' (REMESSA 3os)'
	                                    WHEN 'D' THEN ' (DEVOL.3os)'
	                                    ELSE ''
	                               END AS MOVIMENTO,
	                         D2_CLIENTE,
	                         D2_LOJA,
	                         CASE 
	                              WHEN D2_TIPO IN ('B', 'D') THEN A2_NOME
	                              ELSE A1_NOME
	                         END AS NOME,
	                         '' AS OP,
	                         D2_TES,
	                         SD2.D2_CF,
							 SD2.D2_LOTECTL,
	                         '' AS ETIQUETA,
	                         SF2.F2_VAUSER AS USUARIO,
	                         '' AS MOTIVO,
	                         D2_NFORI AS NF_ORIG,
	                         F2_EMISSAO AS DATA_INCLUSAO,
	                         F2_HORA AS HORA_INCLUSAO,
	                         --'' AS ID_DEVOLUCAO,
							 SD2.D2_ITEM AS SEQUENCIA
	                  FROM   SF4010 SF4,
	                         SF2010 SF2,
	                         SD2010 SD2
	                         LEFT JOIN SA1010 SA1
	                              ON  (
	                                      SA1.D_E_L_E_T_ = ''
	                                      AND SA1.A1_FILIAL = '  '
	                                      AND SA1.A1_COD = D2_CLIENTE
	                                      AND SA1.A1_LOJA = D2_LOJA
	                                  )
	                         LEFT JOIN SA2010 SA2
	                              ON  (
	                                      SA2.D_E_L_E_T_ = ''
	                                      AND SA2.A2_FILIAL = '  '
	                                      AND SA2.A2_COD = D2_CLIENTE
	                                      AND SA2.A2_LOJA = D2_LOJA
	                                  )
	                  WHERE  SD2.D_E_L_E_T_ != '*'
	                         AND SD2.D2_FILIAL = @FILIAL
	                         AND SD2.D2_EMISSAO BETWEEN @DATAINI AND @DATAFIM
	                         AND SD2.D2_COD = @PRODUTO
	                         AND SD2.D2_LOCAL = @ALMOX
	                         AND SF4.D_E_L_E_T_ != '*'
	                         AND SF4.F4_FILIAL = '  '
	                         AND SF4.F4_CODIGO = SD2.D2_TES
	                         AND SF4.F4_ESTOQUE = 'S'
	                         AND SF2.D_E_L_E_T_ != '*'
	                         AND SF2.F2_FILIAL = SD2.D2_FILIAL
	                         AND SF2.F2_DOC = SD2.D2_DOC
	                         AND SF2.F2_SERIE = SD2.D2_SERIE
	          )
SELECT TOP 100 PERCENT 
       ROW_NUMBER() OVER(ORDER BY C.TIPO_REG, C.DATA, C.NUMSEQ, C.DOC, C.SEQUENCIA) AS LINHA,
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
	   C.LOTE,
       C.ETIQUETA,
       C.USUARIO,
       C.CLIFOR,
       C.LOJA,
       C.NOME,
       C.MOTIVO,
       C.NF_ORIG,
       dbo.VA_DTOC (C.DATA_INCLUSAO) AS DATA_INCLUSAO,
       C.HORA_INCLUSAO,
       --C.ID_DEVOLUCAO,
	   C.SEQUENCIA
FROM   C
       -- FAZ UM JOIN COM A PROPRIA TABELA PARA COMPOR O SALDO
       LEFT JOIN C AS C2
            ON  (
--					C2.TIPO_REG + C2.DATA + C2.NUMSEQ + C2.DOC <= C.TIPO_REG + C.DATA + C.NUMSEQ + C.DOC
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
	   C.LOTE,
       C.ETIQUETA,
       C.USUARIO,
       C.MOTIVO,
       C.NF_ORIG,
       C.DATA_INCLUSAO,
       C.HORA_INCLUSAO,
       --C.ID_DEVOLUCAO,
	   C.SEQUENCIA
ORDER BY
       C.TIPO_REG,
       C.DATA,
       C.NUMSEQ,
	   C.DOC
GO
