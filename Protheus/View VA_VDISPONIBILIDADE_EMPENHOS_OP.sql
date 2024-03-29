
ALTER VIEW [dbo].[VA_VDISPONIBILIDADE_EMPENHOS_OP]
-- Descricao: Retorna tabela com disponibilidade de estoque de componentes empenhados em OP.
-- Autor....: Robert Koch
-- Data.....: 01/04/2015
--
-- Historico de alteracoes:
-- 22/08/2016 - Robert - Coluna inicial usada para ordenacao renomeada de 'ROW_NUMBER' para 'LINHA' pois ocasionava confrito com a funcao ROW_NUMBER do SQL quando usada posteriormente em outras queries.
--

AS 

WITH C AS (
              SELECT SD4.D4_FILIAL AS FILIAL, SD4.D4_COD AS COMPONENTE,
                     RTRIM(SB1_COMP.B1_DESC) AS DESCRI_COMPON,
                     SD4.D4_OP AS OP, SC2.C2_PRODUTO AS PROD_FINAL,
                     RTRIM(SB1_PROD.B1_DESC) AS DESCRI_PRODUTO,
                     D4_DATA AS DATA_EMPENHO,
                     SD4.D4_LOCAL AS ALMOX,
                     SUM(SD4.D4_QUANT) AS EMPENHO,	-- Usa SUM por que pode ter mais que uma sequencia.
                     ISNULL(SB2.B2_QATU, 0) AS DISPONIVEL,
                     CASE WHEN SC2.C2_QUJE > 0 THEN '0' ELSE '1' END + SC2.C2_PRIOR AS PRIORIDADE_OP,
                     SC2.C2_DATPRI AS PREV_INICIO_OP
              FROM   SC2010 SC2,
                     SB1010 SB1_PROD,
                     SB1010 SB1_COMP,
                     SD4010 SD4
                     LEFT JOIN SB2010 SB2
                          ON  (
                                  SB2.D_E_L_E_T_ = ''
                                  AND SB2.B2_FILIAL = SD4.D4_FILIAL
                                  AND SB2.B2_COD = SD4.D4_COD
                                  AND SB2.B2_LOCAL = SD4.D4_LOCAL
                              )
              WHERE  SC2.D_E_L_E_T_ = ''
                     AND SC2.C2_FILIAL = SD4.D4_FILIAL
                     AND SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN + SC2.C2_ITEMGRD = 
                         SD4.D4_OP
                     AND SC2.C2_TPOP = 'F'
                     AND SC2.C2_DATRF = ''
                     AND SB1_PROD.D_E_L_E_T_ = ''
                     AND SB1_PROD.B1_FILIAL = '  '
                     AND SB1_PROD.B1_COD = SC2.C2_PRODUTO
                     AND SD4.D_E_L_E_T_ = ''
                     AND D4_QUANT > 0
                     AND SB1_COMP.D_E_L_E_T_ = ''
                     AND SB1_COMP.B1_FILIAL = '  '
                     AND SB1_COMP.B1_COD = SD4.D4_COD
              GROUP BY
                     SD4.D4_FILIAL, SD4.D4_COD,
                     SB1_COMP.B1_DESC,
                     SD4.D4_OP, SC2.C2_PRODUTO,
                     SB1_PROD.B1_DESC,
                     SD4.D4_DATA,
                     SD4.D4_LOCAL,
                     SB2.B2_QATU,
                     SC2.C2_PRIOR,
                     SC2.C2_DATPRI, SC2.C2_QUJE
          )

SELECT TOP 100 PERCENT 
       ROW_NUMBER() OVER(
           ORDER BY C.FILIAL, C.COMPONENTE,
           C.ALMOX, C.PRIORIDADE_OP,
           C.DATA_EMPENHO,
           C.PREV_INICIO_OP,
           C.OP
       ) AS LINHA, -- ROW_NUMBER,
       C.FILIAL, C.COMPONENTE,
       C.DESCRI_COMPON,
       C.OP,
       C.PRIORIDADE_OP,
       C.PROD_FINAL,
       C.DESCRI_PRODUTO,
       dbo.VA_DTOC (C.DATA_EMPENHO) AS DATA_EMPENHO,
       C.ALMOX,
       C.EMPENHO,
       C.EMPENHO + SUM (ISNULL (C2.EMPENHO, 0))
   AS NECESSIDADE_ACUMULADA,
       C.DISPONIVEL
FROM   C
       -- FAZ UM JOIN COM A PROPRIA TABELA PARA COMPOR O SALDO
       LEFT JOIN C AS C2
            ON  (
                    C2.COMPONENTE = C.COMPONENTE AND C2.ALMOX = C.ALMOX AND C2.PRIORIDADE_OP + C2.DATA_EMPENHO + C2.PREV_INICIO_OP + 
                    C2.OP < C.PRIORIDADE_OP + C.DATA_EMPENHO + C.PREV_INICIO_OP + C.OP
            )
GROUP BY
       C.FILIAL, C.COMPONENTE,
       C.DESCRI_COMPON,
       C.OP, C.PROD_FINAL,
       C.DESCRI_PRODUTO,
       C.DATA_EMPENHO, C.PRIORIDADE_OP, C.PREV_INICIO_OP,
       C.ALMOX,
       C.EMPENHO,
       C.DISPONIVEL
/*
ORDER BY
       C.FILIAL, C.COMPONENTE,
       C.ALMOX, C.PRIORIDADE_OP,
       C.DATA_EMPENHO, 
       C.PREV_INICIO_OP,
       C.OP
       */


