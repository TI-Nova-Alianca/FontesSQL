---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	10/07/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
CREATE  VIEW  MVA_CLASSIFICACOESFISCAIS AS
SELECT DB_CLICF_CODIGO 	CODIGO_CLAFIS,
       DB_CLICF_DESCR	DESCRICAO_CLAFIS
  FROM DB_CLIENTE_CLASFIS
