--SET NOCOUNT OFF

-- Descricao: Rastreamento de movimentacao de estiquetas de estoque
-- Autor....: Robert Koch
-- Data.....: 24/08/2023 (inicio)
--
-- Historico de alteracoes:
-- 18/09/2023 - Robert - Verifica se o recebimento jah foi autorizado no FullWMS
-- 18/10/2023 - Robert - Primeira versao com retorno em HTML
--

ALTER PROCEDURE [dbo].[VA_SP_RASTREAR_ETIQUETA]
(
	@IN_FILIAL    VARCHAR (2)
	,@IN_ETIQ     VARCHAR (10)
	,@RET VARCHAR(MAX) output
) AS
BEGIN
	SET NOCOUNT ON
	SET @RET = ''
	DECLARE @CONTINUA   VARCHAR (1) = 'S'
	DECLARE @MSG        VARCHAR (MAX)
	DECLARE @OP         VARCHAR (14)
	DECLARE @QUANTIDADE FLOAT
	DECLARE @TIPO_ETIQ  VARCHAR (40)
	DECLARE @VAI_PARA_FULLW VARCHAR (1)
	DECLARE @TIPOOP     VARCHAR (25)
	DECLARE @NFENTR     VARCHAR (9)
	DECLARE @D5NSEQ     VARCHAR (6)
	DECLARE @ZAG_DOC    VARCHAR (12)
	DECLARE @PRODUTO    VARCHAR (15)
	DECLARE @DESCPROD   VARCHAR (250)
	DECLARE @EMISETIQ   VARCHAR (8)
	DECLARE @DTAPONT    VARCHAR (8)
	DECLARE @ALMAPONT   VARCHAR (2)
	DECLARE @ALMTRSAI   VARCHAR (2)
	DECLARE @ALMTRENT   VARCHAR (2)
	DECLARE @DTTRANSF   VARCHAR (8)
	DECLARE @ZAG_USRINC VARCHAR (20)
	DECLARE @ZAG_UAUTO  VARCHAR (20)
	DECLARE @ZAG_UAUTD  VARCHAR (20)
	DECLARE @ZAG_MOTIVO VARCHAR (MAX)
	DECLARE @ZAG_EXEC   VARCHAR (30)

	SET @RET += '<!DOCTYPE html><html>'
	SET @RET += '<head>'
	SET @RET += '<meta charset="1252"/><title>Consulta etiqueta</title>'
	SET @RET += '</head>'
	SET @RET += '<body>'

	SELECT TOP 1
		 @OP		  = ZA1_OP
		,@QUANTIDADE  = ZA1.ZA1_QUANT
		,@NFENTR	  = ZA1.ZA1_DOCE
		,@D5NSEQ	  = ZA1.ZA1_D5NSEQ
		,@ZAG_DOC	  = ZA1.ZA1_IDZAG
		,@PRODUTO	  = ZA1.ZA1_PROD
		,@EMISETIQ	  = ZA1.ZA1_DATA
		,@DESCPROD	  = SB1.B1_DESC
		,@DTAPONT	  = ISNULL (SD3_APONT.D3_EMISSAO, '')
		,@ALMAPONT	  = ISNULL (SD3_APONT.D3_LOCAL, '')
		,@ALMTRSAI	  = ISNULL (SD3_TRAN_SAI.D3_LOCAL, '')
		,@ALMTRENT	  = ISNULL (SD3_TRAN_ENT.D3_LOCAL, '')
		,@DTTRANSF	  = ISNULL (SD3_TRAN_ENT.D3_EMISSAO, '')
		,@TIPOOP	  = CASE SC2.C2_VAOPESP
							WHEN 'N' THEN 'Normal'
							WHEN 'R' THEN 'Reprocesso'
							WHEN 'E' THEN 'Externa(em 3os)'
							WHEN 'T' THEN 'Terceirizacao(para 3os)'
							WHEN 'F' THEN 'Filtracao'
							ELSE '' END
		, @ZAG_USRINC = ZAG.ZAG_USRINC
		, @ZAG_UAUTO  = ZAG.ZAG_UAUTO
		, @ZAG_UAUTD  = ZAG.ZAG_UAUTD
		, @ZAG_MOTIVO = ZAG.ZAG_MOTIVO
		, @ZAG_EXEC   = CASE ZAG_EXEC
							WHEN ' ' THEN 'Nao executado'
							WHEN 'S' THEN ZAG_EXEC + ' - Executado'
							WHEN 'E' THEN ZAG_EXEC + ' - Erro na execucao'
							WHEN 'N' THEN ZAG_EXEC + ' - Negado'
							WHEN 'X' THEN ZAG_EXEC + ' - Estornado no ERP'
							ELSE ''
							END
		, @VAI_PARA_FULLW = CASE WHEN ZA1_OP != '' OR ZAG.ZAG_ALMDST = '01'
								THEN 'S'
								ELSE 'N'
								END

	FROM ZA1010 ZA1
		LEFT JOIN SB1010 SB1
			ON (SB1.D_E_L_E_T_ = ''
			AND SB1.B1_FILIAL = '  '
			AND SB1.B1_COD = ZA1.ZA1_PROD)
		LEFT JOIN SC2010 SC2
			ON (SC2.D_E_L_E_T_ = ''
			AND SC2.C2_FILIAL  = ZA1.ZA1_FILIAL
			AND SC2.C2_NUM     = SUBSTRING (ZA1.ZA1_OP, 1, 6)
			AND SC2.C2_ITEM    = SUBSTRING (ZA1.ZA1_OP, 7, 2)
			AND SC2.C2_SEQUEN  = SUBSTRING (ZA1.ZA1_OP, 9, 3)
			AND SC2.C2_ITEMGRD = SUBSTRING (ZA1.ZA1_OP, 12, 2))
		LEFT JOIN SD3010 SD3_APONT
			ON (SD3_APONT.D_E_L_E_T_ = ''
			AND SD3_APONT.D3_FILIAL = ZA1.ZA1_FILIAL
			AND SD3_APONT.D3_OP = ZA1.ZA1_OP
			AND SD3_APONT.D3_VAETIQ = ZA1.ZA1_CODIGO
			AND SD3_APONT.D3_CF LIKE 'PR%'
			AND SD3_APONT.D3_ESTORNO != 'S')
		LEFT JOIN SD3010 SD3_TRAN_SAI
			ON (SD3_TRAN_SAI.D_E_L_E_T_ = ''
			AND SD3_TRAN_SAI.D3_FILIAL = ZA1.ZA1_FILIAL
		--	AND SD3_TRAN_SAI.D3_OP = ZA1.ZA1_OP
			AND SD3_TRAN_SAI.D3_VAETIQ = ZA1.ZA1_CODIGO
			AND SD3_TRAN_SAI.D3_CF = 'RE4'
			AND SD3_TRAN_SAI.D3_ESTORNO != 'S')
		LEFT JOIN SD3010 SD3_TRAN_ENT
			ON (SD3_TRAN_ENT.D_E_L_E_T_ = ''
			AND SD3_TRAN_ENT.D3_FILIAL = ZA1.ZA1_FILIAL
		--	AND SD3_TRAN_ENT.D3_OP = ZA1.ZA1_OP
			AND SD3_TRAN_ENT.D3_VAETIQ = ZA1.ZA1_CODIGO
			AND SD3_TRAN_ENT.D3_CF = 'DE4'
			AND SD3_TRAN_ENT.D3_ESTORNO != 'S')
		LEFT JOIN ZAG010 ZAG
			ON (ZAG.D_E_L_E_T_ = ''
			AND ZAG.ZAG_FILIAL = '  '
			AND ZAG.ZAG_DOC = SUBSTRING (ZA1.ZA1_IDZAG, 1, 10)
			AND ZAG.ZAG_SEQ = SUBSTRING (ZA1.ZA1_IDZAG, 11, 2))
	WHERE ZA1.D_E_L_E_T_ = ''
	AND ZA1_FILIAL = @IN_FILIAL
	AND ZA1_CODIGO = @IN_ETIQ

	IF (SELECT @@rowcount) = 0
	BEGIN
		RAISERROR ('ETIQUETA NAO ENCONTRADA NA TABELA ZA1', 11, 1)
		SET @RET += 'ETIQUETA NAO ENCONTRADA NA TABELA ZA1.'
		SET @CONTINUA = 'N'
	END
	
	IF @CONTINUA = 'S'
	BEGIN
		IF @OP != ''
			SET @TIPO_ETIQ = 'OP (APONTAMENTO DE PRODUCAO)'
		IF @NFENTR != ''
			SET @TIPO_ETIQ = 'NFE (NOTA FISCAL DE ENTRADA)'
		IF @D5NSEQ != ''
			SET @TIPO_ETIQ = 'SD5 (LOTE INICIAL DE ESTOQUE)'
		IF @ZAG_DOC != ''
			SET @TIPO_ETIQ = 'ZAG (SOLIC.DE TRANSFERENCIA)'
		IF @TIPO_ETIQ = ''
		BEGIN
			RAISERROR ('NAO FOI POSSIVEL DETERMINAR O TIPO DE ETIQUETA', 11, 1)
			SET @RET += 'NAO FOI POSSIVEL DETERMINAR O TIPO DE ETIQUETA.'
			SET @CONTINUA = 'N'
		END
	END

	IF @CONTINUA = 'S'
	BEGIN
		SET @RET += 'Etiqueta..........: ' + @IN_ETIQ + '</br>'
		SET @RET += 'Emissao...........: ' + dbo.VA_DTOC (@EMISETIQ) + '</br>'
		SET @RET += 'Produto...........: ' + RTRIM (@PRODUTO) + ' - ' + RTRIM (@DESCPROD) + '</br>'
		SET @RET += 'Quantidade........: ' + FORMAT (@QUANTIDADE, 'G') + '</br>'
		SET @RET += 'Tipo de etiqueta..: ' + @TIPO_ETIQ + '</br>'
		IF @TIPO_ETIQ LIKE 'OP%'
		BEGIN
			SET @RET += 'OP................: ' + @OP + '</br>'
			SET @RET += 'Tipo de OP........: ' + @TIPOOP + '</br>'
			SET @RET += 'Dt.apont.OP.......: ' + dbo.VA_DTOC (@DTAPONT) + '</br>'
			SET @RET += 'Alm.apont.OP......: ' + @ALMAPONT + '</br>'
		END
		IF @TIPO_ETIQ LIKE 'NFE%'
		BEGIN
			SET @RET += 'NF entrada........: ' + @NFENTR + '</br>'
		END
		IF @TIPO_ETIQ LIKE 'SD5%'
		BEGIN
			SET @RET += 'D5_NUMSEQ.........: ' + @D5NSEQ + '</br>'
		END
		IF @TIPO_ETIQ LIKE 'ZAG%'
		BEGIN
			SET @RET += 'DOC solic.transf..: ' + @ZAG_DOC + '</br>'
			SET @RET += 'Usr.solicitante...: ' + @ZAG_USRINC + '</br>'
			SET @RET += 'Usr.lib.alm.origem: ' + @ZAG_UAUTO + '</br>'
			SET @RET += 'Usr.lib.alm.dest..: ' + @ZAG_UAUTD + '</br>'
			SET @RET += 'Motivo............: ' + @ZAG_MOTIVO + '</br>'
			SET @RET += 'Status............: ' + @ZAG_EXEC + '</br>'
			SET @RET += 'Transf.entre almox: ' + @ALMTRSAI + '->' + @ALMTRENT + ' em ' + dbo.VA_DTOC (@DTTRANSF) + '</br>'
		END
		SET @RET += ''
	END

	-- Verifica integracoes com FullWMS
	IF @CONTINUA = 'S' AND @VAI_PARA_FULLW = 'S'
	BEGIN
		SET @RET += 'Envio do Protheus para FullWMS:' + '</br>'

		DECLARE @TBWMSETIQ_CONSTA INT
		DECLARE @TBWMSETIQ_STATUS VARCHAR (1)
		SELECT @TBWMSETIQ_CONSTA = COUNT (*)
			,  @TBWMSETIQ_STATUS = STRING_AGG (status, ',')
		from tb_wms_etiquetas
		where id = @IN_ETIQ

		IF @TBWMSETIQ_CONSTA = 0
		BEGIN
			SET @RET += '   Protheus AINDA NAO gravou em tb_wms_etiquetas' + '</br>'
			SET @CONTINUA = 'N'
		END
		IF @TBWMSETIQ_CONSTA > 1
		BEGIN
			SET @RET += '   Protheus gravou MAIS DE 1 REGISTRO em tb_wms_etiquetas' + '</br>'
			SET @CONTINUA = 'N'
		END
		IF @TBWMSETIQ_CONSTA = 1
		BEGIN
			IF @TBWMSETIQ_STATUS != 'S'
			BEGIN
				SET @RET += '   Protheus gravou em tb_wms_etiquetas, mas o FullWMS ainda nao leu (campo status != S). Verifique Fullsinc.' + '</br>'
				SET @CONTINUA = 'N'
			END
			ELSE
			BEGIN
				SET @RET += '   Protheus gravou em tb_wms_etiquetas e o FullWMS jah leu (campo status = S)' + '</br>'
			END
		END

		IF @CONTINUA = 'S'
		BEGIN
			DECLARE @TBWMSENTRADA_CONSTA         INT
			DECLARE @TBWMSENTRADA_ENTRADA_ID     VARCHAR (50)
			DECLARE @TBWMSENTRADA_DTHR           DATETIME
			DECLARE @TBWMSENTRADA_STATUS         INT
			DECLARE @TBWMSENTRADA_STATUSPROTHEUS VARCHAR (30)
			DECLARE @TBWMSENTRADA_QTDE_EXEC      FLOAT
			DECLARE @TBWMSENTRADA_QTDE_MOV       FLOAT
			SELECT TOP 1
				   @TBWMSENTRADA_CONSTA         = COUNT (*)
				 , @TBWMSENTRADA_ENTRADA_ID     = STRING_AGG (entrada_id, ',')
				 , @TBWMSENTRADA_STATUS         = STRING_AGG (CAST (status AS VARCHAR (1)), ',')
				 , @TBWMSENTRADA_STATUSPROTHEUS = STRING_AGG (status_protheus, ',')
				 , @TBWMSENTRADA_QTDE_EXEC      = SUM (qtde_exec)
				 , @TBWMSENTRADA_QTDE_MOV       = SUM (qtde_mov)
				 , @TBWMSENTRADA_DTHR           = MAX (dthr)
			from tb_wms_entrada
			where codfor = @IN_ETIQ
			GROUP BY codfor

			IF @TBWMSENTRADA_CONSTA = 0
			BEGIN
				SET @RET += '   Protheus ainda nao pediu para o FullWMS guardar (nao consta em tb_wms_entrada)' + '</br>'
				SET @CONTINUA = 'N'
			END
			IF @TBWMSENTRADA_CONSTA = 1
			BEGIN
				SET @RET += '   Protheus jah pediu ao FullWMS para guardar (jah consta na tb_wms_entrada)' + '</br>'
				SET @RET += '      tb_wms_entrada.entrada_id...: ' + @TBWMSENTRADA_ENTRADA_ID + '</br>'
				SET @RET += '      tb_wms_entrada.dthr.........: ' + format (@TBWMSENTRADA_DTHR, 'dd/MM/yyyy hh:mm:ss') + ' (ultima atualizacao pelo FullWMS)' + '</br>'
				SET @RET += '      tb_wms_entrada.status.......: ' + CAST (@TBWMSENTRADA_STATUS AS VARCHAR (1))
					+ CASE @TBWMSENTRADA_STATUS
						WHEN 1 THEN ' (lido)'
						WHEN 2 THEN ' (liberado)'
						WHEN 3 THEN ' (aceito)'
						WHEN 9 THEN ' (cancelado) Recebimento foi excluido manualmente no FullWMS'
						ELSE 'SEM DEFINICAO'
						END + '</br>'

				DECLARE @QUERY NVARCHAR (MAX)

				IF @TBWMSENTRADA_STATUS = 1
				BEGIN
					DECLARE @REC_AUTORIZADO_NO_FULL int

					-- Para poder passar parametros para uma query num linked server, preciso criar uma consulta inteira e 'executar' ela (https://learn.microsoft.com/en-us/troubleshoot/sql/database-engine/linked-servers/pass-variable-linked-server-query)
					-- Para poder popular variaveis atraves de uma consulta com openquery, preciso usar sp_executesql (https://dba.stackexchange.com/questions/158611/out-param-with-openquery)
					SET @QUERY = 'select @REC_AUTORIZADO_NO_FULL = AUT
									FROM OPENQUERY(LKSRV_FULLWMS_LOGISTICA
										,''select count (*) AUT
									from wms_autorizacoes_recebimentos
									where situacao = ''''A''''
									and placa_nfe = ''''' + @IN_ETIQ + ''''''')'

					-- SET @RET += @QUERY
					exec sys.sp_executesql @QUERY
						, N'@REC_AUTORIZADO_NO_FULL int OUTPUT'
						, @REC_AUTORIZADO_NO_FULL = @REC_AUTORIZADO_NO_FULL OUTPUT
					IF @REC_AUTORIZADO_NO_FULL = 1
					BEGIN
						SET @RET += '      Recebimento ainda nao autorizado no Full. Verifique tela WF1023 - Liberacao de recebimentos' + '</br>'
					END
				END

				IF @TBWMSENTRADA_STATUS in (2, 3)
				BEGIN
					SET @RET += '      tb_wms_entrada.qtde_exec....: ' + FORMAT (@TBWMSENTRADA_QTDE_EXEC, 'G') + ' (quantidade executada pelo FullWMS ; conferido recebimento)' + '</br>'
					SET @RET += '      tb_wms_entrada.qtde_mov.....: ' + FORMAT (@TBWMSENTRADA_QTDE_MOV,  'G') + ' (quantidade movimentada pelo FullWMS ; movimentado para endereco final)' + '</br>'
					
					DECLARE @GUARDA_NO_FULL varchar (max)

					-- Para poder passar parametros para uma query num linked server, preciso criar uma consulta inteira e 'executar' ela (https://learn.microsoft.com/en-us/troubleshoot/sql/database-engine/linked-servers/pass-variable-linked-server-query)
					-- Para poder popular variaveis atraves de uma consulta com openquery, preciso usar sp_executesql (https://dba.stackexchange.com/questions/158611/out-param-with-openquery)
				--	DECLARE @QUERY NVARCHAR (MAX)
					SET @QUERY = 'select @GUARDA_NO_FULL = TAR
									FROM OPENQUERY(LKSRV_FULLWMS_LOGISTICA
										,''select ''''Movido para ''''
										|| decode(m.cod_ruasarm_destino, null, m.codigo_area_destino, m.cod_ruasarm_destino || ''''-'''' ||
												m.cod_predio_destino || ''''-'''' ||
												m.cod_la_destino ||
												decode(m.cod_subla_destino, null, null, ''''-'''' ||
												m.cod_subla_destino))
										|| '''' por '''' || m.usuario
										|| '''' em '''' || m.dt_mov 
										|| '''' (Tarefa '''' || TO_CHAR(t.cod_tarefa_cd) || '''' id_movto '''' || TO_CHAR (s.movestcd_movestcd_id) || '''')''''
										TAR
									from wms_tarefas_cd t
										left join wms_sub_tarefas_cd s
											left join wms_mov_estoques_cd m
												on (m.empr_codemp = s.empr_codemp
												and m.movestcd_id = s.movestcd_movestcd_id)
											on (s.empr_codemp = t.empr_codemp
											and s.centdist_cod_centdist = t.centdist_cod_centdist
											and s.tarcd_cod_tarefa_cd = t.cod_tarefa_cd)
									where t.armovto_codigo_area_origem = ''''PROD01''''
									and t.pal_palete_id = ''''' + @IN_ETIQ + ''''''')'

				--	SET @RET += @QUERY
					exec sys.sp_executesql @QUERY
						, N'@GUARDA_NO_FULL nvarchar (max) OUTPUT'
						, @GUARDA_NO_FULL = @GUARDA_NO_FULL OUTPUT
					SET @RET += '      FullWMS: ' + @GUARDA_NO_FULL + '</br>'

				END

				IF @TBWMSENTRADA_STATUS = 9
				BEGIN
					SET @CONTINUA = 'N'
				END

			END
		END

		IF @CONTINUA = 'S'
		BEGIN
			SET @RET += ''
			SET @RET += 'Retorno do FullWMS para Protheus:' + '</br>'
			IF @TBWMSENTRADA_STATUSPROTHEUS != ''
			BEGIN
				SET @RET += '   tb_wms_entrada.status_protheus: ' + @TBWMSENTRADA_STATUSPROTHEUS + '</br>'
				SET @RET += '   Transf.entre almox: ' + @ALMTRSAI + '->' + @ALMTRENT + ' em ' + dbo.VA_DTOC (@DTTRANSF) + '</br>'
			END

		END
		SET @RET += '' + '</br>'
	END

	-- Cria tabela temporaria de eventos da OP
	IF (@CONTINUA = 'S')
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY DATA, HORA) AS REGISTRO
			, *
		INTO #EVENTOS
		FROM VA_VEVENTOS
		WHERE FILIAL = @IN_FILIAL
		AND ETIQUETA = @IN_ETIQ
		ORDER BY DATA, HORA

		-- Percorre a tabela temporaria listando os registros.
		WHILE EXISTS (SELECT TOP 1 NULL FROM #EVENTOS)
		BEGIN
			SET @MSG = (SELECT TOP 1
							'Evento em ' + dbo.VA_DTOC (DATA) +
							' ' + HORA +
							' - ' + DESCRITIVO +
							' [por ' + USUARIO + ']'
						FROM #EVENTOS
						ORDER BY REGISTRO)
			SET @RET += @MSG + '</br>'
			-- Remove o registro jah processado.
			DELETE #EVENTOS WHERE REGISTRO = (SELECT MIN (REGISTRO) FROM #EVENTOS)
		END
		DROP TABLE #EVENTOS
	END

	SET @RET += '</body></html>'

	/* EXEMPLOS DE ETIQUETAS
	2000650471 -- Tipo OP (no momento, parada com status=2)
	2000647875 -- Tipo OP (recebimento excluido no Full)
	2000651306 -- Tipo OP (recebimento finalizado)
	9000250244 -- Tipo SD5
	2000649318 -- Tipo ZAG
	9000253560 -- Tipo NFE

	declare @resultado varchar (max);
	EXEC VA_SP_RASTREAR_ETIQUETA '01', '2000666098', @RET = @resultado output
	print @resultado

	*/

END


