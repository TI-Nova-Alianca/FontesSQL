---------------------------------------------------------------------------------------------------
-- VERSAO	DATA	    AUTOR	    ALTERACAO
-- 1.0000   01/09/2015  TIAGO     DESENVIMENTO
---------------------------------------------------------------------------------------------------
CREATE  VIEW MVA_CONSULTANOTASBONI  AS
SELECT CODIGO            CODIGO_CONNB,
	   NOME  	         NOME_CONNB,  
	   CONSULTA          CONSULTA_CONNB , 
	   COLUNA_NOTABONI	 COLUNANOTABONI_CONNB,  
	   COLUNA_CONSULTA	 COLUNACONSULTA_CONNB,
	   C.USUARIO
  FROM MVA_CONSULTAS C, DB_MOB_NOTAS_BONI
 WHERE CONSULTA = CODIGO_CONSU
