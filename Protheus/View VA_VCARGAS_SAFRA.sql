SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [dbo].[VA_VCARGAS_SAFRA] AS
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados de recebimentos de uvas durante a safra.
-- Autor: Robert Koch
-- Data:  06/02/2012
-- Historico de alteracoes:
-- 02/08/2012 - Robert - Incluida coluna TIPO_FORNEC
-- 13/02/2013 - Robert - Campo B1_TPPROD passou a ser usado pelo Protheus 11. Em seu lugar foi criado o campo B1_VACOR.
--                     - Incluido campo B1_VAFCUVA.
-- 29/01/2015 - Robert - Passa a buscar dados di SF1 e SPED para calculo de tempo de espera para descarga.
-- 30/11/2015 - Robert - Passa a ter uma unica coluna com nome do associado.
-- 24/03/2016 - Robert - Incluido campo ZE_NFDEVOL.
-- 10/01/2018 - Robert - Incluidos campos de status, propr.rural e talhao.
-- 23/03/2018 - Robert - Coluna cooperativa, loja_coop e nome_coop desabilitadas por estarem em desuso.
-- 09/01/2018 - Robert - Incluidas columas caderno_campo e entregou_caderno
-- 05/03/2019 - Robert - Incluida coluna com a classificacao ABD
-- 15/01/2020 - Robert - Incluida coluna VALOR_FRETE.
-- 17/02/2020 - Robert - Exporta tombador efetivo (pelo ZZA010) quando disponivel.
-- 21/02/2020 - Robert - Incluidas colunas VARIEDADE_REAL e OBSERVACAO
-- 21/03/2020 - Robert - Eliminado left join com SZ7 (compatibilizar coluna TIPO_FORNEC com VA_VNOTAS_SAFRA)
-- 23/04/2020 - Robert - Passa a usar a funcao VA_FTIPO_FORNECEDOR_UVA para a coluna TIPO_FORNEC.
-- 28/01/2021 - Robert - Incluida coluna SIST_CONDUCAO
--

SELECT ZE_FILIAL AS FILIAL,
       ZE_SAFRA AS SAFRA,
       ZE_LOCAL AS LOCAL,
       ISNULL(ZX5_09.ZX5_09DESC, '') AS DESCLOCAL,
       ZE_ASSOC AS ASSOCIADO,
       SZE.ZE_LOJASSO AS LOJA_ASSOC,
       ISNULL(SA2_ASSOC.A2_NOME, SZE.ZE_NOMASSO) AS NOME_ASSOC,
       SZE.ZE_CARGA AS CARGA,
       SZE.ZE_AGLUTIN AS AGLUTINACAO,
       ZE_DATA AS DATA,
       ZE_HORA AS HORA,
       SZF.ZF_HRRECEB AS HORA_RECEBIMENTO,
       ZE_PLACA AS PLACA,
       ZE_NFPROD AS NF_PRODUTOR,
       ZE_SNFPROD AS SERIE_NF_PRODUTOR,
       ZE_NFGER AS CONTRANOTA,
       SZE.ZE_SERIE AS SERIE_CONTRANOTA,
       ZE_PESOBRU AS PESO_BRUTO,
       SZE.ZE_PESOTAR AS PESO_TARA,
       ZF_PRODUTO AS PRODUTO,
       B1_DESC AS DESCRICAO,
       B1_VARUVA AS VARUVA,
       SB1.B1_VAORGAN AS ORGANICA,
       ZF_PESO AS PESO_LIQ,
       ZF_GRAU AS GRAU,
       SZF.ZF_CADVITI AS CAD_VITIC,
       SZF.ZF_QTEMBAL AS QT_EMBALAG,
       SZF.ZF_EMBALAG AS EMBALAGEM,
       SZF.ZF_PRM02 AS ACUCAR,
       SZF.ZF_PRM03 AS SANIDADE,
       SZF.ZF_PRM04 AS MATURACAO,
       SZF.ZF_PRM05 AS MAT_ESTRANHO,
       SZF.ZF_PRM99 AS CLAS_FINAL,
	   SZF.ZF_CLASABD AS CLAS_ABD,
       SZF.ZF_NCONF01 AS NAO_CONF01,
       ISNULL(ZX5_NC01.ZX5_11DESC, '') AS DESC_NC01,
       SZF.ZF_NCONF02 AS NAO_CONF02,
       ISNULL(ZX5_NC02.ZX5_11DESC, '') AS DESC_NC02,
       SZF.ZF_NCONF03 AS NAO_CONF03,
       ISNULL(ZX5_NC03.ZX5_11DESC, '') AS DESC_NC03,
       SZF.ZF_NCONF04 AS NAO_CONF04,
       ISNULL(ZX5_NC04.ZX5_11DESC, '') AS DESC_NC04,
       SZF.ZF_ITEM AS ITEMCARGA,
       SB1.B1_VACOR AS COR,
       dbo.VA_FTIPO_FORNECEDOR_UVA (SZE.ZE_ASSOC, SZE.ZE_LOJASSO, SZE.ZE_DATA) AS TIPO_FORNEC,
       SB1.B1_VAFCUVA AS FORMA_CLAS_UVA_FINA,
       SB1.B1_VAUVAES AS PARA_ESPUMANTE,
       SZF.ZF_PESEST AS PESO_ESTIMADO,
       ISNULL (ZZA.ZZA_LINHA, SZE.ZE_LOCDESC) AS TOMBADOR,  -- O campo ZZA_LINHA eh gravado pelo softwsre da Mazeli, entao entendo-o como 'tombador efetivo'.
       SB1.B1_VATTR AS TINTOREA,
	   SZE.ZE_NFDEVOL AS NF_DEVOLUCAO,
	   SZE.ZE_STATUS AS STATUS,
	   SZF.ZF_IDZA8 AS PROPR_RURAL,
	   SZF.ZF_IDSZ9 AS TALHAO,
	   SZF.ZF_CADCPO AS CADERNO_CAMPO,
	   SZF.ZF_ENTRCAD AS ENTREGOU_CADERNO,
	   ZF_VALFRET AS VALOR_FRETE,
	   SZF.ZF_PRREAL AS VARIEDADE_REAL,
	   SZF.ZF_OBS AS OBSERVACAO,
	   SZF.ZF_CONDUC AS SIST_CONDUCAO
FROM   SZF010 SZF
       LEFT JOIN ZX5010 ZX5_NC01
            ON  (
                    ZX5_NC01.ZX5_FILIAL = '  '
                    AND ZX5_NC01.D_E_L_E_T_ = ''
                    AND ZX5_NC01.ZX5_TABELA = '11'
                    AND ZX5_NC01.ZX5_11COD = SZF.ZF_NCONF01
                    AND ZX5_NC01.ZX5_11SAFR = SZF.ZF_SAFRA
                )
       LEFT JOIN ZX5010 ZX5_NC02
            ON  (
                    ZX5_NC02.ZX5_FILIAL = '  '
                    AND ZX5_NC02.D_E_L_E_T_ = ''
                    AND ZX5_NC02.ZX5_TABELA = '11'
                    AND ZX5_NC02.ZX5_11COD = SZF.ZF_NCONF02
                    AND ZX5_NC02.ZX5_11SAFR = SZF.ZF_SAFRA
                )
       LEFT JOIN ZX5010 ZX5_NC03
            ON  (
                    ZX5_NC03.ZX5_FILIAL = '  '
                    AND ZX5_NC03.D_E_L_E_T_ = ''
                    AND ZX5_NC03.ZX5_TABELA = '11'
                    AND ZX5_NC03.ZX5_11COD = SZF.ZF_NCONF03
                    AND ZX5_NC03.ZX5_11SAFR = SZF.ZF_SAFRA
                )
       LEFT JOIN ZX5010 ZX5_NC04
            ON  (
                    ZX5_NC04.ZX5_FILIAL = '  '
                    AND ZX5_NC04.D_E_L_E_T_ = ''
                    AND ZX5_NC04.ZX5_TABELA = '11'
                    AND ZX5_NC04.ZX5_11COD = SZF.ZF_NCONF04
                    AND ZX5_NC04.ZX5_11SAFR = SZF.ZF_SAFRA
                )
	   LEFT JOIN ZZA010 ZZA
            ON (ZZA.D_E_L_E_T_ = ''
			        AND ZZA.ZZA_FILIAL = SZF.ZF_FILIAL
					AND ZZA.ZZA_SAFRA = SZF.ZF_SAFRA
					AND ZZA.ZZA_CARGA = SZF.ZF_CARGA
					and ZZA.ZZA_PRODUT = SZF.ZF_ITEM
				),
       SB1010 SB1,
       SZE010 SZE
       LEFT JOIN SA2010 SA2_COOP
            ON  (
                    SA2_COOP.D_E_L_E_T_ = ''
                    AND SA2_COOP.A2_FILIAL = '  '
                    AND SA2_COOP.A2_COD = SZE.ZE_COOP
                    AND SA2_COOP.A2_LOJA = SZE.ZE_LOJCOOP
                )
       LEFT JOIN SA2010 SA2_ASSOC
            ON  (
                    SA2_ASSOC.D_E_L_E_T_ = ''
                    AND SA2_ASSOC.A2_FILIAL = '  '
                    AND SA2_ASSOC.A2_COD = SZE.ZE_ASSOC
                    AND SA2_ASSOC.A2_LOJA = SZE.ZE_LOJASSO
                )
/*
       LEFT JOIN SZ7010 SZ7
            ON  (
                    SZ7.D_E_L_E_T_ = ''
                    AND SZ7.Z7_FILIAL = '  '
                    AND SZ7.Z7_FORNECE = SZE.ZE_ASSOC
                    AND SZ7.Z7_LOJA = SZE.ZE_LOJASSO
                    AND SZ7.Z7_SAFRA = SZE.ZE_SAFRA
                )
*/
       LEFT JOIN ZX5010 ZX5_09
            ON  (
                    ZX5_09.ZX5_FILIAL = (
                        SELECT CASE ZX5_MODO
                                    WHEN 'C' THEN '  '
                                    ELSE SZE.ZE_FILIAL
                               END
                        FROM   ZX5010 ZX5_FIL
                        WHERE  ZX5_FIL.D_E_L_E_T_ = ''
                               AND ZX5_FIL.ZX5_FILIAL = '  '
                               AND ZX5_FIL.ZX5_TABELA = '00'
                               AND ZX5_FIL.ZX5_CHAVE = '09'
                    )
                    AND ZX5_09.D_E_L_E_T_ = ''
                    AND ZX5_09.ZX5_TABELA = '09'
                    AND ZX5_09.ZX5_09LOCA = ZE_LOCAL
                    AND ZX5_09.ZX5_09SAFR = SZE.ZE_SAFRA
                )
       LEFT JOIN SF1010 SF1
            ON  (
                    SF1.D_E_L_E_T_ = ''
                    AND SF1.F1_FILIAL = SZE.ZE_FILIAL
                    AND SF1.F1_DOC = SZE.ZE_NFGER
                    AND SF1.F1_SERIE = SZE.ZE_SERIE
                    AND SF1.F1_FORNECE = SZE.ZE_ASSOC
                    AND SF1.F1_LOJA = SZE.ZE_LOJASSO
                )
WHERE  SB1.D_E_L_E_T_ != '*'
       AND SB1.B1_FILIAL = '  '
       AND SB1.B1_COD = SZF.ZF_PRODUTO
       AND SZE.D_E_L_E_T_ != '*'
       AND SZF.D_E_L_E_T_ != '*'
       AND SZF.ZF_FILIAL = SZE.ZE_FILIAL
       AND SZF.ZF_SAFRA = SZE.ZE_SAFRA
       AND SZF.ZF_CARGA = SZE.ZE_CARGA;       

GO
