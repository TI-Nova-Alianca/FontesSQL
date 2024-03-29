---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	21/10/2014	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MIXFILTROS AS
 SELECT CODIGO_MIX	  CODIGO_MIXF,
		ID_FILTRO	  IDFILTRO_MIXF,
		SEQUENCIA	  SEQUENCIA_MIXF,
		CASE WHEN VALOR_NUM = -1 AND ISNULL(VALOR_STRING, '') = '' THEN  ''
             WHEN ISNULL(VALOR_STRING, '') <> '' THEN VALOR_STRING
			    ELSE CAST(VALOR_NUM AS VARCHAR) END VALOR_MIXF		
   FROM DB_MIXVENDA_FILTROS, MVA_MIX
  WHERE CODIGO_MIX = CODIGO_MIXV
