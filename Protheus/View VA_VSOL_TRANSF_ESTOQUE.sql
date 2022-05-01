SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- Cooperativa Nova Alianca Ltda
-- View para buscar dados de solicitacoes de transferencias de estoque feitas ao Protheus via web service.
-- Autor: Robert Koch
-- Data:  07/07/2021
-- Historico de alteracoes:
-- 07/07/2021 - Robert - Deixa de usar tabela customizada e passa a usar a tabela padrao SYS_USR.
-- 27/04/2022 - Robert - Testes fixos com almox.X B1_VAFULLW removidos (criei um usuario 'fullwms' no Protheus)
--

ALTER VIEW [dbo].[VA_VSOL_TRANSF_ESTOQUE] AS 
SELECT ZAG.*

	  ,ISNULL ((SELECT [GX0004_PRODUTO_DESCRICAO] FROM [dbo].[GX0004_PRODUTOS]
	  WHERE [GX0004_PRODUTO_CODIGO] = ZAG.ZAG_PRDORI) , '') as  ZAG_PRDORIDESC

	   ,ISNULL ((SELECT [GX0004_PRODUTO_DESCRICAO] FROM [dbo].[GX0004_PRODUTOS]
	  WHERE [GX0004_PRODUTO_CODIGO] = ZAG.ZAG_PRDDST) , '') as  ZAG_PRDDSTDESC

      ,ISNULL ((SELECT NOMES = STRING_AGG (UPPER (RTRIM (U.USR_CODIGO)), ',')
                  FROM ZZU010 ZZU, SYS_USR U
                 WHERE ZZU.D_E_L_E_T_ = ''
                   AND ZZU.ZZU_FILIAL = '  '
                   AND U.USR_ID = ZZU.ZZU_USER
                   AND ZZU.ZZU_GRUPO = 'A' + ZAG.ZAG_ALMORI)
          , '')
--	   + CASE WHEN ZAG.ZAG_ALMORI IN ('01', '11') AND SB1.B1_VAFULLW = 'S'
--            THEN ',FULLWMS'
--            ELSE ''
--			END
       AS LIBERADORES_ALMORI

      ,ISNULL ((SELECT NOMES = STRING_AGG (UPPER (RTRIM (U.USR_CODIGO)), ',')
                  FROM ZZU010 ZZU, SYS_USR U
                 WHERE ZZU.D_E_L_E_T_ = ''
                   AND ZZU.ZZU_FILIAL = '  '
                   AND U.USR_ID = ZZU.ZZU_USER
                   AND ZZU.ZZU_GRUPO = 'A' + ZAG.ZAG_ALMDST)
          , '')
--	   + CASE WHEN ZAG.ZAG_ALMDST IN ('01', '11') AND SB1.B1_VAFULLW = 'S'
--            THEN ',FULLWMS'
--            ELSE ''
--			END
       AS LIBERADORES_ALMDST
, ''  -- POR ENQUANTO NAO VAI SER USADO
  AS LIBERADORES_PCP
, ''  -- POR ENQUANTO NAO VAI SER USADO
  AS LIBERADORES_QUALIDADE


FROM ZAG010 ZAG, SB1010 SB1
WHERE ZAG.D_E_L_E_T_ = ''
AND SB1.D_E_L_E_T_ = ''
AND SB1.B1_FILIAL = '  '
AND SB1.B1_COD = ZAG.ZAG_PRDORI
GO
