---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	10/07/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
CREATE  VIEW  MVA_LOGRADOUROS AS
SELECT DB_LOGR_CODIGO	CODIGO_LOGRA,
       DB_LOGR_DESCR	DESCRICAO_LOGRA
  FROM DB_LOGRADOURO
