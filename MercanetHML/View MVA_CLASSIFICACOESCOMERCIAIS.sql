---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	30/04/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLASSIFICACOESCOMERCIAIS AS
 SELECT DB_TBCLS_CODIGO     CODIGO_CLCOM,
		DB_TBCLS_DESCRICAO  DESCRICAO_CLCOM
   FROM DB_TB_CLASS_COM
