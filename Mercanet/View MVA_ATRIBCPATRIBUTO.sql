ALTER VIEW MVA_ATRIBCPATRIBUTO AS
SELECT ATRIBUTO								atributo_ATRIBCP,
       DESCRICAO							descricao_ATRIBCP,
	   APRESENTACAO							apresentacao_ATRIBCP,
	   CAD_CONTEUDO_ATRIB					cadConteudoAtrib_ATRIBCP,
	   TP_DADO								tpDado_ATRIBCP,
	   TAMANHO								tamanho_ATRIBCP,
	   NRO_DECIMAL							nroDecimal_ATRIBCP,
	   PESO_PROD_BASE						pesoProdBase_ATRIBCP,
	   PESO_ATRIB_PRINCIPAL					pesoAtribPrincipal_ATRIBCP,
	   MULTIPLICADOR						multiplicador_ATRIBCP,
	   REST_LOCAL_MARCACAO					restLocalMarcacao_ATRIBCP,
	   ATRIB_PRINCIPAL						atribPrincipal_ATRIBCP,
	   ISNULL(DATA_ALTERACAO, GETDATE())	dataalter
  FROM DB_ATRIB_CP_ATRIBUTO
