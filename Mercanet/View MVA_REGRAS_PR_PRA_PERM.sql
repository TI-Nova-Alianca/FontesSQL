---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	18/10/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_REGRAS_PR_PRA_PERM AS
SELECT CODIGO_REGRA		CODIGOREGRA_RPPP,
       CODIGO_PRAZO		CODIGOPRAZO_RPPP
  FROM DB_REGRAS_PP_PRA_PERM, MVA_REGRAS_PRAZO_PRECO
 WHERE CODIGO_REGRA = CODIGO_REGPP
