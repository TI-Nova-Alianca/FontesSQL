ALTER VIEW MVA_TRANSICOES AS
 select CODIGO_FLUXO				fluxo_TRA,
		CODIGO_TRANSICAO			transicao_TRA,
		NOME						nome_TRA,
		ETAPA_ORIGEM				etapaOrigem_TRA,
		ETAPA_DESTINO				etapaDestino_TRA,
		FORMATO_CRITERIOS			formatoCriterios_TRA,
		COMBINACAO_CRITERIOS		combinacaoCriterios_TRA,
		EXECUCAO					execucao_TRA,
		FORMATO_TRANSICAO_MOBILE	formatoTransicao_TRA,
		MVA_TELAS.usuario
   from DB_FLU_TRANSICOES, MVA_TELAS
  where MVA_TELAS.fluxo_TELA = CODIGO_FLUXO
    and isnull(FORMATO_TRANSICAO_MOBILE, 0) in (0, 1)
