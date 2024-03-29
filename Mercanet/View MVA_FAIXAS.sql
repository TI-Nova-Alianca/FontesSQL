---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/08/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_FAIXAS AS
SELECT CODIGO        CODIGO_FAI,
       DESCRICAO     DESCRICAO_FAI,
	   DATA_INICIAL  DATAINICIAL_FAI,
	   DATA_FINAL    DATAFINAL_FAI
  FROM DB_FAIXA
 WHERE DATA_FINAL >= GETDATE()
