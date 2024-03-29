

ALTER VIEW [dbo].[VA_VPRECO_EFETIVO_SAFRA]
AS

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar precos efetivos de compra de safras (compra + complementos + etc...)
-- Autor: Robert Koch
-- Data:  24/05/2013
--
-- Historico de alteracoes:
-- 17/09/2015 - Robert - View VA_NOTAS_SAFRA renomeada para VA_VNOTAS_SAFRA
-- 22/11/2018 - Robert - Incluida coluna CLAS_ABD
-- 18/06/2020 - Robert - Incluidas colunas SIST_CONDUCAO E GRUPO_PAGTO
-- 25/11/2021 - Robert - Criada coluna VALOR_PREMIO (compl.2020 foi pago em forma de premiacao) GLPI 9897
-- 06/06/2023 - Robert - Leitura complem.2023 usando tabela SZH por que tive
--                       que juntar varias NF origem para cada NF compl (GLPI 13674)
-- 08/08/2023 - Robert - Gera somente a partir de 2017
-- 07/02/2023 - Robert - Usava tabela SZH para toda a safra 2023, nas emitimos complemento de 2023
--                       no ano de 2024 e isso nao se aplica (ajustado para usar pelo D1_ITEMORI).
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
       (C.VALOR_TOTAL + ISNULL(SUM(V.VALOR_TOTAL), 0) +  + ISNULL(SUM(ZZ9.ZZ9_VUNIT), 0)) / C.PESO_LIQ AS VUNIT_EFETIVO,
	C.SIST_CONDUCAO,
	C.GRUPO_PAGTO
FROM   VA_VNOTAS_SAFRA C

       -- SUBQUERY PARA PODER PEGAR NOTAS DE DIFERENTES SAFRAS COM DIFERENTES CRITERIOS.
	   LEFT JOIN (SELECT SAFRA, FILIAL, ASSOCIADO, LOJA_ASSOC
						, NF_ORIGEM, SERIE_ORIGEM, ITEM_ORIGEM, VALOR_TOTAL
					FROM VA_VNOTAS_SAFRA
				--	WHERE SAFRA != '2023'  -- PARA 2023 VOU LER USANDO TABELA SZH
					WHERE NOT (SAFRA = '2023' AND DATA LIKE '2023%') -- NF COMPL. EMITIDAS DENTRO DE 2023 VOU LER USANDO TABELA SZH
                    AND TIPO_NF = 'V'
					AND SAFRA >= '2017'  -- PARA SAFRAS ANTERIORES, TERIA QUE AJUSTAR OS CAMPOS D1+NFORI, D1_SERIORI E D1_ITEMORI

					UNION ALL

				   -- ANO DE 2023 AGRUPEI VARIAS NF ORIGEM NUME MESMA NF COMPLEMENTO, POIS
				   -- TIVE QUE COMPLEMENTAR PRATICAMENTE TODAS AS NOTAS ORIGINAIS, O QUE IA
				   -- GERAR MAIS DE 6000 NOTAS. AGORA TIVE QUE GERAR NO SZH PARA PODER FAZER
				   -- AS REFERENCIAS CORRETAS. "QUEM TEM PENA SE DESPENA", MESMO...
				   SELECT V23.SAFRA, V23.FILIAL, V23.ASSOCIADO, V23.LOJA_ASSOC
						, ZH_NFENTR AS NF_ORIGEM, ZH_SRNFENT AS SERIE_ORIGEM
						, SUBSTRING (ZH_ITNFE, 3, 2) AS ITEM_ORIGEM
						, SZH.ZH_RATEIO AS VALOR_TOTAL
					FROM VA_VNOTAS_SAFRA V23
						, SZH010 SZH
					WHERE V23.SAFRA = '2023'
					AND V23.FILIAL = SZH.ZH_FILIAL
					AND V23.TIPO_NF = 'V'
					AND V23.DOC = SZH.ZH_NFFRETE
					AND V23.SERIE = SZH.ZH_SERFRET
					AND SUBSTRING (V23.ITEM_NOTA, 3, 2) = SZH.ZH_ITNFS
					AND V23.ASSOCIADO = SZH.ZH_FORNECE
					AND V23.LOJA_ASSOC = SZH.ZH_LOJA
					AND V23.DATA LIKE '2023%'
					AND SZH.D_E_L_E_T_ = ''
					AND SZH.ZH_TPDESP = 'S'
					AND SZH.ZH_NFSAIDA = 'SAFRA2023'
				) V
            ON  (V.SAFRA = C.SAFRA
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
AND C.SAFRA >= '2017'  -- PARA SAFRAS ANTERIORES, TERIA QUE AJUSTAR OS CAMPOS D1+NFORI, D1_SERIORI E D1_ITEMORI
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

