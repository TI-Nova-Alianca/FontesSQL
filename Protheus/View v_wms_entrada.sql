


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
-- 25/11/2022 - Robert - Eliminado campo ENTRADA_ID_ANTIGO, que continha RTRIM('SD3' + D3_FILIAL + D3_DOC + D3_OP + D3_COD + D3_NUMSEQ)
--                     - Leitura tb_wms_etiquetas passa a validar 'lote' e 'status'.
--                     - Removidas algumas validacoes desnecessarias (melhoria performance)
-- 12/03/2023 - Robert - Campo ZAG_SEQ passa a fazer parte da chave 
-- 04/03/2024 - Robert - Alteracao geral para melhoria de performance (GLPI 15030)
--

WITH C
AS
(
	SELECT
		RTRIM('ZA1' + ZA1_FILIAL + ZA1_CODIGO) AS entrada_id
		, case when ZA1.ZA1_IDZAG != ''
			then 'ZAG' + rtrim (ZAG.ZAG_DOC + ZAG.ZAG_SEQ)
			else
			case when ZA1.ZA1_OP != ''
				then ZA1.ZA1_OP --RTRIM (SD3.D3_DOC)
				else ''
				end
			end
			AS nrodoc
		,'' AS serie
		,1 AS linha
		,ZA1_CODIGO AS codfor
		, case when ZA1.ZA1_IDZAG != ''
			then 'AX' + ZAG.ZAG_ALMORI + ' (' + rtrim (ZA1_USRINC) + ')'
			else ''
			end
			as descfor
		,RTRIM(ZA1_PROD) AS coditem
		,ZA1_QUANT AS qtde
		,'6' AS tpdoc  -- 1=compra/entrada;2=devolucao de cliente;3-Ajuste de entrada;4-Cancelamento nota fiscal de saída;5-Cancelamento de pedido separado;
		,ZA1_CODIGO as placa -- Precisa manter igual ao campo 'codfor'
		,substring (tb_wms_etiquetas.lote, 1, 8) as lote
		,1 AS empresa
		,1 AS cd
	FROM tb_wms_etiquetas
		, ZA1010 ZA1
--		left join SD3010 SD3
--			on (SD3.D_E_L_E_T_  = ''
--				and SD3.D3_FILIAL   = ZA1.ZA1_FILIAL
--				and SD3.D3_OP		= ZA1.ZA1_OP
--				and SD3.D3_VAETIQ	= ZA1.ZA1_CODIGO
--				and SD3.D3_ESTORNO != 'S'
				--and SD3.D3_TM       = '010'
--				and SD3.D3_CF LIKE 'PR%'
--				)
		left join ZAG010 ZAG
			on (ZAG.D_E_L_E_T_     = ''
				AND ZAG.ZAG_FILIAL = '  '
				AND ZAG.ZAG_DOC    = substring (ZA1.ZA1_IDZAG, 1, 10)
				AND ZAG.ZAG_SEQ    = substring (ZA1.ZA1_IDZAG, 11, 2)
				AND ZAG.ZAG_FILDST = '01'  -- POR ENQUANTO, APENAS NA MATRIZ.
				AND ZAG.ZAG_FILDST = ZA1.ZA1_FILIAL
				AND ZAG.ZAG_EMIS  >= '20220904'  -- DATA DE INICIO DA INTEGRACAO
				)

	-- Se a etiqueta nao foi enviada para o Full, nao adianta mostrar na view.
	where tb_wms_etiquetas.lote != ''  -- Full aceita a 'entrada', mas nao aceita a 'etiqueta' se estiver sem lote.
	and tb_wms_etiquetas.status = 'S'  -- Protheus gera 'N' e o Full muda para 'S' se aceitar a etiqueta.
	AND ZA1.ZA1_CODIGO = tb_wms_etiquetas.id
	AND ZA1.D_E_L_E_T_ = ''
	AND ZA1.ZA1_FILIAL = '01'  -- POR ENQUANTO, APENAS NA MATRIZ.
	AND ZA1.ZA1_DATA  >= '20210101'  -- NAO EXPORTAR datas antigas por que usavamos uma chave diferente no ENTRADA_ID
	AND ZA1.ZA1_DATA  >= (SELECT FORMAT (DATEADD (MONTH, -3, CURRENT_TIMESTAMP), 'yyyyMMdd'))  -- Somente dos ultimos dias
	AND ZA1.ZA1_FULLW  = '1'  -- LIBERADA PARA ENVIO AO FULLWMS
	)
SELECT *
FROM C

-- Se ja consta na tabela de retorno, nao posso mais mostrar na view.
WHERE NOT EXISTS (SELECT *
	FROM tb_wms_entrada T
	WHERE T.entrada_id = C.entrada_id)


