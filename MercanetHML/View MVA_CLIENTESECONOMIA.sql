---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	11/12/2014	TIAGO PRADELLA	CRIACAO
-- 1.0002   19/11/2015  tiago           incluido campo HISTORICO_CLIECO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTESECONOMIA AS
 SELECT	DB_CLIE_CODIGO     CLIENTE_CLIECO,			
		DB_CLIE_SEQ        SEQUENCIA_CLIECO,		
		DB_CLIE_DESCTO     DESCONTO_CLIECO,		
		DB_CLIE_DATAINI    DATAINICIAL_CLIECO, 			
		DB_CLIE_DATAFIN    DATAFINAL_CLIECO,	
		DB_CLIE_TIPO       TIPO_CLIECO,	
		DB_CLIE_HISTCC     HISTORICO_CLIECO,	
		DB_CLIE_FAMILIA    FAMILIA_CLIECO,
		CLI.USUARIO
  FROM DB_CLIENTE_ECON, MVA_CLIENTE CLI
 WHERE CLI.CODIGO_CLIEN = DB_CLIE_CODIGO
   AND cast(DB_CLIE_DATAFIN as date) >= cast(GETDATE() as date)
  -- AND (SELECT ISNULL(DB_PRM_LCPED_ANAL, 0) FROM DB_PARAMETRO) <> 0
