ALTER VIEW MVA_CLIENTEVALORESPADRAO AS
SELECT CAMPO	     campo_CLIVALPA,
       VALOR_PADRAO	 valorPadrao_CLIVALPA
  FROM DB_CONFIGURACAO_CAMPOS	
 WHERE CADASTRO = 0
   and isnull(VALOR_PADRAO, '') <> ''
   AND (TIPO_CONTATO = 0 OR isnull(TIPO_CONTATO, '') = '')
