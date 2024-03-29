-- Cooperativa Vinicola Nova Alianca Ltda
-- View para relacionar familias de uvas (convencionais, organicas, bordadura, em conversao, viniferas sem classif,...)
-- Autor: Robert Koch
-- Data:  05/05/2012
-- Historico de alteracoes:
-- 15/01/2013 - Robert - Incluido tratamento para uvas viniferas classificadas como uva comum.
-- 31/03/2015 - Robert - Descricoes passam a ser buscadas com RTRIM().
-- 22/04/2015 - Robert - Passa a buscar tambem as descricoes resumidas (B5_CEME).
--

ALTER VIEW [dbo].[VA_VFAMILIAS_UVAS] AS 
SELECT BASE.B1_COD AS COD_BASE,
       RTRIM(BASE.B1_DESC) AS DESCR_BASE,
       BASE.B1_VARUVA AS FINA_COMUM,
       -- CAMPO AINDA NAO CRIADO  BASE.B1_VACORUV AS COR,
       ISNULL(EM_CONV.B1_COD, '') AS COD_EM_CONVERSAO,
       ISNULL(RTRIM(EM_CONV.B1_DESC), '') AS DESCR_EM_CONVERSAO,
       ISNULL(BORDADURA.B1_COD, '') AS COD_BORDADURA,
       ISNULL(RTRIM(BORDADURA.B1_DESC), '') AS DESCR_BORDADURA,
       ISNULL(ORGANICA.B1_COD, '') AS COD_ORGANICA,
       ISNULL(RTRIM(ORGANICA.B1_DESC), '') AS DESCR_ORGANICA,
       ISNULL(FINACLCOMUM.B1_COD, '') AS COD_FINA_CLAS_COMUM,
       ISNULL(RTRIM(FINACLCOMUM.B1_DESC), '') AS DESCR_FINA_CLAS_COMUM,
       ISNULL(PARAESPUMANTE.B1_COD, '') AS COD_PARA_ESPUMANTE,
       ISNULL(RTRIM(PARAESPUMANTE.B1_DESC), '') AS DESCR_PARA_ESPUMANTE,
       BASE.B1_VACOR AS COR,
       BASE.B1_VATTR AS TINTOREA,
       ISNULL(RTRIM(SB5_BASE.B5_CEME), '') AS DESC_RESUM,
       ISNULL(RTRIM(SB5_EM_CONV.B5_CEME), '') AS DESC_RESUM_EM_CONVERSAO,
       ISNULL(RTRIM(SB5_BORD.B5_CEME), '') AS DESC_RESUM_BORDADURA,
       ISNULL(RTRIM(SB5_ORG.B5_CEME), '') AS DESC_RESUM_ORGANICA,
       ISNULL(RTRIM(SB5_FCC.B5_CEME), '') AS DESC_RESUM_FINA_CLAS_COMUM,
       ISNULL(RTRIM(SB5_PESP.B5_CEME), '') AS DESC_RESUM_PARA_ESPUMANTE
FROM   SB1010 BASE
       LEFT JOIN SB5010 SB5_BASE
            ON  (
                    SB5_BASE.D_E_L_E_T_ = ''
                    AND SB5_BASE.B5_FILIAL = BASE.B1_FILIAL
                    AND SB5_BASE.B5_COD = BASE.B1_COD
                )
       LEFT JOIN SB1010 EM_CONV
       LEFT JOIN SB5010 SB5_EM_CONV
            ON  (
                    SB5_EM_CONV.D_E_L_E_T_ = ''
                    AND SB5_EM_CONV.B5_FILIAL = EM_CONV.B1_FILIAL
                    AND SB5_EM_CONV.B5_COD = EM_CONV.B1_COD
                )
            ON  (
                    EM_CONV.D_E_L_E_T_ = ''
                    AND EM_CONV.B1_FILIAL = BASE.B1_FILIAL
                    AND EM_CONV.B1_CODPAI = BASE.B1_COD
                    AND EM_CONV.B1_VAORGAN = 'E'
                )
       LEFT JOIN SB1010 BORDADURA
       LEFT JOIN SB5010 SB5_BORD
            ON  (
                    SB5_BORD.D_E_L_E_T_ = ''
                    AND SB5_BORD.B5_FILIAL = BORDADURA.B1_FILIAL
                    AND SB5_BORD.B5_COD = BORDADURA.B1_COD
                )
            ON  (
                    BORDADURA.D_E_L_E_T_ = ''
                    AND BORDADURA.B1_FILIAL = BASE.B1_FILIAL
                    AND BORDADURA.B1_CODPAI = BASE.B1_COD
                    AND BORDADURA.B1_VAORGAN = 'B'
                )
       LEFT JOIN SB1010 ORGANICA
       LEFT JOIN SB5010 SB5_ORG
            ON  (
                    SB5_ORG.D_E_L_E_T_ = ''
                    AND SB5_ORG.B5_FILIAL = ORGANICA.B1_FILIAL
                    AND SB5_ORG.B5_COD = ORGANICA.B1_COD
                )
            ON  (
                    ORGANICA.D_E_L_E_T_ = ''
                    AND ORGANICA.B1_FILIAL = BASE.B1_FILIAL
                    AND ORGANICA.B1_CODPAI = BASE.B1_COD
                    AND ORGANICA.B1_VAORGAN = 'O'
                )
       LEFT JOIN SB1010 FINACLCOMUM
       LEFT JOIN SB5010 SB5_FCC
            ON  (
                    SB5_FCC.D_E_L_E_T_ = ''
                    AND SB5_FCC.B5_FILIAL = FINACLCOMUM.B1_FILIAL
                    AND SB5_FCC.B5_COD = FINACLCOMUM.B1_COD
                )
            ON  (
                    FINACLCOMUM.D_E_L_E_T_ = ''
                    AND FINACLCOMUM.B1_FILIAL = BASE.B1_FILIAL
                    AND FINACLCOMUM.B1_CODPAI = BASE.B1_COD
                    AND FINACLCOMUM.B1_VAORGAN = 'C'
                    AND FINACLCOMUM.B1_VARUVA = 'F'
                    AND FINACLCOMUM.B1_VAFCUVA = 'C'
                )
       LEFT JOIN SB1010 PARAESPUMANTE
       LEFT JOIN SB5010 SB5_PESP
            ON  (
                    SB5_PESP.D_E_L_E_T_ = ''
                    AND SB5_PESP.B5_FILIAL = PARAESPUMANTE.B1_FILIAL
                    AND SB5_PESP.B5_COD = PARAESPUMANTE.B1_COD
                )
            ON  (
                    PARAESPUMANTE.D_E_L_E_T_ = ''
                    AND PARAESPUMANTE.B1_FILIAL = BASE.B1_FILIAL
                    AND PARAESPUMANTE.B1_CODPAI = BASE.B1_COD
                    AND PARAESPUMANTE.B1_VAUVAES = 'S'
                )
WHERE  BASE.D_E_L_E_T_ = ''
       AND BASE.B1_GRUPO = '0400'
       AND BASE.B1_CODPAI = ''
           
           /*
           * versao ateh 21/04/2015:
           ALTER VIEW [dbo].[VA_VFAMILIAS_UVAS] AS 
           SELECT BASE.B1_COD AS COD_BASE,
           RTRIM (BASE.B1_DESC) AS DESCR_BASE,
           BASE.B1_VARUVA AS FINA_COMUM,
           -- CAMPO AINDA NAO CRIADO  BASE.B1_VACORUV AS COR,
           ISNULL(EM_CONV.B1_COD, '') AS COD_EM_CONVERSAO,
           ISNULL(RTRIM (EM_CONV.B1_DESC), '') AS DESCR_EM_CONVERSAO,
           ISNULL(BORDADURA.B1_COD, '') AS COD_BORDADURA,
           ISNULL(RTRIM (BORDADURA.B1_DESC), '') AS DESCR_BORDADURA,
           ISNULL(ORGANICA.B1_COD, '') AS COD_ORGANICA,
           ISNULL(RTRIM (ORGANICA.B1_DESC), '') AS DESCR_ORGANICA,
           ISNULL(FINACLCOMUM.B1_COD, '') AS COD_FINA_CLAS_COMUM,
           ISNULL(RTRIM (FINACLCOMUM.B1_DESC), '') AS DESCR_FINA_CLAS_COMUM,
           ISNULL(PARAESPUMANTE.B1_COD, '') AS COD_PARA_ESPUMANTE,
           ISNULL(RTRIM (PARAESPUMANTE.B1_DESC), '') AS DESCR_PARA_ESPUMANTE,
           BASE.B1_VACOR AS COR,
           BASE.B1_VATTR AS TINTOREA
           FROM   SB1010 BASE
           LEFT JOIN SB1010 EM_CONV
           ON  (
           EM_CONV.D_E_L_E_T_ = ''
           AND EM_CONV.B1_FILIAL = BASE.B1_FILIAL
           AND EM_CONV.B1_CODPAI = BASE.B1_COD
           AND EM_CONV.B1_VAORGAN = 'E'
           )
           LEFT JOIN SB1010 BORDADURA
           ON  (
           BORDADURA.D_E_L_E_T_ = ''
           AND BORDADURA.B1_FILIAL = BASE.B1_FILIAL
           AND BORDADURA.B1_CODPAI = BASE.B1_COD
           AND BORDADURA.B1_VAORGAN = 'B'
           )
           LEFT JOIN SB1010 ORGANICA
           ON  (
           ORGANICA.D_E_L_E_T_ = ''
           AND ORGANICA.B1_FILIAL = BASE.B1_FILIAL
           AND ORGANICA.B1_CODPAI = BASE.B1_COD
           AND ORGANICA.B1_VAORGAN = 'O'
           )
           LEFT JOIN SB1010 FINACLCOMUM
           ON  (
           FINACLCOMUM.D_E_L_E_T_ = ''
           AND FINACLCOMUM.B1_FILIAL = BASE.B1_FILIAL
           AND FINACLCOMUM.B1_CODPAI = BASE.B1_COD
           AND FINACLCOMUM.B1_VAORGAN = 'C'
           AND FINACLCOMUM.B1_VARUVA = 'F'
           AND FINACLCOMUM.B1_VAFCUVA = 'C'
           )
           LEFT JOIN SB1010 PARAESPUMANTE
           ON  (
           PARAESPUMANTE.D_E_L_E_T_ = ''
           AND PARAESPUMANTE.B1_FILIAL = BASE.B1_FILIAL
           AND PARAESPUMANTE.B1_CODPAI = BASE.B1_COD
           AND PARAESPUMANTE.B1_VAUVAES = 'S'
           )
           WHERE  BASE.D_E_L_E_T_ = ''
           AND BASE.B1_GRUPO = '0400'
           AND BASE.B1_CODPAI = ''
           */
           /*
           AND BASE.B1_VAORGAN = 'C'
           AND NOT (
           BASE.B1_VARUVA = 'F'
           AND BASE.B1_VAFCUVA = 'C'
           )
           */
           
           /* versao ate 30/01/2013
           ALTER VIEW [dbo].[VA_FAMILIAS_UVAS] AS 
           SELECT CONVENCIONAL.B1_COD AS CONVENCIONAL,
           CONVENCIONAL.B1_DESC AS DESCR_CONVENCIONAL,
           CONVENCIONAL.B1_VARUVA AS FINA_COMUM,
           ISNULL(EM_CONV.B1_COD, '') AS EM_CONVERSAO,
           ISNULL(EM_CONV.B1_DESC, '') AS DESCR_EM_CONVERSAO,
           ISNULL(BORDADURA.B1_COD, '') AS BORDADURA,
           ISNULL(BORDADURA.B1_DESC, '') AS DESCR_BORDADURA,
           ISNULL(ORGANICA.B1_COD, '') AS ORGANICA,
           ISNULL(ORGANICA.B1_DESC, '') AS DESCR_ORGANICA,
           ISNULL(FINACLCOMUM.B1_COD, '') AS FINA_CLAS_COMUM,
           ISNULL(FINACLCOMUM.B1_DESC, '') AS DESCR_FINA_CLAS_COMUM
           FROM   SB1010 CONVENCIONAL
           LEFT JOIN SB1010 EM_CONV
           ON  (
           EM_CONV.D_E_L_E_T_ = ''
           AND EM_CONV.B1_FILIAL = CONVENCIONAL.B1_FILIAL
           AND EM_CONV.B1_CODPAI = CONVENCIONAL.B1_COD
           AND EM_CONV.B1_VAORGAN = 'E'
           )
           LEFT JOIN SB1010 BORDADURA
           ON  (
           BORDADURA.D_E_L_E_T_ = ''
           AND BORDADURA.B1_FILIAL = CONVENCIONAL.B1_FILIAL
           AND BORDADURA.B1_CODPAI = CONVENCIONAL.B1_COD
           AND BORDADURA.B1_VAORGAN = 'B'
           )
           LEFT JOIN SB1010 ORGANICA
           ON  (
           ORGANICA.D_E_L_E_T_ = ''
           AND ORGANICA.B1_FILIAL = CONVENCIONAL.B1_FILIAL
           AND ORGANICA.B1_CODPAI = CONVENCIONAL.B1_COD
           AND ORGANICA.B1_VAORGAN = 'O'
           )
           LEFT JOIN SB1010 FINACLCOMUM
           ON  (
           FINACLCOMUM.D_E_L_E_T_ = ''
           AND FINACLCOMUM.B1_FILIAL = CONVENCIONAL.B1_FILIAL
           AND FINACLCOMUM.B1_CODPAI = CONVENCIONAL.B1_COD
           AND FINACLCOMUM.B1_VAORGAN = 'C'
           AND FINACLCOMUM.B1_VARUVA = 'F'
           AND FINACLCOMUM.B1_VAFCUVA = 'C'
           )
           WHERE  CONVENCIONAL.D_E_L_E_T_ = ''
           AND CONVENCIONAL.B1_GRUPO = '0400'
           AND CONVENCIONAL.B1_VAORGAN = 'C'
           AND NOT (
           CONVENCIONAL.B1_VARUVA = 'F'
           AND CONVENCIONAL.B1_VAFCUVA = 'C'
           )
           */                                   
