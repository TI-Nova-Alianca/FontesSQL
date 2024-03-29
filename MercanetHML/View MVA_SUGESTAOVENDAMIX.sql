---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	21/11/2014	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SUGESTAOVENDAMIX  AS
SELECT PR05_CODMIX     MIX_SUGMIX,
       PR05_DESCR      DESCRICAO_SUGMIX,
	   isnull(PR05_LSTPROD, '') + isnull(PR05_LSTPROD2, '')  LISTAPRODUTOS,
	   USUARIO
  FROM MPR05, MVA_SUGESTAOVENDA
 WHERE PR05_CODMIX = MIX_SUGVDA
