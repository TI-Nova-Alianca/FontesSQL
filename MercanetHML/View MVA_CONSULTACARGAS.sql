---------------------------------------------------------------------------------------------------
-- VERSAO	DATA	    AUTOR	    ALTERACAO
-- 1.0000   23/04/2015  TIAGO     DESENVIMENTO
---------------------------------------------------------------------------------------------------
CREATE  VIEW MVA_CONSULTACARGAS  AS
SELECT CODIGO           CODIGO_CONCAR,
	   NOME  	          NOME_CONCAR,  
	   CONSULTA         CONSULTA_CONCAR , 
	   COLUNA_CARGA	    COLUNACARGA_CONCAR,  
	   COLUNA_CONSULTA	COLUNACONSULTA_CONCAR,
	   C.USUARIO
  FROM MVA_CONSULTAS C, DB_MOB_CARGAS
 WHERE CONSULTA = CODIGO_CONsu
