---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SHOPPINGOCORRENCIAS  AS
SELECT DB_TBOCOR_CODIGO   CODIGO_SHOCO,
       DB_TBOCOR_DESCR DESCRICAO_SHOCO
  FROM DB_TB_OCORRENCIA
