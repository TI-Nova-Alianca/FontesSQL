---------------------------------------------------------------------------------------------------
-- VERSAO	DATA	    AUTOR	    ALTERACAO
-- 1.0000   15/02/2016  TIAGO     DESENVIMENTO
---------------------------------------------------------------------------------------------------
CREATE  VIEW MVA_CONSULTALIBERACAO  AS
SELECT CODIGO            CODIGO_CONLIB,
	   NOME  	         NOME_CONLIB,  
	   CONSULTA          CONSULTA_CONLIB , 
	   COLUNA_LIBERACAO	 COLUNALIBERACAO_CONLIB,  
	   COLUNA_CONSULTA	 COLUNACONSULTA_CONLIB,
	   C.USUARIO
  FROM MVA_CONSULTAS C, DB_MOB_CONS_LIBERACAO
 WHERE CONSULTA = CODIGO_CONSU
