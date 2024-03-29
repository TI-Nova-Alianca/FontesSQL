CREATE   VIEW MVA_ODS_OCORRENCIAS
AS
(
		SELECT CASE 
				WHEN T.DIAS_AB > 0
					THEN T.DIAS_AB
				ELSE 0
				END AS DIAS_UTEIS
			,CASE 
				WHEN t.etapa_dias > t.etapa_prazo
					AND t.dias_ab > t.etapa_dias
					AND t.etapa_prazo > 0
					THEN '<font color = "#FF1A1A"><b>Etapa em atraso</b></font>'
				ELSE '<font color = "#33CC33">Etapa no prazo</font>'
				END AS STATUS
			,CASE 
				WHEN t.etapa_dias > t.etapa_prazo
					AND t.dias_ab > t.etapa_dias
					AND t.etapa_prazo > 0
					THEN 'Etapa em atraso'
				ELSE 'Etapa no prazo'
				END AS STATUS_TEXTO
			,CASE 
				WHEN T.ETAPA_DIAS > T.ETAPA_PRAZO
					AND T.DIAS_AB >= T.ETAPA_DIAS
					AND T.ETAPA_PRAZO >= 0
					THEN T.DIAS_AB
				ELSE T.DIAS_AB * - 1
				END AS ORDENACAO
			,(
				SELECT PR.NOME
				FROM DB_USUARIO PR
				WHERE PR.USUARIO = T.USUARIO_CRIACAO
				) AS NOME_USUARIO_CRIACAO
			,FORMAT(T.CODIGO, '00000000') AS NUMERO_OC
			,SUBSTRING(RIGHT('00000000' + CONVERT(VARCHAR(8), (T.CODIGO)), 8), 1, 4) + '/' + SUBSTRING(RIGHT('00000000' + CONVERT(VARCHAR(8), (T.CODIGO)), 8), 5, 4) AS oc_cod_format
			,CASE 
				WHEN (
						t.ult_ativ_data > t.INICIO_REALIZADO
						OR t.INICIO_REALIZADO < t.DATA_ALTERACAO
						)
					THEN 'Verificada'
				ELSE '<font color= "blue">Não verificada</font>'
				END AS STATUS_INICIO
			,T.*
		FROM (
			SELECT L.INICIO_REALIZADO
				,R.GRUPO_USUARIO AS GRUPO
				,CASE 
					WHEN P.ETAPA_FINAL = 0
						THEN (DATEDIFF(DD, P.DATA, GETDATE())) - (DATEDIFF(WK, P.DATA, GETDATE()) * 2) - (
								CASE 
									WHEN DATENAME(DW, P.DATA) = 'SUNDAY'
										THEN 1
									ELSE 0
									END
								) - (
								CASE 
									WHEN DATENAME(DW, GETDATE()) = 'SATURDAY'
										THEN 1
									ELSE 0
									END
								) - QTD_DIAS_FERIADO
					ELSE (DATEDIFF(DD, P.DATA, DIA_B)) - (DATEDIFF(WK, P.DATA, DIA_B) * 2) - (
							CASE 
								WHEN DATENAME(DW, P.DATA) = 'SUNDAY'
									THEN 1
								ELSE 0
								END
							) - (
							CASE 
								WHEN DATENAME(DW, DIA_B) = 'SATURDAY'
									THEN 1
								ELSE 0
								END
							) - QTD_DIAS_FERIADO
					END AS DIAS_AB
				,(DATEDIFF(DD, L.INICIO_REALIZADO, GETDATE())) - (DATEDIFF(WK, L.INICIO_REALIZADO, GETDATE()) * 2) - (
					CASE 
						WHEN DATENAME(DW, L.INICIO_REALIZADO) = 'SUNDAY'
							THEN 1
						ELSE 0
						END
					) - (
					CASE 
						WHEN DATENAME(DW, GETDATE()) = 'SATURDAY'
							THEN 1
						ELSE 0
						END
					) ETAPA_DIAS
				,(
					SELECT MAX(TPATI.DESCRICAO)
					FROM DB_FLU_LOG L WITH (NOLOCK)
					INNER JOIN DB_OC_ATIVIDADES ATI WITH (NOLOCK) ON ATI.CODIGO_OC = L.NUMERO_REGISTRO
						AND ATI.ATIVIDADE = L.CODIGO_ATIVIDADE
					INNER JOIN DB_OC_TIPOS_ATIVIDADE TPATI WITH (NOLOCK) ON TPATI.CODIGO = ATI.TIPO
					WHERE L.NUMERO_REGISTRO = P.CODIGO
						AND L.TIPO = 'ATIVIDADE'
						AND L.SEQUENCIA = P.SEQ_MAX_1
					) AS TPATIDESC
				,(
					SELECT MAX(EA.PREVISAO_PRAZO)
					FROM DB_FLU_ETA_ATIVIDADES EA WITH (NOLOCK)
					WHERE EA.CODIGO_ETAPA = P.ETAPA
						AND EA.CODIGO_FLUXO = P.FLUXO
					) AS ETAPA_PRAZO
				,(
					SELECT ATI.usuario
					FROM DB_OC_ATIVIDADES ATI WITH (NOLOCK)
					WHERE ATI.CODIGO_OC = P.CODIGO
						AND ati.DATA_INCLUSAO_REGISTRO = p.ULT_ATIV_DATA
					) ult_ativ_usuario
				,P.*
				,REP.*
			FROM (
				SELECT (
						SELECT MAX(X.DATA)
						FROM DB_FLU_LOG X WITH (NOLOCK)
						WHERE X.CODIGO_ETAPA = P.ETAPA
							AND E.ETAPA_FINAL = 1
							AND X.NUMERO_REGISTRO = P.CODIGO
						) AS DIA_A
					,(
						SELECT Max(X.DATA)
						FROM db_flu_log X WITH (NOLOCK)
						WHERE X.DESCRICAO IN ('Finalizado')
							AND X.TIPO = 'Etapa'
							AND X.NUMERO_REGISTRO = P.CODIGO
						) AS DIA_B
					,(
						SELECT MAX(ATI.DATA_INCLUSAO_REGISTRO)
						FROM DB_OC_ATIVIDADES ATI WITH (NOLOCK)
						WHERE ATI.CODIGO_OC = P.CODIGO
						) ULT_ATIV_DATA
					,(
						SELECT MAX(X.SEQUENCIA)
						FROM DB_FLU_LOG X WITH (NOLOCK)
						WHERE X.NUMERO_REGISTRO = P.CODIGO
							AND X.TIPO = 'ATIVIDADE'
							AND X.SITUACAO = 'FINALIZADA'
						) AS SEQ_MAX_1
					,(
						SELECT MAX(SEQUENCIA)
						FROM DB_FLU_LOG X WITH (NOLOCK)
						WHERE X.NUMERO_REGISTRO = P.CODIGO
							AND X.CODIGO_FLUXO = P.FLUXO
							AND X.CODIGO_ETAPA = P.ETAPA
						) AS SEQ_MAX
					,(
						SELECT O.DESCRICAO
						FROM DB_OC_ORIGENS O WITH (NOLOCK)
						WHERE O.CODIGO = P.ORIGEM
						) AS ORIGEM_OC_DESC
					,(
						SELECT M.DESCRICAO
						FROM DB_OC_MOTIVOS M WITH (NOLOCK)
						WHERE M.CODIGO = P.MOTIVO
						) AS MOTIVO_OC_DESC
					,(
						SELECT SUBSTRING(T.TASKS, 1, LEN(T.TASKS) - 1)
						FROM (
							SELECT DISTINCT NUMERO_REGISTRO
							FROM DB_FLU_LOG WITH (NOLOCK)
							WHERE NUMERO_REGISTRO = P.CODIGO
							) COD
						CROSS APPLY (
							SELECT DISTINCT L.DESCRICAO + ', '
							FROM DB_FLU_LOG L WITH (NOLOCK)
								,DB_OC_PRINCIPAL P WITH (NOLOCK)
							WHERE COD.NUMERO_REGISTRO = L.NUMERO_REGISTRO
								AND P.CODIGO = L.NUMERO_REGISTRO
								AND P.SITUACAO = L.ETAPA_ORIGEM
								AND L.SITUACAO = 'INICIADA'
								AND L.TIPO = 'ATIVIDADE'
								AND NOT EXISTS (
									SELECT DISTINCT 1
									FROM DB_FLU_LOG LL WITH (NOLOCK)
									WHERE LL.NUMERO_REGISTRO = L.NUMERO_REGISTRO
										AND LL.SITUACAO = L.SITUACAO
										AND LL.TIPO = 'ATIVIDADE'
										AND LL.SITUACAO = 'FINALIZADA'
									)
							FOR XML PATH('')
							) T(TASKS)
						) AS T_PEND
					,(
						SELECT COUNT(F.DATA)
						FROM DB_FERIADOS F WITH (NOLOCK)
						WHERE F.EMPRESA = P.EMPRESA
							AND F.DATA BETWEEN P.DATA
								AND GETDATE()
						) AS QTD_DIAS_FERIADO
					,CASE 
						WHEN CL.db_clic_areaatu IS NULL
							THEN 'Não Informado'
						ELSE CONCAT (
								CL.db_clic_areaatu
								,'-'
								,AA.db_area_descr
								)
						END AS area_atuacao_cliente
					,RA1.db_tbatv_descricao AS ramo_atividade_cliente
					,(
						SELECT Max(CONCAT (
									T.db_tbtra_cod
									,'-'
									,T.db_tbtra_nome
									)) AS TRANSPORTADORA
						FROM DB_CLIENTE_REPRES CR WITH (NOLOCK)
						LEFT JOIN DB_TB_REPRES R WITH (NOLOCK) ON CR.db_clir_repres = R.db_tbrep_codigo
						LEFT JOIN DB_TB_COND_FRETE F WITH (NOLOCK) ON Getdate() BETWEEN F.db_tbcf_data_ini
								AND F.db_tbcf_data_fim
							AND (
								NULLIF(F.db_tbcf_clientes, ' ') IS NULL
								OR DBO.Mercf_valida_lista(C.db_cli_codigo, F.db_tbcf_clientes, 0, ',') > 0
								)
							AND dbo.Mercf_valida_lista(CR.db_clir_empresa, F.db_tbcf_empresas, 0, ',') > 0
							AND dbo.Mercf_valida_lista(C.db_cli_estado, F.db_tbcf_estados, 0, ',') > 0
						LEFT JOIN DB_TB_COND_FRETRP FR WITH (NOLOCK) ON CR.db_clir_rota = FR.db_tbcft_rota
							AND FR.db_tbcft_estado = C.db_cli_estado
							AND FR.db_tbcft_codigo = F.db_tbcf_codigo
							AND (
								NULLIF(FR.db_tbcft_cidade, ' ') IS NULL
								OR FR.db_tbcft_cidade = C.db_cli_cidade
								)
						LEFT JOIN DB_TB_TRANSP T WITH (NOLOCK) ON FR.db_tbcft_transp = T.db_tbtra_cod
						WHERE CR.db_clir_cliente = P.cliente
							AND CR.db_clir_repres = P.representante
							AND CR.db_clir_empresa = P.empresa
							AND CR.db_clir_situacao <> 3
						) AS TRANSPORTADORA
					,E.CODIGO_FLUXO AS ETAPA_FLUXO
					,E.CODIGO_ETAPA AS ETAPA_CODIGO
					,E.NOME AS ETAPA_NOME
					,E.ETAPA_INICIAL
					,E.ETAPA_FINAL
					,P.*
					,C.*
					,CL.*
				FROM DB_OC_PRINCIPAL P WITH (NOLOCK)
				LEFT JOIN DB_FLU_ETAPAS E WITH (NOLOCK) ON E.CODIGO_ETAPA = P.ETAPA
					AND E.CODIGO_FLUXO = P.FLUXO
				LEFT JOIN DB_CLIENTE C WITH (NOLOCK) ON C.DB_CLI_CODIGO = P.CLIENTE
				LEFT JOIN DB_CLIENTE_COMPL CL WITH (NOLOCK) ON C.db_cli_codigo = CL.db_clic_cod
				LEFT JOIN DB_AREA_ATUACAO AA WITH (NOLOCK) ON AA.db_area_codigo = CL.db_clic_areaatu
				LEFT JOIN DB_TB_RAMO_ATIV RA1 WITH (NOLOCK) ON RA1.db_tbatv_codigo = C.db_cli_ramativ
				) P
			LEFT JOIN DB_FLU_LOG L WITH (NOLOCK) ON L.NUMERO_REGISTRO = P.CODIGO
				AND L.CODIGO_FLUXO = P.FLUXO
				AND L.CODIGO_ETAPA = P.ETAPA
				AND L.SEQUENCIA = P.SEQ_MAX
			LEFT JOIN DB_FLU_ETA_ATIVIDADES A WITH (NOLOCK) ON A.CODIGO_ETAPA = P.ETAPA
				AND A.CODIGO_FLUXO = P.FLUXO
			LEFT JOIN DB_FLU_ETA_ATIV_RESPON R WITH (NOLOCK) ON R.CODIGO_FLUXO = A.CODIGO_FLUXO
				AND R.CODIGO_ATIVIDADE = A.CODIGO_ATIVIDADE
				AND R.CODIGO_ETAPA = A.CODIGO_ETAPA
			LEFT JOIN DB_TB_REPRES REP WITH (NOLOCK) ON REP.db_tbrep_codigo = P.representante
			LEFT JOIN DB_OC_ATIVIDADES ATI WITH (NOLOCK) ON ATI.codigo_oc = P.codigo
				AND ATI.data_inclusao_registro = (
					SELECT Max(ATI.data_inclusao_registro)
					FROM DB_OC_ATIVIDADES ATI WITH (NOLOCK)
					WHERE ATI.codigo_oc = P.codigo
					)
			) T
		)

