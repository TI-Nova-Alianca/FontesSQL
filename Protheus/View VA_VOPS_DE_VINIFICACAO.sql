

ALTER VIEW [dbo].[VA_VOPS_DE_VINIFICACAO] AS (

	-- Cooperativa Agroindustrial Nova Alianca Ltda
	-- View para identificar OPs de vinificacao (que consomem uva). Geralmente para uso em outras consultas.
	-- Autor: Robert Koch
	-- Data:  17/01/2024
	-- Historico de alteracoes:
	--

	SELECT
		SD3.D3_FILIAL AS FILIAL
	   ,SD3.D3_OP AS OP
	   ,MIN(SD3.D3_EMISSAO) AS PRIMEIRO_MOVTO
	   ,MAX(SD3.D3_EMISSAO) AS ULTIMO_MOVTO
	FROM SD3010 SD3
	WHERE SD3.D_E_L_E_T_ = ''
	AND SD3.D3_ESTORNO = ''
	AND SD3.D3_CF LIKE 'RE%'
	AND SD3.D3_GRUPO = '0400'
	GROUP BY SD3.D3_FILIAL, SD3.D3_OP
)

