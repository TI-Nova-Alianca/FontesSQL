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
--

WITH C
AS
(

-- Cargas do modulo de OMS
SELECT
		'DAK' + DAK_FILIAL + DAK_COD + DAK.DAK_SEQCAR AS saida_id
	   ,'20' + DAK.DAK_FILIAL + DAK.DAK_COD AS nrodoc
	   ,'1' AS linha
	   ,dbo.VA_DTOC(DAK.DAK_DATA) AS dtemissao
	   ,dbo.VA_DTOC(DAK.DAK_DATA) AS dtentrega
	   ,'NOVA ALIANCA' AS nomecli
	   --,'88612486000160' AS cnpj
	   ,CASE DAK.DAK_FILIAL WHEN '01' THEN '88612486000160' WHEN '16' THEN '88612486001646' ELSE '' END AS cnpj
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
	   ,CASE WHEN SC9.C9_LOCAL IN ('01') THEN '1' ELSE
	   CASE WHEN SC9.C9_LOCAL IN ('02', '07') THEN '2' ELSE '' END END AS empresa
	   ,1 AS cd
	   ,DAK_COD AS num_carga
	FROM DAK010 DAK
		,DAI010 DAI
		,SC9010 SC9
		,SC6010 SC6
		,SB1010 SB1
		,SC5010 SC5
	WHERE DAK.D_E_L_E_T_ = ''
	AND DAK.DAK_FILIAL = '01'
	AND DAK.DAK_FEZNF = '2'
	AND DAK.DAK_VAFULL = 'S'
	AND DAI.D_E_L_E_T_ = ''
	AND DAI.DAI_FILIAL = DAK.DAK_FILIAL
	AND DAI.DAI_COD = DAK.DAK_COD
	AND DAI.DAI_SEQCAR = DAK.DAK_SEQCAR
	AND SC9.D_E_L_E_T_ = ''
	AND C9_FILIAL = DAK.DAK_FILIAL
	AND SC9.C9_PEDIDO = DAI.DAI_PEDIDO
	--AND C9_LOCAL = '01'
	AND SC9.C9_NFISCAL = ''
	AND SC5.D_E_L_E_T_ = ''
	AND SC5.C5_FILIAL = C9_FILIAL
	AND SC5.C5_NUM = SC9.C9_PEDIDO
	AND SC6.D_E_L_E_T_ = ''
	AND SC6.C6_FILIAL = SC9.C9_FILIAL
	AND SC6.C6_NUM = SC9.C9_PEDIDO
	AND SC6.C6_ITEM = SC9.C9_ITEM
	AND SB1.D_E_L_E_T_ = ''
	AND SB1.B1_FILIAL = '  '
	AND SB1.B1_COD = SC9.C9_PRODUTO
	AND SB1.B1_VAFULLW = 'S'
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

/* Implantacao do Full nos AX 02 e 07 foi postergada por tempo indefinido
	union ALL

	-- etiquetas de entrada por NF, transferencia entre producao e almox, etc.
	SELECT
		'ZAG' + ZAG_FILORI + ZAG.ZAG_DOC AS saida_id
--	   ,CASE WHEN ZAG_OP = '' THEN ZAG_DOC ELSE substring (ZAG_OP, 1, 10) END AS nrodoc  -- TENTA AGRUPAR POR OP, CASO TENHA ESSE CAMPO INFORMADO (tamanho.maximo=10)
	   ,ZAG_DOC AS nrodoc  -- TENTA AGRUPAR POR OP, CASO TENHA ESSE CAMPO INFORMADO (tamanho.maximo=10)
	   ,'1' AS linha
	   ,dbo.VA_DTOC(ZAG_EMIS) AS dtemissao
	   ,dbo.VA_DTOC(ZAG_EMIS) AS dtentrega
	   ,CASE WHEN ZAG_OP = ''
			THEN 'AX_' + ZAG.ZAG_ALMDST
		ELSE CASE SB1_OP.B1_VALINEN WHEN '001' THEN 'ZEGLA'  -- deve permanecer igual ao nome da 'doca' no FullWMS
	                    WHEN '002' THEN 'ISO'  -- deve permanecer igual ao nome da 'doca' no FullWMS
						WHEN '003' THEN 'BAG'  -- deve permanecer igual ao nome da 'doca' no FullWMS
						WHEN '004' THEN 'TP1000'  -- deve permanecer igual ao nome da 'doca' no FullWMS
						WHEN '005' THEN 'TP200'  -- deve permanecer igual ao nome da 'doca' no FullWMS
						ELSE ''
						END 
					END AS nomecli
	   ,CASE ZAG.ZAG_FILDST WHEN '01' THEN '88612486000160' WHEN '16' THEN '88612486001646' ELSE '' END AS cnpj
	   ,'ESTR.GERARDO SANTIN GUARESE' AS endentrega
	   ,'LAGOA BELA' AS bairro
	   ,'FLORES DA CUNHA' AS cidade
	   ,'RS' AS uf
	   ,'95270000' AS cep
	   ,'' AS obs
	   ,'' AS codtransp
	   ,ZAG_DOC AS placa
	   ,SB1.B1_P_BRT * ZAG.ZAG_QTDSOL AS pesototal  -- CAMPO AGRUPADOR (OBRIGATORIO)
	   ,0 AS valortotal
       ,'S' AS geraonda  -- Para o AX02 queremos gerar onda automaticamente
	   ,RTRIM(ZAG.ZAG_PRDORI) AS coditem
	   ,ZAG.ZAG_QTDSOL AS qtde
	   ,'' AS descr_compl
	   ,'1' as tipo_pedido
	   ,CASE WHEN ZAG.ZAG_ALMORI IN ('01') THEN '1' ELSE
	   CASE WHEN ZAG.ZAG_ALMORI IN ('02', '07') THEN '2' ELSE '' END END AS empresa
	   ,1 AS cd
	   ,ZAG.ZAG_DOC AS num_carga
	FROM ZAG010 ZAG
	     LEFT JOIN SC2010 SC2
		      LEFT JOIN SB1010 SB1_OP
		         ON (SB1_OP.D_E_L_E_T_ = ''
				 AND SB1_OP.B1_FILIAL = '  '
				 AND SB1_OP.B1_COD = SC2.C2_PRODUTO)
		    ON (SC2.D_E_L_E_T_ = ''
			AND SC2.C2_FILIAL = ZAG.ZAG_FILORI
			AND SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN + SC2.C2_ITEMGRD = ZAG.ZAG_OP),
	     SB1010 SB1
	WHERE ZAG.D_E_L_E_T_ = '' AND ZAG.ZAG_FILIAL = '  '
	AND ZAG.ZAG_FILORI = '01' AND ZAG.ZAG_ALMORI IN ('02', '07')
--	AND ZAG.ZAG_FILORI = '01' AND ZAG.ZAG_ALMORI IN ('01','02', '07')
	AND ZAG.ZAG_EXEC = '' -- TRANSFERENCIA AINDA NAO EXECUTADA
	AND SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '  ' AND SB1.B1_COD = ZAG.ZAG_PRDORI
*/
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
   --,0 AS prioridade
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

-- Se o item nao foi enviado para o Full, nao adianta mostrar na view.
AND EXISTS (SELECT
		*
	FROM v_wms_item I
	WHERE I.coditem = C.coditem)
GO
