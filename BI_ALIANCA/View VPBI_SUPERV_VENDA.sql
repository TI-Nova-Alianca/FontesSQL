USE [BI_ALIANCA]
GO

/****** Object:  View [dbo].[VPBI_SUPERV_VENDA]    Script Date: 20/04/2022 17:33:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VPBI_SUPERV_VENDA]  -- SUPERVISORES DE REPRESENTANTES

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados de supervisores / coordenadores de vendas, para uso no PowerBI
-- Autor: Robert Koch
-- Data:  03/2022
-- Historico de alteracoes:
--

AS 
SELECT ZAE_CCORD
	, ZAE_NOME
	,ZAE_PERC
	,CASE WHEN D_E_L_E_T_ = '*' THEN 'S' ELSE 'N' END AS DELETADO
FROM protheus.dbo.ZAE010
--WHERE D_E_L_E_T_ = ''
WHERE ZAE_FILIAL = '  '
GO


