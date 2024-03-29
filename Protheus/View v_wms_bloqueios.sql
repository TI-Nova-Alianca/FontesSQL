

ALTER VIEW [dbo].[v_wms_bloqueios]
AS
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para integracao de bloqueios de estoque com o FullWMS.
-- Autor: Robert Koch
-- Data:  26/09/2023
-- Historico de alteracoes:
-- 18/02/2024 - Robert - Criado campo ZBH_RESULT
--

WITH C
AS
(
	SELECT
		ZBH_IDOPER as bloqueio_id
		,ZBH_PRODUT as cod_item
		,ZBH_LOTE as lote
		,ZBH_OPER as operacao
		,ZBH_POSF as endereco
		,ZBH_QUANT as quant
		,1 AS empresa
		,1 AS cd
	FROM ZBH010 ZBH
	WHERE ZBH.D_E_L_E_T_  = ''
	  AND ZBH.ZBH_FILIAL  = '01'  -- Nao usamos FullWMS nas filiais. Ainda assim, Protheus vai ter obrigacao de gerar IDs unicos, independente de filial.
	  AND ZBH.ZBH_RESULT  = ''
	  
	  
	  -- por enquanto nao quero habilitar em producao
	  AND DB_NAME () = 'protheus_teste'
)
SELECT *
FROM C

-- Se ja consta na tabela de retorno, nao posso mais mostrar na view.
WHERE NOT EXISTS (SELECT *
	FROM tb_wms_bloqueios T
	WHERE T.bloqueio_id = C.bloqueio_id)


