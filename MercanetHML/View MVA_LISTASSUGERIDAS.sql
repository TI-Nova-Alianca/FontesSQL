---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	10/06/2014	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
 ALTER VIEW MVA_LISTASSUGERIDAS AS
SELECT CODIGO	       CODIGO_LISSUG,
	   DESCRICAO	   DESCRICAO_LISSUG,
	   CATALOGO	       CATALOGO_LISSUG,
	   DATAVALINI	   DATAVALIDADEINICIAL_LISSUG,
	   DATAVALFIM	   DATAVALIDADEFINAL_LISSUG,
	   C.USUARIO       USUARIO
  FROM DB_CAT_LISTA_SUGERIDA, MVA_CATALOGOS C
 WHERE CATALOGO = C.CODIGO_CAT
   AND GETDATE() BETWEEN DATAVALINI AND DATAVALFIM
