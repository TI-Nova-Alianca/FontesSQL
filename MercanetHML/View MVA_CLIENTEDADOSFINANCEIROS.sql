---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	10/07/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   14/08/2013  tiago           incluido campo mobile
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTEDADOSFINANCEIROS AS
SELECT 	DB_CLIF_CODIGO    CLIENTE_CLIFIN,
        DB_CLIF_OPCAO     OPCAO_CLIFIN,
	    DB_CLIF_TIPO      TIPO_CLIFIN,
		DB_CLIF_DESCR     DESCRICAO_CLIFIN,
		DB_CLIF_ANO       ANO_CLIFIN,
		DB_CLIF_VALOR     VALOR_CLIFIN,
		DB_CLIF_SITUACAO  SITUACAO_CLIFIN,
		DB_CLIF_SEQ       SEQUENCIA_CLIFIN,
		0                   MOBILE_CLIFIN ,
		CLI.USUARIO
   FROM	DB_CLIENTE_FINANC,
        MVA_CLIENTE CLI
  WHERE CLI.CODIGO_CLIEN = DB_CLIF_CODIGO
