SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados de notas de fiscais de venda para entrega futura e suas remessas
-- Autor: Robert Koch
-- Data:  01/03/2013
-- Historico de alteracoes:
-- 13/11/2014 - Robert - Tratamento para status 'E'
-- 
-- Obs.: ADA_STATUS=='A': Contrato em Aberto
--       ADA_STATUS=='B': Contrato Aprovado
--       ADA_STATUS=='C': Contrato Parcialmente Entregue
--       ADA_STATUS=='E': Contrato encerrado Manualmente
--       ADA_STATUS=='D': Contrato Totalmente Entregue
--

ALTER VIEW [dbo].[VA_VVENDA_ENT_FUTURA]
AS

-- MONTA 'CTE' COM OS MOVIMENTOS DE NOTAS A CONSIDERAR
WITH MOVTOS AS (
                   SELECT ADB.ADB_FILIAL AS FILIAL,
                          ADB.ADB_NUMCTR AS CONTRATO,
                          ADA.ADA_STATUS AS STATUS,
                          ADA.ADA_CODCLI AS CLIENTE,
                          ADA.ADA_LOJCLI AS LOJA,
                          ADA.ADA_VAOBS AS OBS,
                          ADB.ADB_ITEM AS ITEM_CONTR,
                          ADB.ADB_CODPRO AS PRODUTO,
                          ADB.ADB_DESPRO AS DESCRICAO,
                          ADB.ADB_QUANT AS QT_CONTRAT,
                          CASE 
                               WHEN SD2.D2_TES = ADB.ADB_TESCOB THEN 'F'
                               ELSE 'R'
                          END AS TIPO_MOVTO,
                          SC6.C6_NUM AS PED_VENDA,
                          SC6.C6_ITEM AS ITEM_PV,
                          SD2.D2_DOC AS NF,
                          SD2.D2_SERIE AS SERIE,
                          SD2.D2_ITEM AS ITEM_NF,
                          SD2.D2_EMISSAO AS EMISSAO_NF,
                          SD2.D2_LOCAL AS ALMOX,
                          -- ASSUME REMESSA QUANDO NAO FOR FATURAMENTO, POR QUE ALGUMAS NOTAS ANTIGAS USARAM VARIOS TES DIFERENTES.
                          SD2.D2_QUANT *
                          CASE 
                               WHEN SD2.D2_TES = ADB.ADB_TESCOB THEN 1
                               ELSE -1
                          END AS QUANT_NF,
                          SD2.D2_TOTAL *
                          CASE 
                               WHEN SD2.D2_TES = ADB.ADB_TESCOB THEN 1
                               ELSE -1
                          END AS VALOR_NF,
                          SD2.D2_CUSTO1 *
                          CASE 
                               WHEN SD2.D2_TES = ADB.ADB_TESCOB THEN -1
                               ELSE 1
                          END AS CUSTO_NF
                   FROM   ADA010 ADA,
                          ADB010 ADB,
                          SC6010 SC6,
                          SB2010 SB2,
                          SD2010 SD2
                   WHERE  ADA.D_E_L_E_T_ = ''
                          AND ADA.ADA_FILIAL = ADB.ADB_FILIAL
                          AND ADA.ADA_NUMCTR = ADB.ADB_NUMCTR
                          AND ADB.D_E_L_E_T_ = ''
                          AND SC6.D_E_L_E_T_ = ''
                          AND SC6.C6_FILIAL = ADB.ADB_FILIAL
                          AND SC6.C6_CONTRAT = ADB.ADB_NUMCTR
                          AND SC6.C6_ITEMCON = ADB.ADB_ITEM
                          AND SD2.D_E_L_E_T_ = ''
                          AND SD2.D2_FILIAL = SC6.C6_FILIAL
                          AND SD2.D2_PEDIDO = SC6.C6_NUM
                          AND SD2.D2_ITEMPV = SC6.C6_ITEM
                          AND SB2.D_E_L_E_T_ = ''
                          AND SB2.B2_FILIAL = SD2.D2_FILIAL
                          AND SB2.B2_COD = SD2.D2_COD
                          AND SB2.B2_LOCAL = SD2.D2_LOCAL
               )

-- MONTA TABELA COM OS DADOS DAS NOTAS E SALDOS
SELECT TOP 100 PERCENT 
       ROW_NUMBER () OVER (ORDER BY M1.FILIAL,
       M1.CONTRATO,
       M1.STATUS,
       M1.OBS,
       M1.ITEM_CONTR,
       M1.EMISSAO_NF,
       M1.NF,
       M1.ITEM_NF
) AS ROW_NUMBER, M1.FILIAL,
       M1.CONTRATO,
       M1.STATUS,
       M1.OBS,
       M1.ITEM_CONTR,
       M1.CLIENTE,
       M1.LOJA,
       M1.PRODUTO,
       M1.QT_CONTRAT,
       -- NF ORIGEM: A NOTA FISCAL MAIS ANTIGA DO CONTRATO/ITEM, POIS A OPERACAO SEMPRE INICIA PELO FATURAMENTO.
       SUBSTRING(
           MIN(M1.EMISSAO_NF + M1.NF) OVER(PARTITION BY M1.FILIAL, M1.CONTRATO, M1.ITEM_CONTR),
           9,
           9
       ) AS NF_ORIG,
       M1.PED_VENDA,
       M1.ITEM_PV,
       M1.TIPO_MOVTO,
       M1.EMISSAO_NF,
       M1.NF,
       M1.SERIE,
       M1.ITEM_NF,
       M1.ALMOX,
       M1.QUANT_NF,
       M1.CUSTO_NF,

       -- COMPOE O SALDO PELA QUANTIDADE FATURADA MENOS O ACUMULADO DAS QUANTIDADES REMETIDAS, INCLUSIVE A REMESSA ATUAL.
       CASE M1.STATUS WHEN 'E' THEN 0 ELSE SUM(M2.QUANT_NF) END AS SALDO_QT,
       CASE M1.STATUS WHEN 'E' THEN 0 ELSE SUM(M2.VALOR_NF) END AS SALDO_VALOR,
       CASE M1.STATUS WHEN 'E' THEN 0 ELSE SUM(M2.QUANT_NF) * ISNULL(
           (
               SELECT TOP 1 SB9.B9_VINI1 / SB9.B9_QINI
               FROM   SB9010 SB9
               WHERE  SB9.D_E_L_E_T_ = ''
                      AND SB9.B9_FILIAL = M1.FILIAL
                      AND SB9.B9_COD = M1.PRODUTO
                      AND SB9.B9_LOCAL = M1.ALMOX
                      AND SB9.B9_DATA <= M1.EMISSAO_NF
                      AND SB9.B9_QINI > 0
                      AND ROUND(SB9.B9_VINI1, 2) > 0
               ORDER BY
                      SB9.B9_DATA DESC
           ),
           0
       ) END AS SALDO_CUSTO
FROM   MOVTOS M1
       -- JOIN COM A PROPRIA TABELA PARA PODER COMPOR O SALDO A PARTIR DA NF ANTERIOR.
       JOIN MOVTOS M2
            ON  (
                    M2.FILIAL = M1.FILIAL
                    AND M2.CONTRATO = M1.CONTRATO
                    AND M2.ITEM_CONTR = M1.ITEM_CONTR
                    AND M2.EMISSAO_NF <= M1.EMISSAO_NF
                    AND M2.NF + M2.SERIE + M2.ITEM_NF <= M1.NF + M1.SERIE + M1.ITEM_NF
                )
GROUP BY
       M1.FILIAL,
       M1.CONTRATO,
       M1.STATUS,
       M1.OBS,
       M1.ITEM_CONTR,
       M1.CLIENTE,
       M1.LOJA,
       M1.PRODUTO,
       M1.TIPO_MOVTO,
       M1.EMISSAO_NF,
       M1.PED_VENDA,
       M1.ITEM_PV,
       M1.EMISSAO_NF,
       M1.NF,
       M1.SERIE,
       M1.ITEM_NF,
       M1.ALMOX,
       M1.QT_CONTRAT,
       M1.QUANT_NF,
       M1.CUSTO_NF
ORDER BY
       M1.FILIAL,
       M1.CONTRATO,
       M1.ITEM_CONTR,
       M1.EMISSAO_NF,
       M1.NF,
       M1.ITEM_NF
GO
