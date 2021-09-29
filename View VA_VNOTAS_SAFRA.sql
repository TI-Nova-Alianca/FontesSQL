USE [protheus]
GO

/****** Object:  View [dbo].[VA_VNOTAS_SAFRA]    Script Date: 29/09/2021 08:28:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter VIEW [dbo].[VA_VNOTAS_SAFRA]
AS

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados de notas de fiscais referentes a safras.
-- Autor: Robert Koch
-- Data:  15/02/2012
-- Historico de alteracoes:
-- 16/03/2012 - Robert  - Criadas classificacoes 'Producao propria' e 'Complemento de preco' no tipo de NF.
-- 20/06/2012 - Robert  - Ajustes ref. producao propria 2007 e 2008 que nao apareciam.
--                     - Tratamento para tipo de fornecedor = 5 na tabela SZ7.
-- 15/07/2012 - Robert  - Colunas TIPO_NF e TIPO_ASSOC passam a retornar apenas 1 caracter.
--                      - Coluna TIPO_ASSOC renomeada para TIPO_FORNEC
--                      - Considera somente B1_TIPO = 'MP'
-- 18/07/2012 - Robert  - Tratamento para NF 080779.
--                      - Considera D1_TP = 'MP' e nao mais B1_TIPO = 'MP'
-- 09/11/2012 - Robert  - Incluidos campos de NF/serie/item origem.
-- 03/12/2012 - Robert  - Incluidos campos de codigo e loja base do associado.
-- 25/04/2014 - Robert  - Incluido campo D1_VACLABD
-- 26/01/2015 - Robert  - Tratamento NFs complemento vinho cantinas rurais ref. safra 2014 geradas em 2015.
-- 06/05/2015 - Robert  - Tratamento para considerar TES 028 com D1_NFORI como complemento de preco.
-- 11/06/2015 - Robert  - Renomeada de VA_NOTAS_SAFRA para VA_VNOTAS_SAFRA
--                      - Tratamento para abater diversas devolucoes da safra 2015.
-- 05/08/2015 - Robert  - Tratamento para abater mais devolucoes da safra 2015.
-- 14/09/2015 - Robert  - Incluida coluna COOP_ORIGEM.
-- 03/03/2016 - Robert  - Desconsidera notas devolvidas safra 2016.
-- 12/03/2016 - Robert  - Incluida coluna TINTOREA.
-- 14/03/2016 - Robert  - Adicionado fornecedor 00311401 como producao propria.
-- 28/03/2016 - Robert  - Passa a descontar notas da view VA_VNOTAS_SAFRA_DEVOLVIDAS (antes estavam fixas aqui).
-- 31/01/2017 - Robert  - Passa a usar o campo F1_VASAFRA
--                      - Incluido TES 128 como entrada de uva
-- 27/03/2018 - Robert  - Incluido TES 107 como compra/compl preco de uva
-- 13/08/2018 - Robert  - Criada coluna GRUPO_PAGTO
-- 14/01/2020 - Robert  - Criada coluna FRETE_TOTAL (Total da nota e nao por item)
-- 16/03/2020 - Robert  - Removida coluna FRETE_TOTAL (muita confusao, por que trazia o total da nota e o resto das colunas eh por item)
--                      - Coluna TIPO_FORNEC passa a diferenciar apenas PROPRIA/ASSOCIADOS/NAO_ASSOCIADOS.
-- 17/03/2020 - Robert  - Acrescentado TES 192 como 'compra'.
-- 21/03/2020 - Robert  - Removido left join com SZ7.
-- 23/04/2020 - Robert  - Passa a usar a funcao VA_FTIPO_FORNECEDOR_UVA para a coluna TIPO_FORNEC.
-- 05/06/2020 - Robert  - Relacionado SD1 com SZE e SZF para pegar dados de cargas (somente a partir da safra 2020).
-- 13/01/2021 - Claudia - Incluida as TES ,'310','311','312','313' para safra 2021
-- 01/02/2021 - Robert  - Incluida amarracao entre D1_ITEM e ZF_ITEM por que houve casos (em 2021) de duas linhas na carga com mesmo produto.
-- 25/02/2021 - Robert  - Incluida loga 02 do fornecedor 001369 como producao propria (cadastro criado na safra 2021).
-- 02/07/2021 - Claudia - Incluido campos de funrural. GLPI: 10177
-- 29/07/2021 - Robert  - Nao considerava o campo A2_LOJA ao relacionar SD1 com SA2 (GLPI 11005)
--

SELECT SAFRA,
       CASE 
            WHEN D1_TES = '028' AND D1_NFORI != '' THEN 'V' -- COMPLEMENTO VALOR PRODUCAO PROPRIA 2015
            ELSE CASE 
--                      WHEN D1_TES IN ('077', '188') THEN CASE D1_TIPO
--                      WHEN D1_TES IN ('077', '188', '107') THEN CASE D1_TIPO
                      WHEN D1_TES IN ('077', '188', '107', '192','310','311','312','313') THEN CASE D1_TIPO
                                                              WHEN 'N' THEN 'C' --'COMPRA'
                                                              WHEN 'C' THEN 'V' --VALOR ou 'COMPLEMENTO_PRECO'
                                                              ELSE ''
                                                         END
                      ELSE CASE 
--                                WHEN D1_TES IN ('028', '057') THEN CASE 
                                WHEN D1_TES IN ('028', '057', '128') THEN CASE 
                                                                        WHEN ITENS.D1_FORNECE 
                                                                             + 
                                                                             ITENS.D1_LOJA IN ('00136901', '00136902', '00109401', '00311401') THEN
                                                                             'P' --'PRODUCAO_PROPRIA' -- PROD.PROPRIA 2008 SAIU PARA FORNECEDOR REF. FILIAL 02
                                                                        ELSE 'E' --'ENTRADA'
                                                                   END
                                ELSE ''
                           END
                 END
       END AS TIPO_NF,
       D1_FILIAL AS FILIAL,
       D1_DOC AS DOC,
       D1_SERIE AS SERIE,
       D1_FORNECE AS ASSOCIADO,
       D1_LOJA AS LOJA_ASSOC,
       A2_NOME AS NOME_ASSOC,
       D1_COD AS PRODUTO,
       D1_QUANT AS PESO_LIQ,
       D1_GRAU AS GRAU,
       D1_PRM99 AS CLAS_FINAL,
       B1_DESC AS DESCRICAO,
       D1_VUNIT AS VALOR_UNIT,
       D1_TOTAL AS VALOR_TOTAL,
       D1_DTDIGIT AS DATA,
       ITENS.D1_VAVITIC AS CAD_VITIC,
       dbo.VA_FTIPO_FORNECEDOR_UVA (ITENS.D1_FORNECE, ITENS.D1_LOJA, ITENS.D1_DTDIGIT) AS TIPO_FORNEC,
       ITENS.F1_VANFPRO AS NF_PRODUTOR,
       ITENS.D1_VACONDU AS SIST_CONDUCAO,
       SB1.B1_VAORGAN AS TIPO_ORGANICO,
       SB1.B1_VARUVA AS FINA_COMUM,
       SB1.B1_VACOR AS COR,
       D1_PRM02 AS ACUCAR,
       D1_PRM03 AS SANIDADE,
       D1_PRM04 AS MATURACAO,
       D1_PRM05 AS MAT_ESTRANHO,
       D1_ITEM AS ITEM_NOTA,
       D1_NFORI AS NF_ORIGEM,
       D1_SERIORI AS SERIE_ORIGEM,
       D1_ITEMORI AS ITEM_ORIGEM,
       SA2.A2_VACBASE AS CODBASEASSOC,
       SA2.A2_VALBASE AS LOJABASEASSOC,
       SB1.B1_VAFCUVA AS FORMA_CLAS_UVA_FINA,
       SB1.B1_VAUVAES AS PARA_ESPUMANTE,
       ITENS.D1_VACLABD AS CLAS_ABD,
	   SA2.A2_VACORIG AS COOP_ORIGEM,
       SB1.B1_VATTR AS TINTOREA,
	   ITENS.F1_VAGPSAF AS GRUPO_PAGTO,
	   ITENS.CARGA,
	   ITENS.VALOR_FRETE,
	   D1_BASEFUN AS BASE_FUNRURAL,
	   D1_ALIQFUN AS ALIQ_FUNRURAL,
	   D1_VALFUN AS VLR_FUNRURAL
FROM   SA2010 SA2,
       SB1010 SB1,

       -- SUBQUERY PARA JUNTAR DIRENTES ORIGENS
       (
           -- SITUACAO GERAL
           SELECT F1_VASAFRA AS SAFRA,
           D1_FORNECE,
           D1_LOJA,
           D1_TES,
           D1_FILIAL,
           D1_DOC,
           D1_SERIE,
           -- TRATA NF ESPECIFICA, QUE FICOU COM CODIGO GENERICO NO SISTEMA (CONFERIDO COD. CORRETO NA NF EM PAPEL)
           CASE WHEN D1_FILIAL = '01' AND D1_DOC = '080779' AND D1_SERIE = '' AND D1_FORNECE = '000626' AND D1_LOJA = '01' AND D1_COD = '9999' THEN '9926'
		   ELSE D1_COD END AS D1_COD,
           D1_QUANT,
           D1_GRAU,
           D1_PRM02,
           SD1.D1_PRM03,
           SD1.D1_PRM04,
           D1_PRM05,
           D1_PRM99,
           D1_VUNIT,
           D1_TOTAL,
           D1_VAVITIC,
           D1_VACONDU,
           D1_DTDIGIT,
           D1_TIPO,
           D1_ITEM,
           D1_NFORI,
           D1_SERIORI,
           D1_ITEMORI,
           D1_VACLABD,
		   SF1.F1_VANFPRO,
		   SF1.F1_VAGPSAF,
		   ISNULL (CARGA.ZE_CARGA, '') AS CARGA,  -- ESTE CAMPO NAO EH BUSCADO PARA SAFRAS ANTIGAS
		   ISNULL (CARGA.ZF_VALFRET, 0) AS VALOR_FRETE,  -- ESTE CAMPO NAO EH BUSCADO PARA SAFRAS ANTIGAS
		   D1_BASEFUN,
		   D1_ALIQFUN,
		   D1_VALFUN
           FROM SD1010 SD1
				-- RELACIONA COM CARGAS DE UVA PARA BUSCAR DADOS COMO O FRETE, QUE CONSTA APENAS NA TABELA SZF.
				LEFT JOIN (SELECT SZE.ZE_FILIAL, SZE.ZE_SAFRA, SZE.ZE_ASSOC, SZE.ZE_LOJASSO, SZE.ZE_NFGER, SZE.ZE_SERIE, SZE.ZE_CARGA, SZF.ZF_PRODUTO, SZF.ZF_GRAU, SZF.ZF_CLASABD, SZF.ZF_PRM99, SZF.ZF_CADVITI, SZF.ZF_VALFRET, SZF.ZF_ITEM
					FROM SZE010 SZE, SZF010 SZF
					WHERE SZE.D_E_L_E_T_ = ''
					AND SZF.D_E_L_E_T_ != '*'
					AND SZE.ZE_SAFRA >= '2020'  -- ANTES DESTE ANO OS REGISTROS NAO ESTAO 100% COMPATIVEIS ENTRE SZF E SD1
					AND SZF.ZF_FILIAL = SZE.ZE_FILIAL
					AND SZF.ZF_SAFRA = SZE.ZE_SAFRA
					AND SZF.ZF_CARGA = SZE.ZE_CARGA) AS CARGA
					ON (CARGA.ZE_FILIAL = SD1.D1_FILIAL
					AND CARGA.ZE_ASSOC = SD1.D1_FORNECE
					AND CARGA.ZE_LOJASSO = SD1.D1_LOJA
					AND CARGA.ZE_NFGER = SD1.D1_DOC
					AND CARGA.ZE_SERIE = SD1.D1_SERIE
					AND CARGA.ZF_PRODUTO = SD1.D1_COD
					AND CARGA.ZF_GRAU = SD1.D1_GRAU
					AND CARGA.ZF_CLASABD = SD1.D1_VACLABD
					AND CARGA.ZF_PRM99 = SD1.D1_PRM99
					AND CARGA.ZF_CADVITI = SD1.D1_VAVITIC
					AND '00' + CARGA.ZF_ITEM = SD1.D1_ITEM)
				,SF1010 SF1
           WHERE SF1.D_E_L_E_T_ = ''
		   AND SF1.F1_VASAFRA != ''
		   AND SF1.F1_FILIAL = SD1.D1_FILIAL
		   AND SF1.F1_DOC = SD1.D1_DOC
		   AND SF1.F1_SERIE = SD1.D1_SERIE
		   AND SF1.F1_FORNECE = SD1.D1_FORNECE
		   AND SF1.F1_LOJA = SD1.D1_LOJA
		   AND SD1.D_E_L_E_T_ = ''
           AND SF1.F1_FILIAL != '02' -- NUNCA RECEBEU UVA
--           AND SD1.D1_TES IN ('028', '077', '188', '128') -- Por enquanto, apenas estes.
--           AND SD1.D1_TES IN ('028', '077', '188', '128', '107') -- Por enquanto, apenas estes.
           AND SD1.D1_TES IN ('028', '077', '188', '128', '107', '192','310','311','312','313') -- Por enquanto, apenas estes.
           AND F1_FORNECE != '000021' -- Notas para fins de comprovacao para leilao em 2011
           AND SD1.D1_TP = 'MP' -- Desconsidera compra vinho cantinas rurais
           AND F1_DTDIGIT != '20120910' -- Notas de compra que foram devolvidas posteriormente.

           AND NOT EXISTS (SELECT *
		                     FROM VA_VNOTAS_SAFRA_DEVOLVIDAS D
                            WHERE D.SAFRA      = SUBSTRING (SD1.D1_EMISSAO, 1, 4)
							  AND D.FILIAL     = SD1.D1_FILIAL
							  AND D.DOC        = SD1.D1_DOC
							  AND D.SERIE      = SD1.D1_SERIE
							  AND D.FORNECEDOR = SD1.D1_FORNECE
							  AND D.LOJA       = SD1.D1_LOJA)

           UNION ALL
           
		    -- PRODUCAO PROPRIA 2007 USAVA TES DE TRANSFERENCIA.
            SELECT '2007' AS SAFRA,
                    D1_FORNECE,
                    D1_LOJA,
                    D1_TES,
                    D1_FILIAL,
                    D1_DOC,
                    D1_SERIE,
                    D1_COD,
                    D1_QUANT,
                    D1_GRAU,
                    D1_PRM02,
                    SD1.D1_PRM03,
                    SD1.D1_PRM04,
                    D1_PRM05,
                    D1_PRM99,
                    D1_VUNIT,
                    D1_TOTAL,
                    D1_VAVITIC,
                    D1_VACONDU,
                    D1_DTDIGIT,
                    D1_TIPO,
                    D1_ITEM,
                    D1_NFORI,
                    D1_SERIORI,
                    D1_ITEMORI,
                    D1_VACLABD,
					SF1.F1_VANFPRO,
					SF1.F1_VAGPSAF,
				    '' AS CARGA,
				    0 AS VALOR_FRETE,
					D1_BASEFUN,
					D1_ALIQFUN,
					D1_VALFUN
            FROM   SD1010 SD1, SF1010 SF1
					WHERE SF1.D_E_L_E_T_ = ''
					AND SF1.F1_VASAFRA != ''
					AND SF1.F1_FILIAL = SD1.D1_FILIAL
					AND SF1.F1_DOC = SD1.D1_DOC
					AND SF1.F1_SERIE = SD1.D1_SERIE
					AND SF1.F1_FORNECE = SD1.D1_FORNECE
					AND SF1.F1_LOJA = SD1.D1_LOJA
					AND SD1.D_E_L_E_T_ = ''
                    AND SD1.D1_FILIAL = '03'
                    AND SD1.D1_TES IN ('057')
                    AND D1_FORNECE = '001369'
                    AND D1_LOJA = '01'
                    AND D1_DTDIGIT BETWEEN '20070101' AND '20071231'
       ) AS ITENS
WHERE SA2.D_E_L_E_T_ = ''
  AND SB1.D_E_L_E_T_ = ''
  AND SB1.B1_FILIAL  = '  '
  AND SA2.A2_FILIAL  = '  '
  AND SB1.B1_COD     = ITENS.D1_COD
  AND SA2.A2_COD     = ITENS.D1_FORNECE
  AND SA2.A2_LOJA    = ITENS.D1_LOJA
GO
