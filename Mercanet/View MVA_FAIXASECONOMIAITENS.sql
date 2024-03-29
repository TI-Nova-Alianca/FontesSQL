---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/03/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_FAIXASECONOMIAITENS AS
 SELECT CODIGO_FAIXA		 codigoFaixa_FXECOI,
		SEQUENCIA		     sequencia_FXECOI,
		PERCENTUAL_INICIAL	 percentualInicial_FXECOI,
		PERCENTUAL_FINAL	 percentualFinal_FXECOI,
		DESCRICAO_CONCEITO	 descricaoConceito_FXECOI,
		COR		             cor_FXECOI
   FROM DB_FAIXA_ECONOMIA_ITENS, MVA_FAIXASECONOMIA
  WHERE CODIGO_FAIXA = codigo_FXECO
