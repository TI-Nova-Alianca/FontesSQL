---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	18/04/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ITENSCATIDIOMARESTR AS
 SELECT CATALOGO   CATALOGO_IREST,
		PRODUTO	   PRODUTO_IREST,
		IDIOMA	   IDIOMA_IREST,
		i.DATAALTER,
		I.USUARIO
   FROM DB_ITEM_IDIOMARESTR, MVA_ITENSCATALOGO  I
  WHERE CATALOGO = I.CATALOGO_ITCAT
    AND PRODUTO  = I.PRODUTO_ITCAT
