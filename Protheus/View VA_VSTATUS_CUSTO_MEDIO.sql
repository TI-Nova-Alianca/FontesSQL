USE [protheus]
GO

/****** Object:  View [dbo].[VA_VSTATUS_CUSTO_MEDIO]    Script Date: 13/10/2021 09:01:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados gerais do custo medio das filiais.
-- Autor: Robert Koch
-- Data:  12/05/2015
-- Historico de alteracoes:
-- 11/12/2017 - Robert - Ignora registros com o campo CV8_SBPROC preenchido (sobprocessos).
-- 14/05/2021 - Robert - Busca MV_ULMES no SX6 pois agora temos no banco de dados.
-- 13/10/2021 - Robert - Passa a ler SYS_COMPANY e nao mais VA_SM0. Incluidos SBJ, SBK e ultima virada (GLPI 11065).
--

ALTER VIEW [dbo].[VA_VSTATUS_CUSTO_MEDIO] AS

SELECT SM0.M0_CODIGO AS EMPRESA,
       M0_CODFIL AS FILIAL,
	   (SELECT RTRIM (X6_CONTEUD)
	   FROM SX6010
	   WHERE D_E_L_E_T_ = ''
	   AND X6_FIL = M0_CODFIL
	   AND X6_VAR = 'MV_ULMES') AS MV_ULMES,
       ISNULL(
           (
               SELECT MAX(B9_DATA)
               FROM   SB9010 SB9
               WHERE  SB9.D_E_L_E_T_ = ''
                      AND SB9.B9_FILIAL = SM0.M0_CODFIL
           ),
           ''
       ) AS ULT_FECHTO_SB9,
       ISNULL(
           (
               SELECT MAX(BJ_DATA)
               FROM   SBJ010 SBJ
               WHERE  SBJ.D_E_L_E_T_ = ''
                      AND SBJ.BJ_FILIAL = SM0.M0_CODFIL
           ),
           ''
       ) AS ULT_FECHTO_SBJ,
       ISNULL(
           (
               SELECT MAX(BK_DATA)
               FROM   SBK010 SBK
               WHERE  SBK.D_E_L_E_T_ = ''
                      AND SBK.BK_FILIAL = SM0.M0_CODFIL
           ),
           ''
       ) AS ULT_FECHTO_SBK,
       ISNULL(RECALC.CV8_DATA, '') AS DT_ULT_RECALC,
       ISNULL(RECALC.CV8_HORA, '') AS HR_ULT_RECALC,
       ISNULL(RECALC.CV8_USER, '') AS USER_ULT_RECALC,
       ISNULL(VIRADA.CV8_DATA, '') AS DT_ULT_VIRADA,
       ISNULL(VIRADA.CV8_HORA, '') AS HR_ULT_VIRADA,
       ISNULL(VIRADA.CV8_USER, '') AS USER_ULT_VIRADA
FROM   SYS_COMPANY SM0
       LEFT JOIN CV8010 RECALC -- ENCONTRA O FIM DA ULTIMA EXECUCAO COMPLETA DO RECALCULO DO CUSTO MEDIO
            ON  (
                    RECALC.D_E_L_E_T_ = ''
                    AND RECALC.CV8_FILIAL = SM0.M0_CODFIL
                    AND RECALC.CV8_PROC = 'MATA330'
                    AND RECALC.CV8_SBPROC = ''  -- para ignorar subprocessos
                    AND RECALC.CV8_INFO = '2'
                    AND RECALC.CV8_MSG NOT LIKE 'Sub-Processo%'
                    AND RECALC.CV8_DATA + RECALC.CV8_HORA + CAST(RECALC.R_E_C_N_O_ AS VARCHAR) 
                        >= (
                            SELECT MAX(
                                       INICIO.CV8_DATA + INICIO.CV8_HORA + CAST(INICIO.R_E_C_N_O_ AS VARCHAR)
                                   )
                            FROM   CV8010 INICIO
                            WHERE  INICIO.D_E_L_E_T_ = ''
                                   AND INICIO.CV8_FILIAL = RECALC.CV8_FILIAL
                                   AND INICIO.CV8_PROC = RECALC.CV8_PROC
                                   AND INICIO.CV8_SBPROC = ''  -- para ignorar subprocessos
                                   AND INICIO.CV8_INFO = '1'
                        )
                )
       LEFT JOIN CV8010 VIRADA -- ENCONTRA O FIM DA ULTIMA EXECUCAO DA VIRADA DE SALDOS
            ON  (
                    VIRADA.D_E_L_E_T_ = ''
                    AND VIRADA.CV8_FILIAL = SM0.M0_CODFIL
                    AND VIRADA.CV8_PROC = 'MATA280'
                    AND VIRADA.CV8_SBPROC = ''  -- para ignorar subprocessos
                    AND VIRADA.CV8_INFO = '2'
                    AND VIRADA.CV8_MSG NOT LIKE 'Sub-Processo%'
                    AND VIRADA.CV8_DATA + VIRADA.CV8_HORA + CAST(VIRADA.R_E_C_N_O_ AS VARCHAR) 
                        >= (
                            SELECT MAX(
                                       INICIO.CV8_DATA + INICIO.CV8_HORA + CAST(INICIO.R_E_C_N_O_ AS VARCHAR)
                                   )
                            FROM   CV8010 INICIO
                            WHERE  INICIO.D_E_L_E_T_ = ''
                                   AND INICIO.CV8_FILIAL = VIRADA.CV8_FILIAL
                                   AND INICIO.CV8_PROC = VIRADA.CV8_PROC
                                   AND INICIO.CV8_SBPROC = ''  -- para ignorar subprocessos
                                   AND INICIO.CV8_INFO = '1'
                        )
                )
WHERE  SM0.D_E_L_E_T_ = ''


GO


