---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	17/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   18/12/2013  tiago           alterado o nome da tabela
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SHOPPINGJUSTIFICATIVAS AS
SELECT DB_JSHO_CODIGO			CODIGO_SHOJU,
	   DB_JSHO_DESCR			DESCRICAO_SHOJU
  FROM DB_JUSTSHOPPING
