---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	21/10/2014	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MIXPRODUTOS AS
SELECT CODIGO_MIX	CODIGOMIX_MIXP,
	   PRODUTO	PRODUTO_MIXP
  FROM DB_MIXVENDA_PRODUTOS, MVA_MIX
 WHERE CODIGO_MIX = CODIGO_MIXV
