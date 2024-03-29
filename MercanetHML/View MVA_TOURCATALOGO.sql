---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   31/01/2014  tiago           incluido campo de ordem
-- 1.0002   30/11/2015  tiago           incluido campos especificoIdioma_TOUR e idiomas_TOUR
-- 1.0003   24/02/2016  TIAGO           INCLUIDO CAMPO DATAALTER
-- 1.0004   24/03/2106  tiago           ajustes para nao duplicar registros
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_TOURCATALOGO AS
SELECT DB_TOUR_CODIGO	    CODIGO_TOUR,
	   max(DB_TOUR_DESCRICAO)	DESCRICAO_TOUR,
	   DB_TOUR_SEQUENCIA	SEQUENCIA_TOUR,
	   max(DB_TOUR_TEMPLATE)	    TEMPLATE_TOUR,
	   max(DB_TOUR_ORDEM)        ORDEM_TOUR,
	   max(DB_TOUR_ESPECIDIOMA)  especificoIdioma_TOUR,
	   max(DB_TOUR_IDIOMAS)      idiomas_TOUR,
	   C.USUARIO,
	   max(case when isnull(DB_TOUR_ULT_ALTER, 0) > c.DATAALTER then DB_TOUR_ULT_ALTER else c.DATAALTER end) DATAALTER
  FROM DB_TOUR_CATALOGO, MVA_CATALOGOS C
 WHERE C.TOUR_CAT = DB_TOUR_CODIGO
 group by DB_TOUR_CODIGO, DB_TOUR_SEQUENCIA, C.USUARIO
