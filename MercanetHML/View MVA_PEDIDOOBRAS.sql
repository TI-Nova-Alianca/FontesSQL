ALTER VIEW MVA_PEDIDOOBRAS AS
select PEDIDO				pedido_POBRA,
       OBRA					obra_POBRA,
	   LINHA_CONCORRENTE	linhaConcorrente_POBRA,
	   SOLIC_APOIO			solicitacaoApoio_POBRA,
	   MVA_PEDIDOS.dataalter,
	   MVA_PEDIDOS.usuario
  from DB_PEDIDO_OBRA, MVA_PEDIDOS
 where MVA_PEDIDOS.codigo_PEDID = PEDIDO
