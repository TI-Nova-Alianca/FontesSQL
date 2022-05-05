
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Cooperativa Nova Alianca Ltda
-- View para buscar dados de solicitacoes de transferencias de estoque feitas ao Protheus via web service.
-- Autor: Robert Koch
-- Data:  07/07/2021
-- Historico de alteracoes:
-- 07/07/2021 - Robert - Deixa de usar tabela customizada e passa a usar a tabela padrao SYS_USR.
-- 27/04/2022 - Robert - Testes fixos com almox.X B1_VAFULLW removidos (criei um usuario 'fullwms' no Protheus)
-- 05/05/2022 - Robert - Versao inicial com campo explicativo em HTML
--

ALTER VIEW [dbo].[VA_VSOL_TRANSF_ESTOQUE] AS 
WITH C AS (
	SELECT ZAG.*
		, ISNULL ((SELECT [GX0004_PRODUTO_DESCRICAO]
					FROM [dbo].[GX0004_PRODUTOS]
					WHERE [GX0004_PRODUTO_CODIGO] = ZAG.ZAG_PRDORI) , '') as  ZAG_PRDORIDESC
		, ISNULL ((SELECT [GX0004_PRODUTO_DESCRICAO]
					FROM [dbo].[GX0004_PRODUTOS]
					WHERE [GX0004_PRODUTO_CODIGO] = ZAG.ZAG_PRDDST) , '') as  ZAG_PRDDSTDESC
		, ISNULL ((SELECT NOMES = STRING_AGG (UPPER (RTRIM (U.USR_CODIGO)), ', ')
					FROM ZZU010 ZZU, SYS_USR U
					WHERE ZZU.D_E_L_E_T_ = ''
					AND ZZU.ZZU_FILIAL = '  '
					AND U.USR_ID = ZZU.ZZU_USER
					AND ZZU.ZZU_GRUPO = 'A' + ZAG.ZAG_ALMORI)
					, '') AS LIBERADORES_ALMORI
		, ISNULL ((SELECT NOMES = STRING_AGG (UPPER (RTRIM (U.USR_CODIGO)), ', ')
					FROM ZZU010 ZZU, SYS_USR U
					WHERE ZZU.D_E_L_E_T_ = ''
					AND ZZU.ZZU_FILIAL = '  '
					AND U.USR_ID = ZZU.ZZU_USER
					AND ZZU.ZZU_GRUPO = 'A' + ZAG.ZAG_ALMDST)
					, '') AS LIBERADORES_ALMDST
		, '' AS LIBERADORES_PCP  -- POR ENQUANTO NAO VAI SER USADO
		, '' AS LIBERADORES_QUALIDADE  -- POR ENQUANTO NAO VAI SER USADO
		, SB1.B1_UM
	FROM ZAG010 ZAG, SB1010 SB1
	WHERE ZAG.D_E_L_E_T_ = ''
	AND SB1.D_E_L_E_T_ = ''
	AND SB1.B1_FILIAL = '  '
	AND SB1.B1_COD = ZAG.ZAG_PRDORI
)
SELECT *
	,'<font color="black">' --Sobre esta solicitacao de transferencia:</br>' 
	--+ 'Quem solicitou: ' + ZAG_USRINC + '</br>'
	+ 'Alm.orig.(' + ZAG_ALMORI + '): ' + case when ZAG_UAUTO != ''
											then '<font color="green">liberado</font> por ' + ZAG_UAUTO
											else '<font color="red">aguarda</font> por ' + LIBERADORES_ALMORI
											end + '</br>'
	+ 'Alm.dest.(' + ZAG_ALMDST + '): ' + case when ZAG_UAUTD != ''
											then '<font color="green">liberado</font> por ' + ZAG_UAUTD
											else '<font color="red">aguarda</font> ' + LIBERADORES_ALMDST
											end + '</br>'
	+ 'Produto: ' + rtrim (ZAG_PRDORI) + ' (' + rtrim (ZAG_PRDORIDESC) + ')'
					+ case when ZAG_PRDDST != ZAG_PRDORI
						then ' --> ' + rtrim (ZAG_PRDDST) + ' (' + rtrim (ZAG_PRDDSTDESC) + ')'
						else ''
						end + '</br>'
	+ 'Quantidade: ' + str (ZAG_QTDSOL) + ' ' + B1_UM + '</br>'
	+ 'Solicitado por: ' + rtrim (ZAG_USRINC) + ' em ' + dbo.VA_DTOC (ZAG_EMIS) + '</br>'
	+ 'Motivo: ' + rtrim (ZAG_MOTIVO) + '</br>'
	+ case when ZAG_LOTDST != '' or ZAG_LOTORI != ''
		then 'Lote: ' + rtrim (ZAG_LOTORI)
					+ case when ZAG_LOTDST != ZAG_LOTORI
						then ' --> ' + rtrim (ZAG_LOTDST)
						else ''
						end + '</br>'
		else ''
		end
	+ case when ZAG_ENDDST != '' or ZAG_ENDORI != ''
		then 'Endereco: ' + rtrim (ZAG_ENDORI)
						+ case when ZAG_ENDDST != ZAG_ENDORI
							then rtrim (ZAG_ENDORI) + ' --> ' + rtrim (ZAG_ENDDST)
							else ''
							end + '</br>'
		else ''
		end
	+ 'Status: ' + ZAG_EXEC
		+ case ZAG_EXEC
			when ' ' then 'Ainda nao executado'
			when 'X' then ' - Estornado'
			when 'E' then ' - <font color="red">Erro na execucao'
			when 'S' then ' - <font color="green">Efetivado no Protheus'
						-- Busca SD3 usando TOP 1 por que as transf. geram sempre um par de movimentos.
						+ ISNULL ((SELECT TOP 1 ' em ' + dbo.VA_DTOC (D3_EMISSAO) + ' (Doc.estoque=' + D3_DOC + ')'
									FROM SD3010 SD3
									WHERE D_E_L_E_T_ = ''
									AND D3_FILIAL = ZAG_FILORI
									AND D3_VACHVEX = 'ZAG' + ZAG_DOC  -- Campo gravado pela ClsTrEstq
							), '')
			end + '<br>'
	as RET_PROMPT_HTML  -- Nao mudar o nome deste campo, pois o NaWeb usa ele.
FROM C

GO
