

ALTER VIEW [dbo].[VA_VRATEIOS_CC_AUX_PARA_PRODUTIVOS] AS 

-- Cooperativa Agroindustrial Nova Alianca Ltda
-- View para buscar dados de rateios contabeis de CC auxiliares para CC produtivos (G`LPI 13934)
-- Criada com base no programa VA_XLS51.PRW
-- Autor: Robert Koch
-- Data:  19/07/2021
-- Historico de alteracoes:
--

-- ENCONTRA LOTES DE LCTOS ONLINE CONTENDO RATEIOS
WITH LOTES_ONLINE AS 
(
	SELECT CT2_FILIAL
		,CT2_DATA
		,CT2.CT2_CCC
		,CT2_CCD AS CC_DESTINO
		,CT2_VALOR
		,CT2_LOTE
		,CT2_SBLOTE
		,CT2_DOC
		,CT2_LINHA
	FROM CT2010 CT2
	WHERE D_E_L_E_T_ = ''
	AND CT2_DATA <= '20190831'  -- ULTIMO MES EM QUE USAMOS RATEIO ONLINE, NAO ADIANTA BUSCAR PERIODO POSTERIOR.
	AND ((CT2_CREDIT = '' AND CT2_DEBITO LIKE '701011001%')
	  OR (CT2_DEBITO = '' AND CT2_CREDIT LIKE '701011001%'))  -- RATEIO ONLINE SEMPRE TEM UMA PERNA DO LCTO VAZIA
	AND CT2_ROTINA = 'CTBA102'
	AND CT2.CT2_LOTE != '008840'  -- CONTABILIZACAO GERADA PELO CUSTO MEDIO
	
	-- VOU DESCONSIDERAR ESTES LOTES POR QUE PARECEM AJUSTES (TEM ORIGENS E DESTINOS
	-- ESTRANHOS E NAO FECHA NENHUMA SOMA DE ORIGENS PARA CHEGAR A UM DESTINO)
	AND NOT (CT2_FILIAL = '01'
		AND CT2_DATA = '20181231'
		AND CT2_LOTE = '000001'
		AND CT2_SBLOTE = '001'
		AND CT2_DOC = '000114')
	AND NOT (CT2_FILIAL = '01'
		AND CT2_DATA = '20180831'
		AND CT2_LOTE = '000001'
		AND CT2_SBLOTE = '001'
		AND CT2_DOC = '000071')
	AND NOT (CT2_FILIAL = '01'
		AND CT2_DATA = '20170630'
		AND CT2_LOTE = '000001'
		AND CT2_SBLOTE = '001'
		AND CT2_DOC = '000075')
)

-- MONTA UMA CTE COM OS RATEIOS ONLINE
, RATEIO_ONLINE AS 
(
	SELECT 'ONLINE' AS TIPO_RATEIO
		,CT2_FILIAL
		,CT2_DATA
		,(SELECT TOP 1 CT2_CCC
			FROM LOTES_ONLINE L2
			WHERE L2.CT2_FILIAL = LOTES_ONLINE.CT2_FILIAL
			AND L2.CT2_DATA     = LOTES_ONLINE.CT2_DATA
			AND L2.CT2_LOTE     = LOTES_ONLINE.CT2_LOTE
			AND L2.CT2_SBLOTE   = LOTES_ONLINE.CT2_SBLOTE
			AND L2.CT2_DOC      = LOTES_ONLINE.CT2_DOC
			AND L2.CT2_LINHA    < LOTES_ONLINE.CT2_LINHA
			AND CT2_CCC        != ''
			ORDER BY L2.CT2_LINHA DESC)
		AS CC_ORIGEM
		,CC_DESTINO
		,CT2_VALOR
		,CT2_LOTE
		,CT2_SBLOTE
		,CT2_DOC
		,CT2_LINHA
	FROM LOTES_ONLINE
	WHERE CT2_CCC = ''  -- REMOVE A LINHA DE LCTO A CREDITO, POIS SERVIU APENAS PARA A SUBSTRING QUE BUSCA O 'CC_ORIGEM'
)

-- MONTA UMA CTE COM OS RATEIOS OFFLINE
, RATEIO_OFFLINE AS
(
	SELECT 'OFFLINE' AS TIPO_RATEIO
	   ,CT2_FILIAL
	   ,CT2_DATA
	   ,CT2_CCC AS CC_ORIGEM
	   ,CT2_CCD AS CC_DESTINO
	   ,CT2_VALOR
	   ,CT2_LOTE
	   ,CT2_SBLOTE
	   ,CT2_DOC
	   ,CT2_LINHA
	FROM CT2010
	WHERE D_E_L_E_T_ = ''
	AND CT2_DATA    >= '20190930'  -- PRIMEIRO MES EM QUE USAMOS RATEIO OFFLINE
	AND CT2_DEBITO  LIKE '701011001%'
	AND CT2_CREDIT  LIKE '701011001%'
	AND CT2_ROTINA  = 'CTBA280'
)

-- A PARTIR DE UMA UNION DOS RATEIOS ONLINE + OFFLINE, ACRESCENTA AS DESCRICOES DOS CC.
, TODOS_RATEIOS AS
(
	SELECT TIPO_RATEIO
	   ,CT2_FILIAL AS FILIAL
	   ,CT2_DATA AS DT_MOVTO
	   ,CC_ORIGEM
	   ,CTT_O.CTT_DESC01 AS DESC_CC_ORIG
	   ,CC_DESTINO
	   ,CTT_D.CTT_DESC01 AS DESC_CC_DEST
	   ,CT2_VALOR AS VALOR
	   ,CT2_LOTE
	   ,CT2_SBLOTE
	   ,CT2_DOC
	   ,CT2_LINHA
	FROM (SELECT *
			FROM RATEIO_ONLINE 
			UNION ALL
			SELECT *
			FROM RATEIO_OFFLINE
		) AS C
	LEFT JOIN CTT010 CTT_O
		ON (CTT_O.D_E_L_E_T_ = ''
		AND CTT_O.CTT_FILIAL = '  '
		AND CTT_O.CTT_CUSTO  = C.CC_ORIGEM)
	LEFT JOIN CTT010 CTT_D
		ON (CTT_D.D_E_L_E_T_ = ''
		AND CTT_D.CTT_FILIAL = '  '
		AND CTT_D.CTT_CUSTO  = C.CC_DESTINO)
)
SELECT *
FROM TODOS_RATEIOS

