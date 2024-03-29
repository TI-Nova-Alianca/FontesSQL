---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   20/10/2015  tiago           incluido campo sequencia
-- 1.0002   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
-- 1.0003   02/03/2016  tiago           incluida ligacao do catalogo
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ITENSCARACTERISTICAS AS
SELECT DB_ITCR_PRODUTO	        PRODUTO_ITCAR,
	   DB_ITCR_CATALOGO	        CATALOGO_ITCAR,
	   DB_ITCR_CARACTERISTICA	CARACTERISTICA_ITCAR,
	   DB_ITCR_SEQUENCIA        SEQUENCIA_ITCAR,
	   I.USUARIO,
	   I.DATAALTER
  FROM DB_ITEM_CARAC, MVA_ITENSCATALOGO I
 WHERE I.PRODUTO_ITCAT = DB_ITCR_PRODUTO
   and DB_ITCR_CATALOGO = i.CATALOGO_ITCAT
