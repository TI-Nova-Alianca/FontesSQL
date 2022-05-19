SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VA_VPRECO_EFETIVO_SAFRA]
AS

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar precos efetivos de compra de safras (compra + Vementos).
-- Autor: Robert Koch
-- Data:  24/05/2013
--
-- Historico de alteracoes:
-- 17/09/2015 - Robert - View VA_NOTAS_SAFRA renomeada para VA_VNOTAS_SAFRA
-- 22/11/2018 - Robert - Incluida coluna CLAS_ABD
--

-- GERA UMA CTE COM OS DADOS DO DOC E TOTAIS DE QUANTIDADE E VALOR, PARA POSTERIOR
-- UNIAO COM DADOS DO FORNECEDOR.
SELECT C.SAFRA,
       C.FILIAL,
       C.ASSOCIADO,
       C.LOJA_ASSOC,
       C.DOC,
       C.SERIE,
       C.ITEM_NOTA,
       C.PRODUTO,
       C.DESCRICAO,
       C.GRAU,
       C.CLAS_ABD,
       C.CLAS_FINAL,
       C.PESO_LIQ,
       C.VALOR_TOTAL AS VALOR_COMPRA,
       ISNULL(SUM(V.VALOR_TOTAL), 0) AS VALOR_COMPLEMENTO,
       (C.VALOR_TOTAL + ISNULL(SUM(V.VALOR_TOTAL), 0)) 
       / C.PESO_LIQ AS VUNIT_EFETIVO
FROM   VA_VNOTAS_SAFRA C
       LEFT JOIN VA_VNOTAS_SAFRA V
            ON  (
                    V.SAFRA = C.SAFRA
                    AND V.TIPO_NF = 'V'
                    AND V.FILIAL = C.FILIAL
                    AND V.ASSOCIADO = C.ASSOCIADO
                    AND V.LOJA_ASSOC = C.LOJA_ASSOC
                    AND V.NF_ORIGEM = C.DOC
                    AND V.SERIE_ORIGEM = C.SERIE
                    AND V.ITEM_ORIGEM = SUBSTRING(C.ITEM_NOTA, 3, 2) -- D2_ITEMORI E D1_ITEM TEM TAMANHOS DIFERENTES...
                )
WHERE  C.TIPO_NF = 'C'
GROUP BY
       C.SAFRA,
       C.FILIAL,
       C.ASSOCIADO,
       C.LOJA_ASSOC,
       C.DOC,
       C.SERIE,
       C.ITEM_NOTA,
       C.PRODUTO,
       C.DESCRICAO,
       C.GRAU,
       C.CLAS_ABD,
       C.CLAS_FINAL,
       C.VALOR_TOTAL,
       C.PESO_LIQ 

GO
