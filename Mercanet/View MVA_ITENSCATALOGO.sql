---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ITENSCATALOGO AS
SELECT DB_ITCA_PRODUTO	       PRODUTO_ITCAT,
	   DB_ITCA_CATALOGO	       CATALOGO_ITCAT,
	   DB_ITCA_TXTAPELO	       TEXTOAPELO_ITCAT,
	   DB_ITCA_TXTDESCRITIVO   TEXTODESCRITIVO_ITCAT,
	   DB_ITCA_SELO	           SELO_ITCAT,
	   C.USUARIO,
	   case when isnull(DB_ITCA_ULT_ALTER, 0) > isnull(p.DATA_PERMC, 0) then DB_ITCA_ULT_ALTER else p.DATA_PERMC end   DATAALTER
  FROM DB_ITEM_CATALOGO, MVA_CATALOGOS C, MVA_PERMISSOESCATALOGO p
 WHERE C.CODIGO_CAT = DB_ITCA_CATALOGO
   and p.CATALOGO_PERMC = DB_ITCA_CATALOGO
   and p.USUARIO = c.USUARIO
