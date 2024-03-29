---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/03/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_FAIXASECONOMIA AS
 SELECT CODIGO       codigo_FXECO,
		DESCRICAO    descricao_FXECO,
		DATA_INICIAL dataInicial_FXECO,
		DATA_FINAL   dataFinal_FXECO,
		AVALIACAO    avaliacao_FXECO
   FROM db_faixa_economia
  WHERE cast(DATA_FINAL as date) >= cast(GETDATE() as date)
