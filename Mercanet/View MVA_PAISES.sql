---------------------------------------------------------------------------------------------
-- VERSAO  DATA        AUTOR     ALTERACAO
-- 1.0001  15/03/2013  TIAGO     DESENVOLVIMENTO
-- 1.0002  10/07/2013  tiago     incluido campo nome abrev
---------------------------------------------------------------------------------------------
ALTER VIEW MVA_PAISES AS 
SELECT DB_PAIS_SIGLA  SIGLA_PAIS,
       DB_PAIS_NOME   NOME_PAIS,
	   DB_PAIS_ABREV  NOMEABREVIADO_PAIS
  FROM DB_TB_PAIS
