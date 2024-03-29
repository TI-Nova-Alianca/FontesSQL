---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	10/06/2014	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_LISTASSUGERIDASITENS AS
SELECT CODIGO_LISTA	CODIGOLISTA_LISSUGI,
	   CODIGO_PRODUTO	PRODUTO_LISSUGI,
	   SEQ_PRODUTO	SEQUENCIAPRODUTO_LISSUGI,
	   L.USUARIO USUARIO
   FROM DB_CAT_LISTASUG_PRODUTO, MVA_LISTASSUGERIDAS L
  WHERE CODIGO_LISTA = L.CODIGO_LISSUG
