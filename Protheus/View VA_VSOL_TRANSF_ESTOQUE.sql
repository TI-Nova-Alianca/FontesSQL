

-- Cooperativa Nova Alianca Ltda
-- View para buscar dados de solicitacoes de transferencias de estoque feitas ao Protheus via web service.
-- Autor: Robert Koch
-- Data:  07/07/2021
-- Historico de alteracoes:
-- 07/07/2021 - Robert - Deixa de usar tabela customizada e passa a usar a tabela padrao SYS_USR.
-- 27/04/2022 - Robert - Testes fixos com almox.X B1_VAFULLW removidos (criei um usuario 'fullwms' no Protheus)
-- 05/05/2022 - Robert - Versao inicial com campo explicativo em HTML
-- 29/09/2022 - Robert - Criada coluna STATUS_EXECUCAO
-- 19/10/2022 - Robert - Nao validava campo ZZU_VALID
-- 05/12/2022 - Robert - Buscar numero da etiqueta (quando houver).
-- 14/12/2022 - Robert - Reescrito usando CTE para melhoria de performance.
--                       Tempo para leitura de 2 meses (aprox. 1200 linhas)
--                       baixou de 11 min.p/5 seg. Acho que dá pro gasto, né?
--                     - Busca dados do FullWMS (tb_wms_pedidos) se for o caso.
-- 09/03/2023 - Robert - Melhoria campo RET_PROMPT_HTML
-- 13/03/2023 - Robert - Campo ZAG_SEQ passa a fazer parte da chave do ZAG.
-- 09/12/2023 - Robert - Passa a usar a view VA_VDONOS_ALMOX que jah traz usuarios por almox X filial (GLPI 14601)
-- 25/01/2024 - Robert - Trocada funcao STR por FORMAT no campo ZAG_QTDSOL na geracao da coluna RET_PROMPT_HTML
--

-- NAO MUDAR os nomes dos campos, pois o NaWeb usa eles!
ALTER VIEW [dbo].[VA_VSOL_TRANSF_ESTOQUE] AS 
WITH SOLICITACAO AS (
	SELECT ZAG.*
		, ISNULL (SB1_ORI.B1_DESC, '') as  ZAG_PRDORIDESC
		, ISNULL (SB1_DST.B1_DESC, '') as  ZAG_PRDDSTDESC
		, ISNULL (LIBERADORES_ORI.NOMES, '') AS LIBERADORES_ALMORI
		, ISNULL (LIBERADORES_DST.NOMES, '') AS LIBERADORES_ALMDST
		, '' AS LIBERADORES_PCP  -- POR ENQUANTO NAO VAI SER USADO
		, '' AS LIBERADORES_QUALIDADE  -- POR ENQUANTO NAO VAI SER USADO
		, SB1_ORI.B1_UM
		, CASE ZAG_EXEC
			WHEN ' ' THEN 'Nao executado'
			WHEN 'S' THEN ZAG_EXEC + '-Executado'
			WHEN 'E' THEN ZAG_EXEC + '-Erro na execucao'
			WHEN 'N' THEN ZAG_EXEC + '-Negado'
			WHEN 'X' THEN ZAG_EXEC + '-Estornado no ERP'
			ELSE ''
		END AS STATUS_EXECUCAO
		, ISNULL (ZA1_CODIGO, '') AS ETIQUETA
	FROM ZAG010 ZAG
		LEFT JOIN ZA1010 ZA1
			ON (ZA1.D_E_L_E_T_ = ''
			AND ZA1.ZA1_FILIAL = ZAG_FILDST
			AND ZA1.ZA1_IDZAG  = ZAG_DOC + ZAG_SEQ)
		LEFT JOIN VA_VDONOS_ALMOX AS LIBERADORES_ORI
			ON (LIBERADORES_ORI.ALMOX = ZAG.ZAG_ALMORI
			AND LIBERADORES_ORI.FILIAL = ZAG.ZAG_FILORI)
		LEFT JOIN VA_VDONOS_ALMOX AS LIBERADORES_DST
			ON (LIBERADORES_DST.ALMOX = ZAG.ZAG_ALMDST
			AND LIBERADORES_DST.FILIAL = ZAG.ZAG_FILDST)
		, SB1010 SB1_ORI
		, SB1010 SB1_DST
	WHERE ZAG.D_E_L_E_T_ = ''
	AND SB1_ORI.D_E_L_E_T_ = ''
	AND SB1_ORI.B1_FILIAL = '  '
	AND SB1_ORI.B1_COD = ZAG.ZAG_PRDORI
	AND SB1_DST.D_E_L_E_T_ = ''
	AND SB1_DST.B1_FILIAL = '  '
	AND SB1_DST.B1_COD = ZAG.ZAG_PRDDST
)
SELECT *
	,'<font color="black">Alm.orig.(' + ZAG_ALMORI + '): '
	+ case when ZAG_UAUTO != ''
		then '<font color="green">liberado</font><font color="grey"> por ' + ZAG_UAUTO + ' (entre ' + LIBERADORES_ALMORI + ')'
		else '<font color="red">aguarda</font><font color="grey"> por '
			+ case when ZAG_ALMORI = '01'
				then 'FULLWMS (pedido '
					+ isnull ((select top 1 nrodoc  -- nao deveria ter mais que um registro, mas, pra evitar algum erro em tempo de execucao...
							+ ' tarefa com qt.executada= ' + format (qtde_exec, 'G')
						from tb_wms_pedidos
						where saida_id = 'ZAG' + ZAG_FILIAL + ZAG_DOC + ZAG_SEQ), '')
				+ ')'
				else LIBERADORES_ALMORI
				end
		end + '</br>'
	+ '<font color="black">Alm.dest.(' + ZAG_ALMDST + '): '
		+ case when ZAG_UAUTD != ''
			then '<font color="green">liberado</font><font color="grey"> por ' + ZAG_UAUTD + ' (entre ' + LIBERADORES_ALMDST + ')'
			else '<font color="red">aguarda</font><font color="grey"> '
				+ case when ZAG_ALMDST = '01'
					then 'FULLWMS (tarefa de recebimento etiq.' + isnull (ETIQUETA, '')
						+ isnull (' com status '
							+ (select status
								+ case status
									when '1' then '-importada'
									when '2' then '-autorizado'
									when '3' then '-finalizado'
									when '9' then '-excluido'
									else ' (desconhecido)'
									end
								from tb_wms_entrada
								where nrodoc = 'ZAG' + ZAG_DOC + ZAG_SEQ), ' ainda nao gerada')
					+ ')'
					else LIBERADORES_ALMDST
					end
			end + '</br>'
	+ '<font color="black">Produto:<font color="grey"> ' + rtrim (ZAG_PRDORI) + ' (' + rtrim (ZAG_PRDORIDESC) + ')'
					+ case when ZAG_PRDDST != ZAG_PRDORI
						then ' --> ' + rtrim (ZAG_PRDDST) + ' (' + rtrim (ZAG_PRDDSTDESC) + ')'
						else ''
						end + '</br>'
	+ '<font color="black">Quantidade:<font color="grey"> ' + format (ZAG_QTDSOL, 'N4', 'pt-br') + ' ' + B1_UM + '</br>'
	+ '<font color="black">Solicitado por:<font color="grey"> ' + rtrim (ZAG_USRINC) + ' em ' + dbo.VA_DTOC (ZAG_EMIS) + '</br>'
	+ '<font color="black">Motivo:<font color="grey"> ' + rtrim (ZAG_MOTIVO) + '</br>'
	+ case when ZAG_LOTDST != '' or ZAG_LOTORI != ''
		then '<font color="black">Lote:<font color="grey"> ' + rtrim (ZAG_LOTORI)
					+ case when ZAG_LOTDST != ZAG_LOTORI
						then ' --> ' + rtrim (ZAG_LOTDST)
						else ''
						end + '</br>'
		else ''
		end
	+ case when ZAG_ENDDST != '' or ZAG_ENDORI != ''
		then '<font color="black">Endereco:<font color="grey"> ' + rtrim (ZAG_ENDORI)
						+ case when ZAG_ENDDST != ZAG_ENDORI
							then ' --> ' + rtrim (ZAG_ENDDST)
							else ''
							end + '</br>'
		else ''
		end
	+ '<font color="black">Status:<font color="grey"> ' + ZAG_EXEC
		+ case ZAG_EXEC
			when ' ' then 'Ainda nao executado no Protheus'
			when 'X' then ' - Estornado'
			when 'N' then ' - Negado - motivo: ' + rtrim (ZAG_MOTNAC)
			when 'E' then ' - Erro na execucao'
			when 'S' then ' - Efetivado no Protheus'
						-- Busca SD3 usando TOP 1 por que as transf. geram sempre um par de movimentos.
						+ ISNULL ((SELECT TOP 1 ' em ' + dbo.VA_DTOC (D3_EMISSAO) + ' (Doc.estoque=' + D3_DOC + ')'
									FROM SD3010 SD3
									WHERE D_E_L_E_T_ = ''
									AND D3_FILIAL = ZAG_FILORI
									AND D3_VACHVEX = 'ZAG' + ZAG_DOC + ZAG_SEQ  -- Campo gravado pela ClsTrEstq
							), '')
			end + '<br>'
	+ '<font color="black">Etiqueta:<font color="grey"> ' + ETIQUETA + '<br>'
	+ '<font color="black">Ultimas mensagens:<font color="grey"> ' + rtrim (ZAG_ULTMSG) + '<br>'
	+ case when ZAG_ALMORI = '01'  -- controlado pelo FullWMS e, portanto, deveria gerar pedido de separacao.
		then '<font color="black">Pedido de separacao no FullWMS:<font color="grey"> '
			+ isnull ((select top 1 nrodoc  -- nao deveria ter mais que um registro, mas, pra evitar algum erro em tempo de execucao...
					+ ' (qt.executada: ' + format (qtde_exec, 'G') + ')'
				from tb_wms_pedidos
				where saida_id = 'ZAG' + ZAG_FILIAL + ZAG_DOC + ZAG_SEQ), '')
		else ''
	end + '<br>'
	as RET_PROMPT_HTML  -- Nao mudar o nome deste campo, pois o NaWeb usa ele.
FROM SOLICITACAO


