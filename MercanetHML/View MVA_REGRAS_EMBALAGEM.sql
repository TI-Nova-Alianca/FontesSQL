ALTER VIEW MVA_REGRAS_EMBALAGEM AS
 select codigo							codigo_REMB,
		SEQUENCIA						sequencia_REMB,
		isnull(TIPO_PEDIDO, '')			tipoPedido_REMB,
		isnull(TIPO_PRODUTO, '')		tipoProduto_REMB,
		isnull(MARCA_PRODUTO, '')		marcaProduto_REMB,
		isnull(FAMILIA_PRODUTO, '')		familiaProduto_REMB,
		isnull(GRUPO_PRODUTO, '')		grupoProduto_REMB,
		isnull(PRODUTO, '')				produto_REMB,
		isnull(REFERENCIA_PRODUTO, '')  referencia_REMB,
		PESO				peso_REMB
   from DB_REGRAS_EMBALAGEM
