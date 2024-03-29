
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados de supervisores / coordenadores de vendas, para uso no PowerBI
-- Autor: Robert Koch
-- Data:  03/2022
-- Historico de alteracoes:
--

ALTER VIEW [dbo].[VPBI_SUPERV_VENDA]  -- SUPERVISORES DE REPRESENTANTES
AS 
SELECT ZAE_CCORD
	, ZAE_NOME
	,ZAE_PERC
	,CASE WHEN D_E_L_E_T_ = '*' THEN 'S' ELSE 'N' END AS DELETADO
FROM protheus.dbo.ZAE010
--WHERE D_E_L_E_T_ = ''
WHERE ZAE_FILIAL = '  '

