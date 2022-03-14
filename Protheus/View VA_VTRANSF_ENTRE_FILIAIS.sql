SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- Descricao: Retorna tabela com dados de notas fiscais de transferencias entre filiais.
-- Autor....: Robert Koch
-- Data.....: 28/01/2013
--
-- Historico de alteracoes:
-- 04/09/2013 - Robert  - Passa a considerar notas tipo B e D
--                      - Passa a usar FULL OUTER JOIN para relacionar entradas e saidas (antes buscava apenas relacionamentos exatos).
--                      - Ignora notas emitidas para a propria filial (remessa para feiras, impostos, etc.)
-- 27/09/2016 - Robert  - Incluidos campos D1_TP e D2_TP.
-- 03/11/2017 - Robert  - Incluidos campos D1_CF e D2_CF.
-- 22/11/2018 - Robert  - Incluidos campos D1_TOTAL e D2_TOTAL.
-- 18/02/2021 - Claudia - Incluido campo SD2.D2_LOTECTL

ALTER VIEW [dbo].[VA_VTRANSF_ENTRE_FILIAIS] AS
WITH ENTRADAS AS (
                     SELECT CASE 
                                 WHEN SD1.D1_TIPO IN ('B', 'D') THEN CLI.FILIAL
                                 ELSE FORN.FILIAL
                            END AS FILORIG,
                            SD1.D1_DTDIGIT,
                            SD1.D1_FILIAL,
                            SD1.D1_FORNECE,
                            SD1.D1_LOJA,
                            SD1.D1_SERIE,
                            SD1.D1_DOC,
                            SD1.D1_ITEM,
                            SD1.D1_COD,
                            SD1.D1_QUANT,
                            SD1.D1_TES,
                            SD1.D1_TIPO,
                            SD1.D1_CUSTO,
                            SD1.D1_LOCAL,
							SD1.D1_TP,
							SD1.D1_CF,
							SD1.D1_TOTAL,
							SD1.D1_LOTECTL
                     FROM   VA_SM0 SM0,
                            SD1010 SD1
                            LEFT JOIN (
                                     -- BUSCA CLIENTE PARA CASO DE NOTA B OU D
                                     SELECT M0_CODFIL AS FILIAL,
                                            SA1.A1_COD AS CODCLI,
                                            SA1.A1_LOJA AS LOJACLI
                                     FROM   VA_SM0 SM0,
                                            SA1010 SA1
                                     WHERE  SM0.D_E_L_E_T_ = ''
                                            AND SA1.D_E_L_E_T_ = ''
                                            AND SA1.A1_FILIAL = '  '
                                            AND SA1.A1_CGC = SM0.M0_CGC
                                            AND SM0.M0_CODIGO = '01'
                                 ) AS CLI
                                 ON  (CLI.CODCLI = SD1.D1_FORNECE AND CLI.LOJACLI = SD1.D1_LOJA)
                            LEFT JOIN (
                                     -- BUSCA FORNECEDOR PARA CASO DE NOTA NORMAL
                                     SELECT M0_CODFIL AS FILIAL,
                                            SA2.A2_COD AS CODFOR,
                                            SA2.A2_LOJA AS LOJAFOR
                                     FROM   VA_SM0 SM0,
                                            SA2010 SA2
                                     WHERE  SM0.D_E_L_E_T_ = ''
                                            AND SA2.D_E_L_E_T_ = ''
                                            AND SA2.A2_FILIAL = '  '
                                            AND SA2.A2_CGC = SM0.M0_CGC
                                            AND SM0.M0_CODIGO = '01'
                                 ) AS FORN
                                 ON  (
                                         FORN.CODFOR = SD1.D1_FORNECE
                                         AND FORN.LOJAFOR = SD1.D1_LOJA
                                     )
                     WHERE  SD1.D_E_L_E_T_ = ''
                     AND D1_TIPO NOT IN ('B', 'D')
                            AND (
                                    (
                                        SD1.D1_TIPO IN ('B', 'D')
                                        AND EXISTS (
                                                SELECT *
                                                FROM   SA1010 SA1
                                                WHERE  SA1.D_E_L_E_T_ = ''
                                                       AND SA1.A1_FILIAL = '  '
                                                       AND SA1.A1_COD = SD1.D1_FORNECE
                                                       AND SA1.A1_LOJA = SD1.D1_LOJA
                                                       AND SA1.A1_CGC 
                                                           != SM0.M0_CGC -- IGNORA NOTAS DA FILIAL PARA ELA MESMA (FEIRAS, IMPOSTOS, ETC.)
                                                       AND SUBSTRING(SA1.A1_CGC, 1, 8) = 
                                                           SUBSTRING(SM0.M0_CGC, 1, 8)
                                            )
                                    )
                                    OR (
                                           SD1.D1_TIPO NOT IN ('B', 'D')
                                           AND EXISTS (
                                                   SELECT *
                                                   FROM   SA2010 SA2
                                                   WHERE  SA2.D_E_L_E_T_ = ''
                                                          AND SA2.A2_FILIAL = 
                                                              '  '
                                                          AND SA2.A2_COD = SD1.D1_FORNECE
                                                          AND SA2.A2_LOJA = SD1.D1_LOJA
                                                          AND SA2.A2_CGC 
                                                              != SM0.M0_CGC -- IGNORA NOTAS DA FILIAL PARA ELA MESMA (FEIRAS, IMPOSTOS, ETC.)
                                                          AND SUBSTRING(SA2.A2_CGC, 1, 8) = 
                                                              SUBSTRING(SM0.M0_CGC, 1, 8)
                                               )
                                       )
                                )
                            AND SM0.D_E_L_E_T_ = ''
                            AND SM0.M0_CODIGO = '01'
                            AND SM0.M0_CODFIL = SD1.D1_FILIAL
                 ),
SAIDAS AS (
              SELECT CASE 
                          WHEN SD2.D2_TIPO IN ('B', 'D') THEN FORN.FILIAL
                          ELSE CLI.FILIAL
                     END AS FILDEST,
                     SD2.D2_EMISSAO,
                     SD2.D2_FILIAL,
                     SD2.D2_CLIENTE,
                     SD2.D2_LOJA,
                     SD2.D2_SERIE,
                     SD2.D2_DOC,
                     SD2.D2_ITEM,
                     SD2.D2_COD,
                     SD2.D2_QUANT,
                     SD2.D2_TES,
                     SD2.D2_TIPO,
                     SD2.D2_CUSTO1,
                     SD2.D2_LOCAL,
					 SD2.D2_TP,
					 SD2.D2_CF,
					 SD2.D2_TOTAL,
					 SD2.D2_LOTECTL
              FROM   VA_SM0 SM0,
                     SD2010 SD2
                     LEFT JOIN (
                              -- BUSCA CLIENTE PARA CASO DE NOTA NORMAL
                              SELECT M0_CODFIL AS FILIAL,
                                     SA1.A1_COD AS CODCLI,
                                     SA1.A1_LOJA AS LOJACLI
                              FROM   VA_SM0 SM0,
                                     SA1010 SA1
                              WHERE  SM0.D_E_L_E_T_ = ''
                                     AND SA1.D_E_L_E_T_ = ''
                                     AND SA1.A1_FILIAL = '  '
                                     AND SA1.A1_CGC = SM0.M0_CGC
                                     AND SM0.M0_CODIGO = '01'
                          ) AS CLI
                          ON  (CLI.CODCLI = SD2.D2_CLIENTE AND CLI.LOJACLI = SD2.D2_LOJA)
                     LEFT JOIN (
                              -- BUSCA FORNECEDOR PARA CASO DE NOTA B OU D
                              SELECT M0_CODFIL AS FILIAL,
                                     SA2.A2_COD AS CODFOR,
                                     SA2.A2_LOJA AS LOJAFOR
                              FROM   VA_SM0 SM0,
                                     SA2010 SA2
                              WHERE  SM0.D_E_L_E_T_ = ''
                                     AND SA2.D_E_L_E_T_ = ''
                                     AND SA2.A2_FILIAL = '  '
                                     AND SA2.A2_CGC = SM0.M0_CGC
                                     AND SM0.M0_CODIGO = '01'
                          ) AS FORN
                          ON  (
                                  FORN.CODFOR =
                                  SD2.D2_CLIENTE
                                  AND FORN.LOJAFOR 
                                      = SD2.D2_LOJA
                              )
              WHERE  SD2.D_E_L_E_T_ = ''
              AND D2_TIPO NOT IN ('B', 'D')
                     AND (
                             (
                                 SD2.D2_TIPO IN ('B', 'D')
                                 AND EXISTS (
                                         SELECT *
                                         FROM   SA2010 
                                                SA2
                                         WHERE  SA2.D_E_L_E_T_ = ''
                                                AND SA2.A2_FILIAL = '  '
                                                AND SA2.A2_COD = SD2.D2_CLIENTE
                                                AND SA2.A2_LOJA = SD2.D2_LOJA
                                                AND SA2.A2_CGC 
                                                    != SM0.M0_CGC -- IGNORA NOTAS DA FILIAL PARA ELA MESMA (FEIRAS, IMPOSTOS, ETC.)
                                                AND SUBSTRING(SA2.A2_CGC, 1, 8) = SUBSTRING(SM0.M0_CGC, 1, 8)
                                     )
                             )
                             OR (
                                    SD2.D2_TIPO 
                                    NOT IN ('B', 'D')
                                    AND EXISTS (
                                            SELECT *
                                            FROM   SA1010 
                                                   SA1
                                            WHERE  SA1.D_E_L_E_T_ = ''
                                                   AND SA1.A1_FILIAL = '  '
                                                   AND SA1.A1_COD = SD2.D2_CLIENTE
                                                   AND SA1.A1_LOJA = SD2.D2_LOJA
                                                   AND SA1.A1_CGC 
                                                       != SM0.M0_CGC -- IGNORA NOTAS DA FILIAL PARA ELA MESMA (FEIRAS, IMPOSTOS, ETC.)
                                                   AND SUBSTRING(SA1.A1_CGC, 1, 8) = SUBSTRING(SM0.M0_CGC, 1, 8)
                                        )
                                )
                         )
                     AND SM0.D_E_L_E_T_ = ''
                     AND SM0.M0_CODIGO = '01'
                     AND SM0.M0_CODFIL = SD2.D2_FILIAL
                         
                         /*                     AND NOT EXISTS (
                         SELECT *
                         FROM   SD1010 SD1
                         WHERE  SD1.D_E_L_E_T_ != '*'
                         AND SD1.D1_FILIAL = SD1.D1_FILIAL
                         AND SD1.D1_NFORI = SD1.D1_DOC
                         AND SD1.D1_SERIORI = SD1.D1_SERIE
                         AND SD1.D1_ITEMORI = SD1.D1_ITEM
                         AND SD1.D1_FORNECE = SD1.D1_FORNECE
                         AND SD1.D1_LOJA = SD1.D1_LOJA
                         AND SD1.D1_COD = SD1.D1_COD
                         AND SD1.D1_TIPO = CASE 
                         WHEN SD1.D1_TIPO IN ('B', 'D') THEN 
                         'N'
                         ELSE 'D'
                         END
                         ) -- NOTA PODE TER SIDO DEVOLVIDA, MAS NESTE CASO A ENTRADA NA FILIAL DESTINO FOI EXCLUIDA...
                         */
          )
                     
SELECT *
FROM   ENTRADAS
       FULL OUTER 
       JOIN SAIDAS
            ON  (
                    SAIDAS.FILDEST = ENTRADAS.D1_FILIAL
                    AND SAIDAS.D2_FILIAL = ENTRADAS.FILORIG 
                    AND SAIDAS.D2_SERIE = ENTRADAS.D1_SERIE
                    AND SAIDAS.D2_DOC = ENTRADAS.D1_DOC
                    AND SAIDAS.D2_COD = ENTRADAS.D1_COD
                    AND SAIDAS.D2_QUANT = ENTRADAS.D1_QUANT -- USA A QUANTIDADE POR QUE PODE HAVER MAIS DE UMA OCORRENCIA DO MESMO PRODUTO NA NOTA FISCAL.
                )

GO
