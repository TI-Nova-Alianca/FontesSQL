SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[v_wms_entrada]
AS
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para integracao de cadastro com o FullWMS.
-- Autor: Robert Koch
-- Data:  26/11/2014
-- Historico de alteracoes:
-- 22/01/2015 - Robert - Passa a exportar o campo D3_VAETIQ como 'placa' em lugar do D3_OP
-- 28/06/2015 - Robert - Incluida tabela ZAB (devolucoes/cancelamentos)
-- 07/08/2015 - Robert - Incluida tabela SC2; busca qt.perda quando campo C2_VAOPESP = 'R'.
-- 13/08/2015 - Robert - Filtra D1_QUANT > 0
-- 28/05/2018 - Robert - Nao le mais tabelas SD1 (notas transf. de filiais) e ZAB (controle devolucoes).
-- 16/08/2018 - Robert - Busca etiquetas de entrada no alm.02 geradas por NF de entrada
--                     - Busca somente itens ja exportados para o FullWMS (v_wms_item)
-- 22/10/2018 - Robert - Busca etiquetas de entrada no Alm.02 geradas pela tabela ZAG
-- 31/10/2018 - Robert - Busca etiq. para logistica no SD3 e ZA1. Nao mais no SD3, SB1 e SC2.
-- 16/08/2020 - Robert - Calcula 30 dias retroativos em vez de buscar ultimo SB9 (ganho de performance).
-- 22/08/2020 - Robert - Desabilitada leitura de NF de compra para AX 02 (nao vai entrar em producao por enquanto)
--                     - Quando transf. pelo ZAG, identifica 'empresa' destino cfe. alm.destino.
-- 24/10/2020 - Robert - Filtra ZAG_EMIS e ZA1_DATA somente do ultimo mes.
-- 14/09/2022 - Robert - Melhorias entradas por transf.cadastradas no ZAG.
--                     - Etiqueta deve constar na tabela tb_wms_etiquetas
-- 16/09/2022 - Robert - Melhorias leitura ZAG.
-- 23/09/2022 - Robert - Passa a enviar entradas do ZAG como tpdoc=6
-- 31/10/2022 - Robert - mandar DESCFOR vazio (testes-transf.ZAG nao aparecem no Full)
-- 04/11/2022 - Robert - mais testes transf.ZAG

WITH C
AS
(
	SELECT
		RTRIM('ZA1' + ZA1_FILIAL + ZA1_CODIGO) AS entrada_id
		,RTRIM('SD3' + D3_FILIAL + D3_DOC + D3_OP + D3_COD + D3_NUMSEQ) AS entrada_id_antigo
		,RTRIM(D3_DOC) AS nrodoc
		,'' AS serie
		,1 AS linha
		,ZA1_CODIGO AS codfor
		,'' AS descfor
		,RTRIM(ZA1_PROD) AS coditem
		,ZA1_QUANT AS qtde
		,'6' AS tpdoc  -- 1=compra/entrada;2=devolucao de cliente
		,RTRIM(ZA1.ZA1_CODIGO) AS placa
		,SUBSTRING(D3_OP, 1, 8) AS lote
		,1 AS empresa  -- 1=Logistica;2-Almox.ME/insumos
		,1 AS cd
	FROM SD3010 SD3
		,ZA1010 ZA1
	WHERE SD3.D_E_L_E_T_ = ''
	AND D3_FILIAL = '01'
	AND D3_OP != ''
	AND SD3.D3_ESTORNO != 'S'
	AND D3_TM = '010' -- MELHORA PERFORMANCE --> AND D3_CF LIKE 'PR%'
	AND D3_LOCAL = '11'
	AND D3_EMISSAO > (SELECT FORMAT (DATEADD (MONTH, -1, CURRENT_TIMESTAMP), 'yyyyMMdd'))
	AND ZA1.D_E_L_E_T_ = ''
	AND ZA1.ZA1_FILIAL = SD3.D3_FILIAL
	AND ZA1.ZA1_OP = SD3.D3_OP
	AND ZA1.ZA1_IMPRES = 'S'
	AND ZA1.ZA1_CODIGO = SD3.D3_VAETIQ

	UNION ALL

	-- ENTRADAS POR SOLICITACAO MANUAL DE TRANSFERENCIA
	SELECT
		RTRIM('ZA1' + ZA1_FILIAL + ZA1_CODIGO) AS entrada_id
		,'SD301B76WZAMIE12911601001   0151           x193S0' AS entrada_id_antigo  --RTRIM('ZA1' + ZA1_FILIAL + ZA1_CODIGO) AS entrada_id_antigo
		,'ZAG' + rtrim (ZAG.ZAG_DOC) AS nrodoc
		,'' AS serie
		,1 AS linha
		,ZA1_CODIGO AS codfor
		,'' as descfor  --'AX' + ZAG.ZAG_ALMORI + ' (' + rtrim (ZA1_USRINC) + ')' AS descfor
		,RTRIM(ZAG.ZAG_PRDORI) AS coditem
		,ZAG.ZAG_QTDSOL AS qtde
		,'6' AS tpdoc  -- 1=compra/entrada;2=devolucao de cliente;3-Ajuste de entrada;4-Cancelamento nota fiscal de saída;5-Cancelamento de pedido separado;
		,ZA1_CODIGO as placa -- Precisa manter igual ao campo 'codfor'
		,substring (tb_wms_etiquetas.lote, 1, 8) as lote
		,1 AS empresa
		,1 AS cd
	FROM ZAG010 ZAG
		, ZA1010 ZA1
		, tb_wms_etiquetas
	WHERE ZAG.D_E_L_E_T_ = ''
	AND ZAG.ZAG_FILIAL = '  '
	AND ZAG.ZAG_FILDST = '01'  -- POR ENQUANTO, APENAS NA MATRIZ.
	AND ZAG.ZAG_EMIS >= '20220904'  -- DATA DE INICIO DA INTEGRACAO
	AND ZAG.ZAG_EMIS > (SELECT FORMAT (DATEADD (MONTH, -1, CURRENT_TIMESTAMP), 'yyyyMMdd'))
	AND ZA1.ZA1_DATA > (SELECT FORMAT (DATEADD (MONTH, -1, CURRENT_TIMESTAMP), 'yyyyMMdd'))
	AND ZA1.D_E_L_E_T_ = ''
	AND ZA1.ZA1_FILIAL = ZAG.ZAG_FILDST
	AND ZA1.ZA1_IDZAG = ZAG.ZAG_DOC
	AND ZA1.ZA1_IMPRES = 'S'
	and tb_wms_etiquetas.id = ZA1_CODIGO
	)
SELECT *
FROM C

-- Se ja consta na tabela de retorno, nao posso mais mostrar na view.
WHERE NOT EXISTS (SELECT *
	FROM tb_wms_entrada T
	WHERE T.entrada_id = C.entrada_id)
and NOT EXISTS (SELECT *
	FROM tb_wms_entrada T
	WHERE T.entrada_id = C.entrada_id_antigo)

-- Se a etiqueta nao foi enviada para o Full, nao adianta mostrar na view.
and exists (select *
			from tb_wms_etiquetas
			where id = codfor)

GO
