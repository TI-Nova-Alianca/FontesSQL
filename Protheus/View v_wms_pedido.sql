USE [protheus]
GO

/****** Object:  View [dbo].[v_wms_pedido]    Script Date: 10/05/2022 11:43:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[v_wms_pedido]
AS
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para integracao com o FullWMS - solicitacoes de separacao de materiais
-- Autor: Robert Koch
-- Data:  20/11/2014
-- Historico de alteracoes:
-- 05/07/2018 - Robert - Leitura da tabela ZAG (para almox. de embalagens/insumos)
-- 02/08/2018 - Robert - Envia o ZAG_OP como 'placa' para ajudar a agrupar por OP no FullWMS.
-- 19/10/2018 - Robert - Item deve existir na view v_wms_item.
--                     - Gera nome da linha de envase na coluna cliente para o AX 02.
-- 26/10/2018 - Robert - coluna 'geraonda' vai com S para ax.02 e permanece com 'N' para ax.01
-- 03/12/2019 - Robert - Tratamento para exportar CNPJ cliente para filial 01 e 16
-- 04/12/2019 - Claudia - Alterada a prioridade de 0 para 99, conforme verificado em testes da fullsoft
-- 26/11/2020 - Robert  - Gera solicitacao de separacao do AX01, quando originada no ZAG
-- 11/04/2022 - Robert  - Verificava se o item constava na view v_wms_item (muito lento). Criadas aqui validacoes equivalentes (GLPI 11905)
--                      - Removida leitura do AX 02 e 07 (jah encontrava-se comentariada)
--                      - Removidas tabelas SC5 e SC6 (estavam sem utilizacao)
--

WITH C
AS
(

-- Cargas do modulo de OMS
SELECT
		'DAK' + DAK_FILIAL + DAK_COD + DAK.DAK_SEQCAR AS saida_id
	   ,'20' + DAK.DAK_FILIAL + DAK.DAK_COD AS nrodoc
	   ,'1' AS linha
	   ,substring (DAK.DAK_DATA, 7, 2) + '/' + substring (DAK.DAK_DATA,5, 2) + '/' + substring (DAK.DAK_DATA, 1, 4) AS dtemissao
	   ,substring (DAK.DAK_DATA, 7, 2) + '/' + substring (DAK.DAK_DATA,5, 2) + '/' + substring (DAK.DAK_DATA, 1, 4) AS dtentrega
	   ,'NOVA ALIANCA' AS nomecli
	   ,'88612486000160' as cnpj  --CASE DAK.DAK_FILIAL WHEN '01' THEN '88612486000160' WHEN '16' THEN '88612486001646' ELSE '' END AS cnpj
	   ,'ESTR.GERARDO SANTIN GUARESE' AS endentrega
	   ,'LAGOA BELA' AS bairro
	   ,'FLORES DA CUNHA' AS cidade
	   ,'RS' AS uf
	   ,'95270000' AS cep
	   ,'' AS obs
	   ,DAK.DAK_VATRAN AS codtransp
	   ,DAK.DAK_COD AS placa
	   ,DAK.DAK_PESO AS pesototal  -- CAMPO AGRUPADOR (OBRIGATORIO)
	   ,DAK.DAK_VALOR AS valortotal
       ,'N' AS geraonda
	   ,RTRIM(C9_PRODUTO) AS coditem
	   ,SUM(C9_QTDLIB) AS qtde
	   ,'' AS descr_compl
	   ,'' as tipo_pedido
	   --,CASE WHEN SC9.C9_LOCAL IN ('01') THEN '1' ELSE CASE WHEN SC9.C9_LOCAL IN ('02', '07') THEN '2' ELSE '' END END AS empresa
	   ,'1' AS empresa
	   ,1 AS cd
	   ,DAK_COD AS num_carga
	FROM DAK010 DAK
		,DAI010 DAI
		,SC9010 SC9
	--	,SC6010 SC6
		,SB1010 SB1
	--	,SC5010 SC5
	WHERE DAK.D_E_L_E_T_ = ''
	AND DAK.DAK_FILIAL = '01'
	AND DAK.DAK_FEZNF  = '2'
	AND DAK.DAK_VAFULL = 'S'
	AND DAI.D_E_L_E_T_ = ''
	AND DAI.DAI_FILIAL = DAK.DAK_FILIAL
	AND DAI.DAI_COD    = DAK.DAK_COD
	AND DAI.DAI_SEQCAR = DAK.DAK_SEQCAR
	AND SC9.D_E_L_E_T_ = ''
	AND SC9.C9_FILIAL  = DAK.DAK_FILIAL
	AND SC9.C9_PEDIDO  = DAI.DAI_PEDIDO
	AND SC9.C9_LOCAL   = '01'
	AND SC9.C9_NFISCAL = ''
--	AND SC9.C9_QTDLIB  > 0
--	AND SC5.D_E_L_E_T_ = ''
--	AND SC5.C5_FILIAL = C9_FILIAL
--	AND SC5.C5_NUM = SC9.C9_PEDIDO
--	AND SC6.D_E_L_E_T_ = ''
--	AND SC6.C6_FILIAL = SC9.C9_FILIAL
--	AND SC6.C6_NUM = SC9.C9_PEDIDO
--	AND SC6.C6_ITEM = SC9.C9_ITEM
	AND SB1.D_E_L_E_T_ = ''   -- Procura manter mesmos criterios da view v_wms_item
	AND SB1.B1_FILIAL = '  '  -- Procura manter mesmos criterios da view v_wms_item
	AND SB1.B1_VAFULLW = 'S'  -- Procura manter mesmos criterios da view v_wms_item
	AND SB1.B1_MSBLQL != '1'  -- Procura manter mesmos criterios da view v_wms_item
	AND SB1.B1_VAPLLAS > 0    -- Procura manter mesmos criterios da view v_wms_item
	AND SB1.B1_VAPLCAM > 0    -- Procura manter mesmos criterios da view v_wms_item
	AND SB1.B1_COD = SC9.C9_PRODUTO
	GROUP BY DAK_FILIAL
		,DAK_COD
		,DAK.DAK_SEQCAR
		,DAK.DAK_DATA
		,DAK.DAK_DATENT
		,DAK.DAK_VATRAN
		,DAK.DAK_COD
		,DAK.DAK_PESO
		,DAK.DAK_VALOR
		,SC9.C9_PRODUTO
		,SC9.C9_LOCAL
		,SC9.C9_FILIAL
)

SELECT
	saida_id
   ,nrodoc
   ,'' AS serie
   ,linha
   ,'' AS nrreserva
   ,dtemissao
   ,dtentrega
   ,nomecli
   ,cnpj
   ,endentrega
   ,bairro
   ,cidade
   ,uf
   ,cep
   ,obs
   ,codtransp
   ,placa
   ,pesototal
   ,valortotal
   ,geraonda
   ,coditem
   ,qtde
   ,1 AS display
   ,1 AS emb_padrao
   ,'1' AS tpdoc
   ,99 AS prioridade
   ,descr_compl
   ,tipo_pedido
   ,'' AS obs_item
   ,'' AS kanban
   ,'' AS etiq_esp
   ,'3' AS lote_misto
   ,'' AS rota
   ,'' AS um_cliente
   ,'' AS setor_kanban
   ,'' AS obs_frac
   ,'' AS tpdoc_cli
   ,empresa
   ,cd
   ,num_carga
FROM C

-- Se jah consta na tabela, eh por que o FullWMS jah visualizou e, portanto, nao precisa mais aparecer na view.
WHERE NOT EXISTS (SELECT
		*
	FROM tb_wms_pedidos T
	WHERE T.saida_id = C.saida_id)
/*
-- Se o item nao foi enviado para o Full, nao adianta mostrar na view.
AND EXISTS (SELECT
		*
	FROM v_wms_item I
	WHERE I.coditem = C.coditem)
*/
GO


