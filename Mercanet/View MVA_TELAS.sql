---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	17/07/2017	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_TELAS  AS
 select CODIGO		codigo_TELA,
		DESCRICAO	descricao_TELA,
		TELA		tela_TELA,
		TIPO		tipo_TELA,
		(SELECT	COALESCE(
					(SELECT CAST(DB_FLU_TRANSICOES.CODIGO_TRANSICAO AS VARCHAR) + ';' + cast(DB_FLU_TRANSICOES.EXECUCAO as varchar) + ';' + DB_FLU_TRANSICOES.NOME + '|'AS [text()]
					   FROM DB_FLUXOS, DB_FLU_ETAPAS, DB_FLU_TRANSICOES
					  where DB_FLUXOS.TELA = DB_WEB_TELA.TELA
						and DB_FLUXOS.TIPO = DB_WEB_TELA.TIPO
						and DB_FLU_ETAPAS.CODIGO_FLUXO = DB_FLUXOS.FLUXO
						and DB_FLU_ETAPAS.ETAPA_INICIAL = 1
						and DB_FLU_TRANSICOES.CODIGO_FLUXO = DB_FLUXOS.FLUXO
						and DB_FLU_TRANSICOES.ETAPA_ORIGEM = DB_FLU_ETAPAS.CODIGO_ETAPA
					 FOR XML PATH(''), TYPE).value('.[1]', 'VARCHAR(MAX)'), '') ) AS transicoes_TELA,
		(SELECT DB_FLUXOS.FLUXO FROM DB_FLUXOS WHERE DB_FLUXOS.TELA = DB_WEB_TELA.TELA and DB_FLUXOS.TIPO = DB_WEB_TELA.TIPO) AS fluxo_TELA,
		etapa_permissao  etapaPermissao_TELA,
		ACAO_SALVAR		 acaoSalvar_TELA,
		ACAO_EDITAR		 acaoEditar_TELA,
		fun.usuario
   from DB_WEB_TELA
      , MVA_FUNCIONALIDADES fun
  where fun.TELA_PERMF = DB_WEB_TELA.TELA
	and	fun.TIPO_PERMF = DB_WEB_TELA.TIPO
	and	fun.EXIBIR_PERMF = 1
