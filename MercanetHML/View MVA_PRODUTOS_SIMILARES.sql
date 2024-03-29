---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	01/06/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW  MVA_PRODUTOS_SIMILARES AS
 SELECT CODIGO            CODIGO_PRODSI,
		DESCRICAO         DESCRICAO_PRODSI,
		DATA_INICIAL      DATAINICIAL_PRODSI,
		DATA_FINAL        DATAFINAL_PRODSI
   FROM DB_PROD_SIMILARES
  WHERE DATA_FINAL >= GETDATE()
