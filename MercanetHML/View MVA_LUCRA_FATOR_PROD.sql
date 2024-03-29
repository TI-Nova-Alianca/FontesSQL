---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	09/01/2017	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_LUCRA_FATOR_PROD AS
 select codigo_fator	codigoFator_LUCFATP,
		sequencia		sequencia_LUCFATP,
		fator			fator_LUCFATP,
		peso			peso_LUCFATP,
		PRODUTO			PRODUTO,	
		TIPO			TIPO,
		MARCA			MARCA,
		FAMILIA			FAMILIA,
		GRUPO			GRUPO
   from DB_LUC_FATOR_PRODUTO, MVA_LUCRA_FATOR
  where codigo_fator = codigo_LUCFAT
