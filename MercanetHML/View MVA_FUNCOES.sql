---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	10/07/2013	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_FUNCOES  AS
SELECT DB_TBFUN_CODIGO	    CODIGO_FUNC,
       DB_TBFUN_DESCRICAO	DESCRICAO_FUNC
  FROM DB_TB_FUNCAO
