
-- Cooperativa Agroindustrial Nova Alianca Ltda
-- Procedure para listar de forma amigavel dados de Ordens de Servico do modulo de manutencao de ativos.
-- Autor: Robert Koch
-- Data:  ??/05/2023
-- Historico de alteracoes:
--

-- Exemplo de uso:
-- declare @resultado varchar (max);
-- exec protheus.dbo.SP_VISUALIZA_OS '01', '001280', @RET = @resultado output
-- print @resultado
--

CREATE procedure [dbo].[SP_VISUALIZA_OS]
(
	@IN_FILIAL VARCHAR (2),
	@IN_ORDEM VARCHAR (6),
	@RET VARCHAR(MAX) output
) AS
begin

	-- quero migrar para nova procedure, mas falta ajustar a chamada no NaWeb.
	declare @resultado varchar (max);
	exec VA_SP_VISUALIZA_OS @IN_FILIAL, @IN_ORDEM, @resultado output
	set @RET = @resultado
end

/*
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
	SET @RET += '<style>'
	SET @RET +=    '.DivCabecOS {'
	SET @RET +=    'border: 5px;'
	SET @RET +=    'text-align: left;'
	SET @RET +=    'font-family: ''Courier New'';'
	SET @RET +=    'font-size: 15px;'
	SET @RET +=    '}'
	SET @RET +=    '.DivInsumosOS {'
	SET @RET +=    'border: 5px;'
	SET @RET +=    'text-align: left;'
	SET @RET +=    'font-family: ''Courier New'';'
	SET @RET +=    'font-size: 12px;'
	SET @RET +=    '}'
	SET @RET += '</style>'
	SET @RET += '</head>'
	SET @RET += '<body>'

	SET @RET += '<div class="DivCabecOS">'
	SET @RET +=    '<table width="80%" border="1">'
	SET @RET +=       '<tr><th>Ordem de Serviço</th><th>' + @IN_ORDEM + '</th></tr>'
	SET @RET +=       '<tr><th>Solicitacao     </th><th>' + @SOLICITACAO + '</th></tr>'
	SET @RET +=       '<tr><th>Solicitante     </th><th>' + @SOLICITANTE + '</th></tr>'
	SET @RET +=       '<tr><th>Distribuida para</th><th>' + @SS_DISTR_PARA + '</th></tr>'
	SET @RET +=       '<tr><th>Situacao OS     </th><th>' + @SITUACAO + '</th></tr>'
	SET @RET +=       '<tr><th>Bem             </th><th>' + @BEM + ' (' + @DESCR_BEM + ')</th></tr>'
	SET @RET +=       '<tr><th>Centro de custo </th><th>' + @CCUSTO + ' (' + @DESCR_CCUSTO + ')</th></tr>'
	SET @RET +=       '<tr><th>Plano de manut. </th><th>' + @PLANO + ' (' + @DESCR_PLANO + ')</th></tr>'
	SET @RET +=       '<tr><th>Tipo de manut.  </th><th>' + @TIPO_MANUT + ' (Tp.serv. ' + @TIPO_SERV + '-' + @DESCR_SERVICO + ')</th></tr>'
	SET @RET +=       '<tr><th>Observacoes     </th><th>' + @OBS_OS + '</th></tr>'
	SET @RET +=    '</table>'
	SET @RET += '</div>'
	
	-- Cria tabela temporaria de insumos da OS
	SELECT ROW_NUMBER() OVER (ORDER BY TL_FILIAL, TL_ORDEM, TL_REPFIM, TL_TIPOREG, TL_CODIGO, TL_SEQRELA) AS REGISTRO
		, TL_REPFIM, TL_TIPOREG, TL_CODIGO, TL_QUANTID, TL_UNIDADE, TL_DTFIM, TL_LOCAL, TL_LOCALIZ
		, ISNULL (CAST(CAST (TL_OBSERVA AS VARBINARY (8000)) AS VARCHAR (8000)), '') AS TL_OBSERVA
		, B1_DESC, ST1.T1_NOME
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

	SET @RET += '</br></br>'

	-- Monta tabela de insumos da OS
	SET @RET += '<div class="DivInsumosOS">'
	SET @RET += '<table width="80%" border="1" cellspacing="0" cellpadding="0" align="center" style="padding:15px;padding:15px;font-family:''Courier New''">'
	SET @RET +=    '<tr>'
	SET @RET +=       '<th colspan=6 align="center">Insumos <span style="color:dimgrey">[PREVISTOS]</span> x <span style="color:black">[EFETIVADOS]</span></th>'
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
		SET @RET += (SELECT TOP 1 '<tr' + CASE TL_REPFIM WHEN 'S' THEN ' style="color:black"' ELSE ' style="color:dimgrey"' END + '>'
				+ '<th>' + CASE WHEN TL_TIPOREG = 'M' THEN 'MO' ELSE 'PC' END + '</th>'
				+ '<th>' + RTRIM (TL_CODIGO) + '</th>'
				+ '<th>' + RTRIM (CASE WHEN TL_TIPOREG = 'M' THEN T1_NOME ELSE B1_DESC END) + '</th>'
				+ '<th align=right>' + RTRIM (TL_QUANTID) + '</th>'
				+ '<th>' + RTRIM (TL_UNIDADE) + '</th>'
				+ '<th>' + dbo.VA_DTOC (TL_DTFIM) + '</th>'
				+ '<th>' + TL_LOCAL + CASE WHEN TL_LOCALIZ = '' THEN '' ELSE ' (' + RTRIM (TL_LOCALIZ) + ')' END + '</th>'
				+ '<th>' + RTRIM (TL_OBSERVA) + '</th>'
		FROM #STL
		ORDER BY REGISTRO)
		SET @RET += '</tr>'

		-- REMOVE O REGISTRO DA TABELA DE GRUPOS
		DELETE #STL WHERE REGISTRO = (SELECT MIN (REGISTRO) FROM #STL)
	END
	DROP TABLE #STL


	SET @RET += '</table>'
	SET @RET += '</div>'

--				SET @RET += '<details>'
--				SET @RET += '    <summary>Details</summary>'
--				SET @RET += '    Something small enough to escape casual notice.'
--				SET @RET += '</details>'


	SET @RET += '</body></html>'
--	print @RET

-- TESTES:
declare @resultado varchar (max);
exec protheus.dbo.SP_VISUALIZA_OS '01', '037052', @RET = @resultado output
print @resultado

--SELECT TOP 10 * FROM VA_VDADOS_OS

END
*/
