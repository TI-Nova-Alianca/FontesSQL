SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Cooperativa Nova Alianca Ltda
-- View para buscar chaves de doctos.eletronicos (NF-e/CT-e/...) pendentes de revalidacao junto ao orgao emissor.
-- Autor: Robert Koch
-- Data:  13/10/2020
-- Historico de alteracoes:
-- 28/07/2022 - Robert - Incluida coluna ZZX_PRTCAN - GLPI 12384
--

ALTER VIEW [dbo].[VA_VDFES_A_REVALIDAR] AS

SELECT ZZX.R_E_C_N_O_
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
WHERE D_E_L_E_T_ = ''
AND ZZX_CHAVE  != ''
AND ZZX_CHAVE  != 'Nao se aplica'
AND ZZX_LAYOUT != ''

-- Os web services nao respondem chaves emitidas ha mais de 90 dias
AND DATEDIFF (DAY, CAST (ZZX_EMISSA + ' ' + '00:00' AS DATETIME), CURRENT_TIMESTAMP) <= 90
GO
