---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	07/02/2017	TIAGO PRADELLA	CRIACAO
-- 1.0002   18/04/2017  tiago           incluido campo formato faixa
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CONS_CONFIG_GRAFICO_FAIXA AS
 SELECT PERCENTUAL_INICIAL	percentualInicial_COGRAF,
		PERCENTUAL_FINAL	percentualFinal_COGRAF,
		COR					cor_COGRAF,
		CONSULTA			consulta_COGRAF,
		SEQUENCIA			sequencia_COGRAF,
		FORMATO_FAIXA       formatoFaixa_COGRAF,
		MVA_CONSULTA_CONFIG_GRAFICO.USUARIO
   FROM DB_CONS_GRAFICO_FAIXAS, MVA_CONSULTA_CONFIG_GRAFICO
  WHERE CONSULTA = CONSULTA_COGRA
