---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	10/07/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
CREATE  VIEW  MVA_OPCOESENTREGA AS
SELECT DB_OPCE_CODIGO	CODIGO_OPCENT,
       DB_OPCE_DESCR	DESCRICAO_OPCENT
  FROM DB_OPC_CLIENTE
