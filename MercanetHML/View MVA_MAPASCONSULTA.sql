---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   22/04/2015	TIAGO PRADELLA	   CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MAPASCONSULTA AS
 SELECT CONSULTA	CONSULTA_MAPA,
		COLUNA	    COLUNA_MAPA,
		LABEL	    LABEL_MAPA,
		SEQUENCIA	SEQUENCIA_MAPA,
		CONS.USUARIO
  FROM MVA_CONSULTAS CONS, DB_CONS_MAPA
 WHERE CONS.CODIGO_CONSU = CONSULTA
