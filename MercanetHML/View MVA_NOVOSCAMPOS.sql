ALTER VIEW MVA_NOVOSCAMPOS AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	13/07/2017	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
 select TABELA				tabela_NOCAM,
		NOME_CAMPO			campo_NOCAM,
		TIPO				tipo_NOCAM,
		TAMANHO				tamanho_NOCAM,
		APRESENTACAO_TELA	apresentacaoTela_NOCAM,
		PESQUISA_DINAMICA	pesquisaDinamica_NOCAM,
		LISTA_DADOS			listaDados_NOCAM,
		APRESENTA_OUTROS	apresentaOutros_NOCAM,
		TEXTO_OPCAO_OUTROS	textoOpcaoOutros_NOCAM,
		ALINHAMENTO			alinhamento_NOCAM,
		APRESENTA_OPCOES_PESQDIN	apresentaOpcoesDin_NOCAM,
		PESQUISA_DINAMICA_OPCOES	pesquisaDinamicaOpcoes_NOCAM,
		LISTA_OPCOES		listaOpcoes_NOCAM,
		PESQUISA_DINAMICA_MOBILE		pesquisaDinamicaMob_NOCAM,
		PESQUISA_DINAMICA_OPCOES_MOB	pesquisaDinOpcoesMob_NOCAM,
		COLUNA_GRAVACAO					colunaGravacao_NOCAM,
		COLUNA_GRAVACAO_MOBILE			colunaGravacaoMob_NOCAM,
		DATA_ALTERACAO		dataalter,
		DB_USUARIO.usuario
   from DB_NOVOS_CAMPOS, DB_USUARIO
  where TABELA in ('DB_OC_PRINCIPAL', 'DB_OC_PRODUTOS', 'DB_OC_NOTAS_FISCAIS', 'DB_OC_ATIVIDADES', 'DB_OC_ITENS')
  union all
 select TABELA				tabela_NOCAM,
		NOME_CAMPO			campo_NOCAM,
		TIPO				tipo_NOCAM,
		TAMANHO				tamanho_NOCAM,
		APRESENTACAO_TELA	apresentacaoTela_NOCAM,
		PESQUISA_DINAMICA	pesquisaDinamica_NOCAM,
		LISTA_DADOS			listaDados_NOCAM,
		APRESENTA_OUTROS	apresentaOutros_NOCAM,
		TEXTO_OPCAO_OUTROS	textoOpcaoOutros_NOCAM,
		ALINHAMENTO			alinhamento_NOCAM,
		APRESENTA_OPCOES_PESQDIN	apresentaOpcoesDin_NOCAM,
		PESQUISA_DINAMICA_OPCOES	pesquisaDinamicaOpcoes_NOCAM,
		LISTA_OPCOES		listaOpcoes_NOCAM,
		PESQUISA_DINAMICA_MOBILE		pesquisaDinamicaMob_NOCAM,
		PESQUISA_DINAMICA_OPCOES_MOB	pesquisaDinOpcoesMob_NOCAM,
		COLUNA_GRAVACAO					colunaGravacao_NOCAM,
		COLUNA_GRAVACAO_MOBILE			colunaGravacaoMob_NOCAM,
		DATA_ALTERACAO		dataalter,
		DB_USUARIO.usuario
   from DB_NOVOS_CAMPOS, DB_USUARIO
  where TABELA = 'DB_OC_ITENS_REPARO'
    and exists (select 1 from DB_USUARIO_MOBILE where CAST(REPLACE(SUBSTRING(VERSAO_UTILIZADA, 1, 9), '.', '') AS INT) >= 2022100 and DB_USUARIO_MOBILE.CODIGO = DB_USUARIO.CODIGO)
