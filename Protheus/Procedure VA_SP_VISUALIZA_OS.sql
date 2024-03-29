
-- Cooperativa Agroindustrial Nova Alianca Ltda
-- Descricao: Procedure para listar de forma amigavel dados de Ordens de Servico do modulo de manutencao de ativos.
--            Criada inicialmente para ser chamada a partir do NaWeb
-- Autor....: Robert Koch
-- Data.....: ??/05/2023

-- Historico de alteracoes:
-- 16/07/2023 - Robert - Acrescentada tabela de pedidos de compra relacionados
-- 07/08/2023 - Robert - Mostra em vermelho se o manutentor estiver como USA CALENDARIO (pois assim nao envia ao APP)
-- 06/02/2024 - Robert - Insumos realizados passam a aparecem em verde (semelhante ao APP)
--

-- Exemplo de uso:
-- declare @resultado varchar (max);
-- exec protheus.dbo.VA_SP_VISUALIZA_OS '01', '029178', @RET = @resultado output
-- print @resultado
--

CREATE procedure [dbo].[VA_SP_VISUALIZA_OS]
(
	@IN_FILIAL VARCHAR (2),
	@IN_ORDEM VARCHAR (6),
	@RET VARCHAR(MAX) output
) AS
BEGIN
	SET NOCOUNT ON
	SET @RET = ''

	-- DECLARA VARIAVEIS PARA GUARDAR DADOS DA O.S.
	DECLARE @SITUACAO      VARCHAR (11)
	DECLARE @PLANO         VARCHAR (6)
	DECLARE @DESCR_PLANO   VARCHAR (40)
	DECLARE @TIPO_MANUT    VARCHAR (3)
	DECLARE @BEM           VARCHAR (16)
	DECLARE @DESCR_BEM     VARCHAR (60)
	DECLARE @CCUSTO        VARCHAR (16)
	DECLARE @DESCR_CCUSTO  VARCHAR (60)
	DECLARE @TIPO_SERV     VARCHAR (6)
	DECLARE @DESCR_SERVICO VARCHAR (60)
	DECLARE @OBS_OS        VARCHAR (MAX)
	DECLARE @SOLICITACAO   VARCHAR (6)
	DECLARE @SOLICITANTE   VARCHAR (30)
	DECLARE @SS_DISTR_PARA VARCHAR (36)


--	select X3_CAMPO, X3_TIPO, X3_TAMANHO FROM SX3010 WHERE X3_CAMPO IN ('TJ_SERVICO','T4_NOME','TQB_USUARI')
	SELECT TOP 1  @SITUACAO      = ISNULL (RTRIM (SITUACAO), '')
				, @PLANO         = ISNULL (RTRIM (PLANO), '')
				, @DESCR_PLANO   = ISNULL (RTRIM (DESCR_PLANO), '')
				, @TIPO_MANUT    = ISNULL (RTRIM (TIPO_MANUT), '')
				, @BEM           = ISNULL (RTRIM (BEM), '')
				, @DESCR_BEM     = ISNULL (RTRIM (DESCR_BEM), '')
				, @CCUSTO        = ISNULL (RTRIM (CCUSTO), '')
				, @DESCR_CCUSTO  = ISNULL (RTRIM (DESCR_CCUSTO), '')
				, @TIPO_SERV     = ISNULL (RTRIM (TIPO_SERV), '')
				, @DESCR_SERVICO = ISNULL (RTRIM (DESCR_SERVICO), '')
				, @OBS_OS        = ISNULL (RTRIM (OBSERVACOES), '')
				, @SOLICITACAO   = ISNULL (RTRIM (SOLICITACAO), '')
				, @SOLICITANTE   = ISNULL (RTRIM (SOLICITANTE), '')
				, @SS_DISTR_PARA = ISNULL (RTRIM (SS_DISTRIBUIDA_PARA), '')
	FROM VA_VDADOS_OS
	WHERE FILIAL = @IN_FILIAL
	AND ORDEM = @IN_ORDEM
	
	SET @RET += '<!DOCTYPE html><html>'
	SET @RET += '<head>'
	SET @RET += '<meta charset="1252"/><title>Consulta OS</title>'

	-- Definicao de estilos CSS
	SET @RET += '<style>'

	-- Um DIV para dados de cabecalho da OS
	SET @RET +=    '.DivCabecOS {'
	SET @RET +=    'border: 5px;'
	SET @RET +=    'text-align: left;'
	SET @RET +=    'font-family: ''Courier New'';'
	SET @RET +=    'font-size: 15px;'
	SET @RET +=    'margin-bottom: 30px;'  -- Margem abaixo do DIV para nao emendar com o proximo
	SET @RET +=    '}'

	-- Um DIV para dados de insumos da OS
	SET @RET +=    '.DivInsumosOS {'
	SET @RET +=    'border: 5px;'
	SET @RET +=    'text-align: left;'
	SET @RET +=    'font-family: ''Courier New'';'
	SET @RET +=    'font-size: 12px;'
	SET @RET +=    'margin-bottom: 30px;'  -- Margem abaixo do DIV para nao emendar com o proximo
	SET @RET +=    '}'

	-- Um DIV para dados de pedidos de compra associados a esta OS
	SET @RET +=    '.DivPedCompraOS {'
	SET @RET +=    'border: 5px;'
	SET @RET +=    'text-align: left;'
	SET @RET +=    'font-family: ''Courier New'';'
	SET @RET +=    'font-size: 12px;'
	SET @RET +=    'margin-bottom: 30px;'  -- Margem abaixo do DIV para nao emendar com o proximo
	SET @RET +=    '}'

	-- Estilo default para tabelas
	SET @RET +=    'table, th, td {'
	SET @RET +=    '	border: 1px solid black;'
	SET @RET +=    '	border-collapse: collapse;'
	SET @RET +=    '}'

	-- Estilo default para cabecalhos de tabelas
	SET @RET +=    'th {'
	SET @RET +=    '   background-color: lightgray;'
	SET @RET +=    '}'

	-- Estilo default espacamento dentro das celulas de tabelas
	SET @RET +=    'th, td {'
	SET @RET +=    '   padding: 5px;'
	SET @RET +=    '   padding-top: 2px;'
	SET @RET +=    '   padding-bottom: 2px;'
	SET @RET +=    '}'

	SET @RET += '</style>'
	SET @RET += '</head>'
	SET @RET += '<body>'


	-- Cria tabela (no HTML) com dados de cabelalho da OS
	SET @RET += '<div class="DivCabecOS">'
--	SET @RET +=    '<table width="80%" border="1">'
	SET @RET +=    '<table>'
	SET @RET +=       '<tr><th>Ordem de Serviço</th><th>' + @IN_ORDEM + '</th></tr>'
	SET @RET +=       '<tr><td>Solicitacao     </td><td>' + @SOLICITACAO + '</td></tr>'
	SET @RET +=       '<tr><td>Solicitante     </td><td>' + @SOLICITANTE + '</td></tr>'
	SET @RET +=       '<tr><td>Distribuida para</td><td>' + @SS_DISTR_PARA + '</td></tr>'
	SET @RET +=       '<tr><td>Situacao OS     </td><td>' + @SITUACAO + '</td></tr>'
	SET @RET +=       '<tr><td>Bem             </td><td>' + @BEM + ' (' + @DESCR_BEM + ')</td></tr>'
	SET @RET +=       '<tr><td>Centro de custo </td><td>' + @CCUSTO + ' (' + @DESCR_CCUSTO + ')</td></tr>'
	SET @RET +=       '<tr><td>Plano de manut. </td><td>' + @PLANO + ' (' + @DESCR_PLANO + ')</td></tr>'
	SET @RET +=       '<tr><td>Tipo de manut.  </td><td>' + @TIPO_MANUT + ' (Tp.serv. ' + @TIPO_SERV + '-' + @DESCR_SERVICO + ')</td></tr>'
	SET @RET +=       '<tr><td>Observacoes     </td><td <span style="width: 410px; word-wrap: break-word">' + @OBS_OS + '</span></td></tr>'
	SET @RET +=    '</table>'
	SET @RET += '</div>'
	

	-- Cria tabela temporaria de insumos da OS
	SELECT ROW_NUMBER() OVER (ORDER BY TL_FILIAL, TL_ORDEM, TL_REPFIM, TL_TIPOREG, TL_CODIGO, TL_SEQRELA) AS REGISTRO
		, TL_REPFIM, TL_TIPOREG, TL_CODIGO, TL_QUANTID, TL_UNIDADE, TL_DTFIM, TL_LOCAL, TL_LOCALIZ
		, ISNULL (CAST(CAST (TL_OBSERVA AS VARBINARY (8000)) AS VARCHAR (8000)), '') AS TL_OBSERVA
		, B1_DESC, ST1.T1_NOME, STL.TL_USACALE
	INTO #STL
	FROM STL010 STL
		LEFT JOIN SB1010 SB1
			ON (SB1.D_E_L_E_T_ = ''
			AND SB1.B1_FILIAL = '  '
			AND SB1.B1_COD = STL.TL_CODIGO)
		LEFT JOIN ST1010 ST1
			ON (ST1.D_E_L_E_T_ = ''
			AND ST1.T1_FILIAL = '  '
			AND ST1.T1_CODFUNC = STL.TL_CODIGO)
	WHERE STL.D_E_L_E_T_ = ''
	AND STL.TL_FILIAL = @IN_FILIAL
	AND STL.TL_ORDEM = @IN_ORDEM

	-- sp_helpindex STL010
	-- SELECT * FROM SX3010 WHERE X3_ARQUIVO = 'STL'
	-- TL_DESTINO = A=Apoio;S=Substituição;T=Troca
	-- TL_REPFIM = 'S' = efetivado


	-- Monta tabela (no HTML) com dados dos insumos da OS
	SET @RET += '<div class="DivInsumosOS">'
--	SET @RET += '<table width="80%" border="1" cellspacing="0" cellpadding="0" align="center" style="padding:15px;padding:15px;font-family:''Courier New''">'
	SET @RET += '<table>'
	SET @RET +=    '<tr>'
	SET @RET +=       '<th colspan=8 align="center">Insumos <span style="color:dimgrey">[PREVISTOS]</span> x <span style="color:green">[EFETIVADOS]</span></th>'
	SET @RET +=    '</tr>'
	SET @RET +=    '<tr>'
	SET @RET +=	      '<th>Tipo</th>'
	SET @RET +=	      '<th>Codigo</th>'
	SET @RET +=	      '<th>Descricao</th>'
	SET @RET +=	      '<th>Quant</th>'
	SET @RET +=	      '<th>UM</th>'
	SET @RET +=	      '<th>Data</th>'
	SET @RET +=	      '<th>AX/Ender.</th>'
	SET @RET +=	      '<th>Obs</th>'
	SET @RET +=    '</tr>'

	-- Percorre a tabela temporaria acrescentando os itens ao HTML de retorno.
	WHILE EXISTS (SELECT TOP 1 NULL FROM #STL)
	BEGIN
		SET @RET += (SELECT TOP 1 '<tr' + CASE TL_REPFIM WHEN 'S' THEN ' style="color:green; font-weight: bold;"' ELSE ' style="color:dimgrey"' END + '>'
				+ '<td>' + CASE WHEN TL_TIPOREG = 'M' THEN 'MO' ELSE 'PC' END + '</td>'
				+ '<td>' + RTRIM (TL_CODIGO) + '</td>'
				+ '<td>' + RTRIM (CASE WHEN TL_TIPOREG = 'M'
									THEN T1_NOME + CASE WHEN TL_USACALE = 'S' THEN ' <span style="color:red">(usa calendario)</span>' ELSE '' END
									ELSE B1_DESC
								  END) + '</td>'
				+ '<td align=right>' + RTRIM (TL_QUANTID) + '</td>'
				+ '<td>' + RTRIM (TL_UNIDADE) + '</td>'
				+ '<td>' + dbo.VA_DTOC (TL_DTFIM) + '</td>'
				+ '<td>' + TL_LOCAL + CASE WHEN TL_LOCALIZ = '' THEN '' ELSE ' (' + RTRIM (TL_LOCALIZ) + ')' END + '</td>'
				+ '<td>' + RTRIM (TL_OBSERVA) + '</td>'
		FROM #STL
		ORDER BY REGISTRO)
		SET @RET += '</tr>'

		-- REMOVE O REGISTRO DA TABELA DE GRUPOS
		DELETE #STL WHERE REGISTRO = (SELECT MIN (REGISTRO) FROM #STL)
	END
	DROP TABLE #STL
	SET @RET +=    '</table>'
	SET @RET += '</div>'


	-- Cria tabela temporaria de pedidos de compra associados a esta OS
	-- Aqui seria bom manter consistencia com a consulta do programa U_MNT453PC do Protheus.
	SELECT ROW_NUMBER() OVER (ORDER BY C7_FILIAL, C7_NUM, C7_ITEM) AS REGISTRO
		, SC7.C7_NUM
		, SC7.C7_ITEM
		, SC7.C7_PRODUTO
		, SC7.C7_DESCRI
		, SC7.C7_QUANT
		, SC7.C7_QUJE
		, SC7.C7_UM
		, ISNULL ((SELECT STRING_AGG (D1_DOC, ',')
			FROM SD1010 SD1
			WHERE SD1.D_E_L_E_T_ = ''
			AND SD1.D1_FILIAL = SC7.C7_FILIAL
			AND SD1.D1_FORNECE = SC7.C7_FORNECE
			AND SD1.D1_LOJA = SC7.C7_LOJA
			AND SD1.D1_PEDIDO = SC7.C7_NUM
			AND SD1.D1_ITEMPC = SC7.C7_ITEM)
			, '') AS NF
		, SA2.A2_NOME
	 INTO #SC7
	 FROM SC7010 SC7
		, SA2010 SA2
	WHERE SC7.D_E_L_E_T_ = ''
	AND SC7.C7_FILIAL    = @IN_FILIAL
	AND SC7.C7_OP        like @IN_ORDEM + '%'
	--AND SC7.C7_QUANT     > SC7.C7_QUJE
	AND SC7.C7_RESIDUO  != 'S'
	AND SA2.D_E_L_E_T_   = ''
	AND SA2.A2_FILIAL    = '  '
	AND SA2.A2_COD       = SC7.C7_FORNECE
	AND SA2.A2_LOJA      = SC7.C7_LOJA
	ORDER BY C7_NUM, C7_PRODUTO

	-- Monta tabela (no HTML) de pedidos de compra associados a esta OS
	SET @RET += '<div class="DivPedCompraOS">'
	SET @RET += '<table>'
	SET @RET +=    '<tr>'
	SET @RET +=       '<th colspan=8 align="center">Pedidos de compra relacionados</th>'
	SET @RET +=    '</tr>'
	SET @RET +=    '<tr>'
	SET @RET +=	      '<th>Pedido</th>'
	SET @RET +=	      '<th>Produto</th>'
	SET @RET +=	      '<th>Descricao</th>'
	SET @RET +=	      '<th>Quant</th>'
	SET @RET +=	      '<th>Qt.entregue</th>'
	SET @RET +=	      '<th>UM</th>'
	SET @RET +=	      '<th>NF</th>'
	SET @RET +=	      '<th>Nome forn</th>'
	SET @RET +=    '</tr>'

	-- Percorre a tabela temporaria acrescentando os itens ao HTML de retorno.
	WHILE EXISTS (SELECT TOP 1 NULL FROM #SC7)
	BEGIN
		SET @RET += (SELECT TOP 1 '<tr>'
				+ '<td>' + C7_NUM + '/' + C7_ITEM + '</td>'
				+ '<td>' + RTRIM (C7_PRODUTO) + '</td>'
				+ '<td>' + RTRIM (C7_DESCRI) + '</td>'
				+ '<td align=right>' + RTRIM (C7_QUANT) + '</td>'
				+ '<td align=right>' + RTRIM (C7_QUJE) + '</td>'
				+ '<td>' + RTRIM (C7_UM) + '</td>'
				+ '<td>' + RTRIM (NF) + '</td>'
				+ '<td>' + RTRIM (A2_NOME) + '</td>'
		FROM #SC7
		ORDER BY REGISTRO)
		SET @RET += '</tr>'

		-- REMOVE O REGISTRO DA TABELA DE GRUPOS
		DELETE #SC7 WHERE REGISTRO = (SELECT MIN (REGISTRO) FROM #SC7)
	END
	DROP TABLE #SC7
	SET @RET += '</table>'
	SET @RET += '</div>'


--				SET @RET += '<details>'
--				SET @RET += '    <summary>Details</summary>'
--				SET @RET += '    Something small enough to escape casual notice.'
--				SET @RET += '</details>'


	SET @RET += '</body></html>'
--	print @RET

END



