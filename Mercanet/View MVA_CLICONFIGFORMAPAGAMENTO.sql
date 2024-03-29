---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	06/02/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   19/02/2013  tiago           inclido condicao para n pegar registros com dados ';' nem ',' na substring
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLICONFIGFORMAPAGAMENTO as
SELECT DB_CLIR_CLIENTE     CLIENTE_CCFPG,
       DB_CLIR_EMPRESA     EMPRESA_CCFPG,
       DB_CLIR_REPRES      REPRESENTANTE_CCFPG,
       DB_CLIR_FORMA_PGTO  FORMAPAGAMENTO_CCFPG,
	   r.USUARIO
  FROM DB_CLIENTE_REPRES, MVA_REPRESENTANTES r
 WHERE DB_CLIR_REPRES = r.CODIGO_REPRES
   and isnull(DB_CLIR_FORMA_PGTO, '') <> ''
