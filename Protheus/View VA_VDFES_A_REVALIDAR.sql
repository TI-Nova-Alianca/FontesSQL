

-- Cooperativa Nova Alianca Ltda
-- View para buscar chaves de doctos.eletronicos (NF-e/CT-e/...) pendentes de revalidacao junto ao orgao emissor.
-- Autor: Robert Koch
-- Data:  13/10/2020
-- Historico de alteracoes:
-- 28/07/2022 - Robert - Incluida coluna ZZX_PRTCAN - GLPI 12384
-- 14/11/2023 - Robert - Desconsidera chaves que jah tenham protocolo de cancelamento.
-- 15/11/2023 - Robert - Criadas colunas SIGLA e ORIGEM.
--

ALTER VIEW [dbo].[VA_VDFES_A_REVALIDAR] AS

WITH ESTADOS AS (
	SELECT '11' AS CODIGO, 'RO' AS SIGLA UNION ALL
	SELECT '12'          , 'AC'          UNION ALL
	SELECT '13'          , 'AM'          UNION ALL
	SELECT '14'          , 'RR'          UNION ALL
	SELECT '15'          , 'PA'          UNION ALL
	SELECT '16'          , 'AP'          UNION ALL
	SELECT '17'          , 'TO'          UNION ALL
	SELECT '21'          , 'MA'          UNION ALL
	SELECT '22'          , 'PI'          UNION ALL
	SELECT '23'          , 'CE'          UNION ALL
	SELECT '24'          , 'RN'          UNION ALL
	SELECT '25'          , 'PB'          UNION ALL
	SELECT '26'          , 'PE'          UNION ALL
	SELECT '27'          , 'AL'          UNION ALL
	SELECT '28'          , 'SE'          UNION ALL
	SELECT '29'          , 'BA'          UNION ALL
	SELECT '31'          , 'MG'          UNION ALL
	SELECT '32'          , 'ES'          UNION ALL
	SELECT '33'          , 'RJ'          UNION ALL
	SELECT '35'          , 'SP'          UNION ALL
	SELECT '41'          , 'PR'          UNION ALL
	SELECT '42'          , 'SC'          UNION ALL
	SELECT '43'          , 'RS'          UNION ALL
	SELECT '50'          , 'MS'          UNION ALL
	SELECT '51'          , 'MT'          UNION ALL
	SELECT '52'          , 'GO'          UNION ALL
	SELECT '53'          , 'DF'
)

SELECT ESTADOS.SIGLA
	, 'ZZX' AS ORIGEM  -- TENHO INTENCAO DE LER TAMBEM DO PAINEL xml NO FUTURO
	, ZZX.R_E_C_N_O_
	, ZZX.ZZX_FILIAL
	, ZZX.ZZX_CHAVE
	, ZZX.ZZX_LAYOUT
	, ZZX_VERSAO
	, ZZX.ZZX_EMISSA
	, ZZX.ZZX_DUCC
	, ZZX.ZZX_HUCC
	, DATEDIFF (HOUR, CAST (ZZX_DUCC + ' ' + ZZX_HUCC AS DATETIME), CURRENT_TIMESTAMP) AS HORAS_DESDE_ULTIMA_REVALIDACAO
	, ZZX.ZZX_RETSEF
	, ZZX.ZZX_PROTOC
	, ZZX.ZZX_PRTCAN
FROM ZZX010 ZZX
	LEFT JOIN ESTADOS
	ON ESTADOS.CODIGO = SUBSTRING (ZZX.ZZX_CHAVE, 1, 2)
WHERE D_E_L_E_T_ = ''
AND ZZX_CHAVE  != ''
AND ZZX_CHAVE  != 'Nao se aplica'
AND ZZX_LAYOUT != ''

-- Os web services nao respondem chaves emitidas ha mais de 90 dias
AND DATEDIFF (DAY, CAST (ZZX_EMISSA + ' ' + '00:00' AS DATETIME), CURRENT_TIMESTAMP) <= 90

-- Se jah consta como cancelada (e com protocolo de cancelamento), nao tem mais razao de revalidar.
AND NOT (ZZX_RETSEF = '101' AND ZZX_PRTCAN != '')


