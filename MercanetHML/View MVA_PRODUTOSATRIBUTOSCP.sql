ALTER VIEW MVA_PRODUTOSATRIBUTOSCP AS
SELECT PRODUTO								produto_ATCPRO,
       ATRIBUTO								atributo_ATCPRO,
	   ORDEM								ordem_ATCPRO,
	   OBRIGATORIO							obrigatorio_ATCPRO,
	   COD_ESTENDIDO						codEstendido_ATCPRO,
	   VALOR								valor_ATCPRO,
	   ISNULL(DATA_ALTERACAO, GETDATE())	dataalter,
	   MVA_PROD.usuario
  FROM DB_PRODUTO_ATRIB_CP,
	   MVA_PRODUTOS							MVA_PROD
 WHERE PRODUTO = MVA_PROD.codigo_PRODU
