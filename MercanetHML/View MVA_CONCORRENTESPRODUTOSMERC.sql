---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CONCORRENTESPRODUTOSMERC AS
SELECT DB_TBCONP_CONCOR    CONCORRENTE_COPM,
       DB_TBCONP_PRODME    PRODUTOMERCADO_COPM
  FROM DB_TB_CONCOR_PROD
