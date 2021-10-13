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
--

ALTER VIEW [dbo].[VA_VSTATUS_CUSTO_MEDIO] AS

SELECT SM0.M0_CODIGO AS EMPRESA,
       M0_CODFIL AS FILIAL,
       ISNULL(FIM.CV8_DATA, '') AS DT_ULT_RECALC,
       ISNULL(FIM.CV8_HORA, '') AS HR_ULT_RECALC,
       ISNULL(FIM.CV8_USER, '') AS USER_ULT_RECALC,
       ISNULL(
           (
               SELECT MAX(B9_DATA)
               FROM   SB9010 SB9
               WHERE  SB9.D_E_L_E_T_ = ''
                      AND SB9.B9_FILIAL = SM0.M0_CODFIL
           ),
           ''
       ) AS ULT_FECHTO_SB9,
	   (SELECT RTRIM (X6_CONTEUD)
	   FROM SX6010
	   WHERE D_E_L_E_T_ = ''
	   AND X6_FIL = M0_CODFIL
	   AND X6_VAR = 'MV_ULMES') AS MV_ULMES
FROM   VA_SM0 SM0
       LEFT JOIN CV8010 FIM -- ENCONTRA O FIM DA ULTIMA EXECUCAO COMPLETA DO RECALCULO DO CUSTO MEDIO
            ON  (
                    FIM.D_E_L_E_T_ = ''
                    AND FIM.CV8_FILIAL = SM0.M0_CODFIL
                    AND FIM.CV8_PROC = 'MATA330'
                    AND FIM.CV8_SBPROC = ''  -- para ignorar subprocessos
                    AND FIM.CV8_INFO = '2'
                    AND FIM.CV8_MSG NOT LIKE 'Sub-Processo%'
                    AND FIM.CV8_DATA + FIM.CV8_HORA + CAST(FIM.R_E_C_N_O_ AS VARCHAR) 
                        >= (
                            SELECT MAX(
                                       INICIO.CV8_DATA + INICIO.CV8_HORA + CAST(INICIO.R_E_C_N_O_ AS VARCHAR)
                                   )
                            FROM   CV8010 INICIO
                            WHERE  INICIO.D_E_L_E_T_ = ''
                                   AND INICIO.CV8_FILIAL = FIM.CV8_FILIAL
                                   AND INICIO.CV8_PROC = FIM.CV8_PROC
                                   AND INICIO.CV8_SBPROC = ''  -- para ignorar subprocessos
                                   AND INICIO.CV8_INFO = '1'
                        )
                )
WHERE  SM0.D_E_L_E_T_ = ''


GO


