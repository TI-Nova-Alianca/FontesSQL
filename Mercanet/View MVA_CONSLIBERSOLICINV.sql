---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	09/02/2017	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CONSLIBERSOLICINV AS
 select CODIGO				codigo_CONLIBI,
		NOME				nome_CONLIBI,
		CONSULTA			consulta_CONLIBI,
		COLUNA_LIBERACAO	colunaLiberacao_CONLIBI, 
		COLUNA_CONSULTA		colunaConsulta_CONLIBI,
		c.USUARIO
   from DB_MOB_CONS_LIBER_SOLIC_INV,MVA_CONSULTAS c
  where c.CODIGO_CONSU = CONSULTA
