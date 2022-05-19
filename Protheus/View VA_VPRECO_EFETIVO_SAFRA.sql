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
-- 18/06/2020 - Robert - Incluidas colunas SIST_CONDUCAO E GRUPO_PAGTO
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
       ISNULL(SUM(ZZ9.ZZ9_VUNIT), 0) AS VALOR_PREMIO,
--       (C.VALOR_TOTAL + ISNULL(SUM(V.VALOR_TOTAL), 0)) / C.PESO_LIQ AS VUNIT_EFETIVO,
       (C.VALOR_TOTAL + ISNULL(SUM(V.VALOR_TOTAL), 0) +  + ISNULL(SUM(ZZ9.ZZ9_VUNIT), 0)) / C.PESO_LIQ AS VUNIT_EFETIVO,
	C.SIST_CONDUCAO,
	C.GRUPO_PAGTO
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
       -- ANO DE 2020 GERAMOS COMPLEMENTO NA FORMA DE PREMIACAO DE QUALIDADE (GLPI 9415 E 9897).
       -- TENHO DADOS TAMBEM NA CONTA CORRENTE (TABELA SZI), MAS NAO SAO ABERTOS POR ITEM DE NOTA.
       LEFT JOIN ZZ9010 ZZ9
            ON  (
                   ZZ9.D_E_L_E_T_     = ''
                   AND ZZ9.ZZ9_SAFRA  = '2020'
                   AND ZZ9.ZZ9_PARCEL = 'K'
                   AND ZZ9.ZZ9_FILIAL = C.FILIAL
                   AND ZZ9.ZZ9_FORNEC = C.ASSOCIADO
                   AND ZZ9.ZZ9_LOJA   = C.LOJA_ASSOC
                   AND ZZ9.ZZ9_NFORI  = C.DOC
                   AND ZZ9.ZZ9_SERIOR = C.SERIE
                   AND ZZ9.ZZ9_ITEMOR = C.ITEM_NOTA
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
       C.PESO_LIQ,
	C.SIST_CONDUCAO,
	C.GRUPO_PAGTO
GO
