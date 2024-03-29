---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	14/07/2017	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CONSULTAORDENACAO  AS
 SELECT	CONSULTA	CONSULTA_ORDER,
		SEQUENCIA	SEQUENCIA_ORDER,
		COLUNA		COLUNA_ORDER,
		FORMATO		FORMATO_ORDER,
		CONS.USUARIO
   FROM DB_CONS_ORDENACAO
      , MVA_CONSULTAS CONS
  WHERE CONS.CODIGO_CONSU = CONSULTA
